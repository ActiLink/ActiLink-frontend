import 'package:core/core.dart';

enum HobbiesStatus { initial, loading, success, failure }

class HobbiesState {
  const HobbiesState({
    this.hobbies = const [],
    this.status = HobbiesStatus.initial,
    this.error = '',
  });
  final List<Hobby> hobbies;
  final HobbiesStatus status;
  final String error;

  HobbiesState copyWith({
    List<Hobby>? hobbies,
    HobbiesStatus? status,
    String? error,
  }) {
    return HobbiesState(
      hobbies: hobbies ?? this.hobbies,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
