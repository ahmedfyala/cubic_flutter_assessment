import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../logic/map_cubit.dart';
import '../../logic/map_state.dart';
import '../widgets/location_details_sheet.dart';

class BranchesMapScreen extends StatefulWidget {
  const BranchesMapScreen({super.key});

  @override
  State<BranchesMapScreen> createState() => _BranchesMapScreenState();
}

class _BranchesMapScreenState extends State<BranchesMapScreen> {
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().getNearestBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Branches & ATMs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapSuccess) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(state.userLat, state.userLng),
                zoom: 13,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: state.locations.map((loc) {
                return Marker(
                  markerId: MarkerId(loc.id),
                  position: LatLng(loc.lat, loc.lng),
                  onTap: () async {
                    if (_isBottomSheetOpen || !loc.isActive) return;
                    _isBottomSheetOpen = true;

                    bool isFav = false;
                    try {
                      isFav = await context
                          .read<MapCubit>()
                          .checkIsFavorite(loc.id)
                          .timeout(const Duration(seconds: 2));
                    } catch (_) {
                      isFav = false;
                    }

                    if (!mounted) return;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (_) => LocationDetailsSheet(
                        location: loc,
                        initialIsFavorite: isFav,
                        onAdd: () =>
                            context.read<MapCubit>().addToFavorites(loc),
                        onRemove: () => context
                            .read<MapCubit>()
                            .removeFromFavorites(loc.id),
                      ),
                    ).whenComplete(() {
                      _isBottomSheetOpen = false;
                    });
                  },
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    loc.type == 'BRANCH'
                        ? BitmapDescriptor.hueAzure
                        : BitmapDescriptor.hueRed,
                  ),
                );
              }).toSet(),
            );
          }

          if (state is MapError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
