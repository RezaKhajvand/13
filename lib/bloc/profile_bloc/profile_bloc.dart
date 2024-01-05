import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vpn/data/datausage_datasource.dart';
import 'package:vpn/data/profile_datasource.dart';
import 'package:vpn/models/datausage_model.dart';

import '../../models/profilemodel.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        var response = await Future.wait([
          ProfileDataSource().getProfileData(),
          DataUsageDataSource().getDataUsage(),
        ]);
        final ProfileData profileData = profileDataFromJson(response.first);
        final DataUsage dataUsage = dataUsageFromJson(response.last);
        emit(ProfileSuccess(profileData: profileData, dataUsage: dataUsage));
      } on DioException catch (e) {
        emit((ProfileError(e.response?.data['message'] ?? 'Provider Error')));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
