import 'package:bloc/bloc.dart';
import 'package:vpn/utils/vpn_manager.dart';

part 'vpn_status_event.dart';
part 'vpn_status_state.dart';

class VpnStatusBloc extends Bloc<VpnStatusEvent, VpnStatusState> {
  VpnStatus vpnstatus = VpnStatus.disconnect;
  VpnStatusBloc() : super(VpnStatusState(vpnStatus: VpnStatus.disconnect)) {
    on<GetStatus>((event, emit) async {
      if (event.vpnStatus != null) {
        vpnstatus = event.vpnStatus!;
      }

      emit(VpnStatusState(vpnStatus: vpnstatus));
    });
  }
}
