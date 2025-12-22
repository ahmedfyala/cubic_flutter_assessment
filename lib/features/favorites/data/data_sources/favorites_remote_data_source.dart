import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../models/favorite_branch_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteBranchModel>> getFavorites();
  Future<void> removeFavorite(String id);
}

@LazySingleton(as: FavoritesRemoteDataSource)
class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoritesRemoteDataSourceImpl(this._firestore, this._auth);

  @override
  Future<List<FavoriteBranchModel>> getFavorites() async {
    final user = _auth.currentUser!;
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs
        .map((e) => FavoriteBranchModel.fromJson(e.data()))
        .toList();
  }

  @override
  Future<void> removeFavorite(String id) async {
    final user = _auth.currentUser!;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(id)
        .delete();
  }
}
