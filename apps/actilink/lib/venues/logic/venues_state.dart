import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

enum VenuesStatus { initial, loading, success, failure }

class VenuesState extends Equatable {
  const VenuesState({
    this.status = VenuesStatus.initial,
    this.venues = const [],
    this.error = '',
  });

  final VenuesStatus status;
  final List<Venue> venues;
  final String error;

  VenuesState copyWith({
    VenuesStatus? status,
    List<Venue>? venues,
    String? error,
  }) {
    return VenuesState(
      status: status ?? this.status,
      venues: venues ?? this.venues,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, venues, error];
}
