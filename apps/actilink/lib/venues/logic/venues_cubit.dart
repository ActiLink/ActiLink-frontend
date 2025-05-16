import 'dart:async';
import 'dart:developer';

import 'package:actilink/venues/logic/venues_state.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenuesCubit extends Cubit<VenuesState> {
  VenuesCubit({required VenueRepository venueRepository})
      : _venueRepository = venueRepository,
        super(const VenuesState());

  final VenueRepository _venueRepository;

  Future<void> fetchVenues() async {
    if (state.status == VenuesStatus.loading) return;
    emit(state.copyWith(status: VenuesStatus.loading, error: ''));
    try {
      final venues = await _venueRepository.getAllVenues();
      emit(state.copyWith(status: VenuesStatus.success, venues: venues));
      log('Fetched ${venues.length} venues successfully.');
    } on ApiException catch (e) {
      log('Error fetching venues: $e');
      emit(state.copyWith(status: VenuesStatus.failure, error: e.message));
    } catch (e) {
      log('Unexpected error fetching venues: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<bool> addVenue(Venue venue) async {
    emit(state.copyWith(status: VenuesStatus.loading));
    try {
      await _venueRepository.createVenue(venue);
      log('Venue added successfully: ${venue.name}');
      final venues = await _venueRepository.getAllVenues();
      emit(state.copyWith(status: VenuesStatus.success, venues: venues));
      return true;
    } on ApiException catch (e) {
      log('Error adding venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'Failed to add venue: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error adding venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'An unexpected error occurred while adding venue.',
        ),
      );
      return false;
    }
  }

  Future<bool> updateVenue(String id, Venue venue) async {
    emit(state.copyWith(status: VenuesStatus.loading));
    try {
      await _venueRepository.updateVenue(id, venue);
      log('Venue updated successfully: ${venue.name}');
      final venues = await _venueRepository.getAllVenues();
      emit(state.copyWith(status: VenuesStatus.success, venues: venues));
      return true;
    } on ApiException catch (e) {
      log('Error updating venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'Failed to update venue: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error updating venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'An unexpected error occurred while updating venue.',
        ),
      );
      return false;
    }
  }

  Future<bool> deleteVenue(String id) async {
    emit(state.copyWith(status: VenuesStatus.loading));
    try {
      await _venueRepository.deleteVenue(id);
      log('Venue deleted successfully: $id');
      final updatedVenues = state.venues.where((v) => v.id != id).toList();
      emit(state.copyWith(
        status: VenuesStatus.success,
        venues: updatedVenues,
        error: '',
      ),);
      return true;
    } on ApiException catch (e) {
      log('Error deleting venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'Failed to delete venue: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error deleting venue: $e');
      emit(
        state.copyWith(
          status: VenuesStatus.failure,
          error: 'An unexpected error occurred while deleting venue.',
        ),
      );
      return false;
    }
  }
}
