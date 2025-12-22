import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../logic/favorites_cubit.dart';
import '../../logic/favorites_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          /// ✅ Loading → Skeleton ONLY
          if (state is FavoritesLoading) {
            return const FavoritesSkeleton();
          }

          /// ✅ Empty State
          if (state is FavoritesEmpty) {
            return const EmptyStateView(
              asset: AppAssets.emptyState,
              title: 'No favorites yet',
              description:
                  'You haven’t added any branches to your favorites yet.',
            );
          }

          /// ✅ Success
          if (state is FavoritesSuccess) {
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = state.items[index];

                return FavoriteBranchCard(
                  model: item,
                  onRemove: () {
                    context.read<FavoritesCubit>().removeFavorite(
                      item.location.id,
                    );
                  },
                );
              },
            );
          }

          /// ✅ Error (بدون Loader)
          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
