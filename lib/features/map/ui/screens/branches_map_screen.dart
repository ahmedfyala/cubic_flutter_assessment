import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/notifier.dart';
import '../../logic/map_cubit.dart';
import '../../logic/map_state.dart';
import '../widgets/location_details_sheet.dart';
import '../widgets/map_skeleton_view.dart';

class BranchesMapScreen extends StatefulWidget {
  const BranchesMapScreen({super.key});

  @override
  State<BranchesMapScreen> createState() => _BranchesMapScreenState();
}

class _BranchesMapScreenState extends State<BranchesMapScreen> {
  bool _isBottomSheetOpen = false;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<MapCubit>().getNearestBranches(
      (location) => _handleMarkerTap(location),
    );
  }

  void _handleMarkerTap(dynamic loc) async {
    if (_isBottomSheetOpen) return;
    _isBottomSheetOpen = true;

    bool isFav = false;
    try {
      isFav = await context
          .read<MapCubit>()
          .checkIsFavorite(loc.id)
          .timeout(const Duration(seconds: 2));
    } catch (_) {}

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationDetailsSheet(
        location: loc,
        initialIsFavorite: isFav,
        onAdd: () => context.read<MapCubit>().addToFavorites(loc),
        onRemove: () => context.read<MapCubit>().removeFromFavorites(loc.id),
      ),
    ).whenComplete(() => _isBottomSheetOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Branches & ATMs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () => Navigator.pushNamed(context, RouteNames.favorites),
          ),
        ],
      ),
      body: BlocListener<MapCubit, MapState>(
        listener: (context, state) {
          if (state is MapSuccess && state.isFromCache) {
            Notifier.show(
              context: context,
              message: "Offline: Showing cached data",
              type: NotificationType.toast,
            );
          }
        },
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _buildContent(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(MapState state) {
    if (state is MapLoading) {
      return const MapSkeletonView(key: ValueKey('skeleton_view'));
    }

    if (state is MapSuccess) {
      return GoogleMap(
        key: const ValueKey('actual_map_view'),
        initialCameraPosition: CameraPosition(
          target: LatLng(state.userLat, state.userLng),
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: state.markers,
        zoomControlsEnabled: false,

        onMapCreated: (controller) => _mapController = controller,
      );
    }

    if (state is MapError) {
      return Center(
        key: const ValueKey('error_view'),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(state.message, textAlign: TextAlign.center),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
