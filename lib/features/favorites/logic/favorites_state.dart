import '../data/models/favorite_branch_model.dart';

sealed class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesEmpty extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<FavoriteBranchModel> items;

  FavoritesSuccess(this.items);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
