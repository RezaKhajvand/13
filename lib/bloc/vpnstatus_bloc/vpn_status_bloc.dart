import 'package:bloc/bloc.dart';
import 'package:vpn/utils/vpn_manager.dart';

part 'vpn_status_event.dart';
part 'vpn_status_state.dart';

class VpnStatusBloc extends Bloc<VpnStatusEvent, VpnStatusState> {
  VpnStatusBloc() : super(VpnStatusDisconnected()) {
    on<GetStatus>((event, emit) {
      if (event.vpnStatus == VpnStatus.connecting) {
        emit(VpnStatusConnecting());
      }
      if (event.vpnStatus == VpnStatus.connect) {
        emit(VpnStatusConnected());
      }
      if (event.vpnStatus == VpnStatus.disconnect) {
        emit(VpnStatusDisconnected());
      }
    });
  }
}
