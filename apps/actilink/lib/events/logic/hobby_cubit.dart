import 'package:actilink/events/logic/hobby_state.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HobbiesCubit extends Cubit<HobbiesState> {
  HobbiesCubit({required HobbyRepository hobbyRepository})
      : _hobbyRepository = hobbyRepository,
        super(const HobbiesState());

  final HobbyRepository _hobbyRepository;

  Future<void> fetchHobbies() async {
    if (state.status == HobbiesStatus.loading) return;
    emit(state.copyWith(status: HobbiesStatus.loading, error: ''));
    try {
      final hobbies = await _hobbyRepository.getAllHobbies();
      emit(state.copyWith(status: HobbiesStatus.success, hobbies: hobbies));
    } on ApiException catch (e) {
      emit(state.copyWith(status: HobbiesStatus.failure, error: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: HobbiesStatus.failure,
          error: 'Unexpected error fetching hobbies.',
        ),
      );
    }
  }
}
