part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final ProfileData response;

  const ProfileSuccess(this.response);
}

final class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);
}

final class ProfileLoading extends ProfileState {}
