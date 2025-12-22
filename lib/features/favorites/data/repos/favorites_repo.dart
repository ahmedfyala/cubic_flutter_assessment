import '../models/favorite_branch_model.dart';

abstract class FavoritesRepo {
  Future<List<FavoriteBranchModel>> getFavorites();
  Future<void> removeFavorite(String id);
}
