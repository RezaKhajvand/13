part of 'vpn_status_bloc.dart';


abstract class VpnStatusEvent {}

class GetStatus extends VpnStatusEvent {
  final VpnStatus vpnStatus;

  GetStatus(this.vpnStatus);
}
