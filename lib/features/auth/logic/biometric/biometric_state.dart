sealed class BiometricsState {}

final class BiometricsInitial extends BiometricsState {}

final class BiometricsLoading extends BiometricsState {}

final class BiometricsSuccess extends BiometricsState {}

final class BiometricsFailure extends BiometricsState {
  final String message;
  BiometricsFailure(this.message);
}
