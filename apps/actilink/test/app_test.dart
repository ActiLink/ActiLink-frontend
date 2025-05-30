import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/events_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_event.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  group('EventsCubit', () {
    late MockEventRepository mockRepository;

    setUp(() {
      mockRepository = MockEventRepository();
    });

    test('initial state is correct', () {
      final cubit = EventsCubit(eventRepository: mockRepository);
      expect(cubit.state, const EventsState());
    });

    blocTest<EventsCubit, EventsState>(
      'emits [loading, success] when fetchEvents succeeds',
      build: () {
        when(() => mockRepository.getAllEvents()).thenAnswer(
          (_) async => [TestEventFactory.create(id: '1')],
        );
        return EventsCubit(eventRepository: mockRepository);
      },
      act: (cubit) => cubit.fetchEvents(),
      expect: () => [
        const EventsState(status: EventsStatus.loading),
        EventsState(
          status: EventsStatus.success,
          events: [TestEventFactory.create(id: '1')],
        ),
      ],
    );

    blocTest<EventsCubit, EventsState>(
      'emits [loading, failure] when fetchEvents throws',
      build: () {
        when(() => mockRepository.getAllEvents())
            .thenThrow(ApiException('Exception'));
        return EventsCubit(eventRepository: mockRepository);
      },
      act: (cubit) => cubit.fetchEvents(),
      expect: () => [
        const EventsState(status: EventsStatus.loading),
        const EventsState(
          status: EventsStatus.failure,
          error: 'Boom',
        ),
      ],
    );
  });
}
