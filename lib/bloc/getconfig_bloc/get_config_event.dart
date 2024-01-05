part of 'get_config_bloc.dart';

abstract class GetConfigEvent extends Equatable {}

class ChangeConfig extends GetConfigEvent {
  final HiveConfig config;
  final bool isConnected;

  ChangeConfig(this.config, this.isConnected);

  @override
  List<Object?> get props => [config];
}

class GetApiConfigs extends GetConfigEvent {
  @override
  List<Object?> get props => [];
}

class GetCachedConfigs extends GetConfigEvent {
  @override
  List<Object?> get props => [];
}

class PingAllConfigs extends GetConfigEvent {
  final String link;
  final String ping;

  PingAllConfigs({required this.link, required this.ping});
  @override
  List<Object?> get props => [];
}

class ResetAllPings extends GetConfigEvent {
  @override
  List<Object?> get props => [];
}
