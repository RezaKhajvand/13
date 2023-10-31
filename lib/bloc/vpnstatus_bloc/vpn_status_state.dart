part of 'vpn_status_bloc.dart';

abstract class VpnStatusState {}

class VpnStatusDisconnected extends VpnStatusState {}

class VpnStatusConnecting extends VpnStatusState {}

class VpnStatusConnected extends VpnStatusState {}
