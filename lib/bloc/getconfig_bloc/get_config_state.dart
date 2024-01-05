part of 'get_config_bloc.dart';

abstract class GetConfigState {}

class ConfigInitial extends GetConfigState {}

class ConfigLoaded extends GetConfigState {
  final List<HiveConfig> configlist;
  final bool isGettingConfigs;

  ConfigLoaded({
    required this.configlist,
    this.isGettingConfigs = false,
  });
}

class ConfigLoading extends GetConfigState {}

class ConfigError extends GetConfigState {
  final String error;

  ConfigError(this.error);
}
