part of 'get_config_bloc.dart';

abstract class GetConfigEvent extends Equatable {}

class ChangeConfig extends GetConfigEvent {
  final Config bestconfig;
  final bool isConnected;

  ChangeConfig(this.bestconfig, this.isConnected);

  @override
  List<Object?> get props => [bestconfig];
}

class GetConfigs extends GetConfigEvent {
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
  final Config bestconfig;

  PingAllConfigs(
      {required this.link, required this.ping, required this.bestconfig});
  @override
  List<Object?> get props => [];
}

class ResetAllPings extends GetConfigEvent {
   final Config bestconfig;
  ResetAllPings(this.bestconfig);
  @override
  List<Object?> get props => [];
}
