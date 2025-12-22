import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/notifier.dart';
import '../../../../generated/locale_keys.g.dart';
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
  bool _isMapReady = false;
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
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      isFav = false;
    }

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
    ).whenComplete(() {
      _isBottomSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.nearby_branches.tr()),
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
              message: LocaleKeys.offline_cached_msg.tr(),
              type: NotificationType.toast,
              bgColor: Colors.orange,
            );
          }
        },
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              _isMapReady = false;
              return const MapSkeletonView();
            }

            if (state is MapSuccess) {
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(state.userLat, state.userLng),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    markers: state.markers,
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          state.userLat - 0.05,
                          state.userLng - 0.05,
                        ),
                        northeast: LatLng(
                          state.userLat + 0.05,
                          state.userLng + 0.05,
                        ),
                      ),
                    ),
                    onMapCreated: (controller) async {
                      _mapController = controller;
                      await controller.moveCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(state.userLat, state.userLng),
                          14,
                        ),
                      );
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (!mounted) return;
                      setState(() => _isMapReady = true);
                    },
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _isMapReady ? 0 : 1,
                    child: IgnorePointer(
                      ignoring: _isMapReady,
                      child: const MapSkeletonView(),
                    ),
                  ),
                ],
              );
            }

            if (state is MapError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
