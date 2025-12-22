import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repos/favorites_repo.dart';
import 'favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo repo;

  FavoritesCubit(this.repo) : super(FavoritesLoading());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final items = await repo.getFavorites();
      if (items.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        emit(FavoritesSuccess(items));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> removeFavorite(String id) async {
    await repo.removeFavorite(id);
    await loadFavorites();
  }
}
