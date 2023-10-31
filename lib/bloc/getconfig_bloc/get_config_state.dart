part of 'get_config_bloc.dart';

abstract class GetConfigState {}

class ConfigInitial extends GetConfigState {}

class ConfigChanged extends GetConfigState {
  final List<Config> configlist;
  final Config bestconfig;

  ConfigChanged({required this.configlist, required this.bestconfig});
}

class ConfigLoaded extends GetConfigState {
  final List<Config> configlist;
  final Config bestconfig;

  ConfigLoaded({required this.configlist, required this.bestconfig});
}

class ConfigLoading extends GetConfigState {}

class ConfigError extends GetConfigState {
  final String error;

  ConfigError(this.error);
}
