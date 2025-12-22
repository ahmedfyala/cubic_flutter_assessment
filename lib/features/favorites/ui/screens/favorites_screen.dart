import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../map/ui/widgets/location_details_sheet.dart';
import '../../logic/favorites_cubit.dart';
import '../../logic/favorites_state.dart';
import '../../../../core/utils/notifier.dart';
import '../widgets/favorite_branch_card.dart';
import '../widgets/favorites_skeleton.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  void _showDetails(dynamic loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationDetailsSheet(
        location: loc,
        initialIsFavorite: true, 
        onAdd: () async => true,
        onRemove: () async {
          await context.read<FavoritesCubit>().removeFavorite(loc.id);
          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites'), centerTitle: true),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) return const FavoritesSkeleton();
          if (state is FavoritesEmpty)
            return const EmptyStateView(
              asset: AppAssets.emptyState,
              title: 'No favorites yet',
              description: 'Your favorite branches will appear here.',
            );

          if (state is FavoritesSuccess) {
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return GestureDetector(
                  onTap: () => _showDetails(item.location), 
                  child: FavoriteBranchCard(
                    model: item,
                    onRemove: () => context
                        .read<FavoritesCubit>()
                        .removeFavorite(item.location.id),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
