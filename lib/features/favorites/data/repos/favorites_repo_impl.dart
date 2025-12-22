import 'package:injectable/injectable.dart';
import '../data_sources/favorites_remote_data_source.dart';
import '../models/favorite_branch_model.dart';
import 'favorites_repo.dart';

@LazySingleton(as: FavoritesRepo)
class FavoritesRepoImpl implements FavoritesRepo {
  final FavoritesRemoteDataSource remote;

  FavoritesRepoImpl(this.remote);

  @override
  Future<List<FavoriteBranchModel>> getFavorites() {
    return remote.getFavorites();
  }

  @override
  Future<void> removeFavorite(String id) {
    return remote.removeFavorite(id);
  }
}
