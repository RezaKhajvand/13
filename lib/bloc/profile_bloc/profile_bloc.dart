import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vpn/data/profile_datasource.dart';

import '../../models/profilemodel.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        var response = await ProfileDataSource().getProfileData();
        emit(ProfileSuccess(response));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
