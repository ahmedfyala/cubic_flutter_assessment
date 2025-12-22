import '../../../map/data/models/location_model.dart';

class FavoriteBranchModel {
  final LocationModel location;

  FavoriteBranchModel({required this.location});

  factory FavoriteBranchModel.fromJson(Map<String, dynamic> json) {
    return FavoriteBranchModel(location: LocationModel.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return location.toJson();
  }
}
