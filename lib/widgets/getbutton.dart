import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/timer_bloc/timer_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/utils/timermanager.dart';
import 'package:vpn/utils/vpn_manager.dart';

class GetButton extends StatefulWidget {
  const GetButton({
    super.key,
  });

  @override
  State<GetButton> createState() => _GetButtonState();
}

class _GetButtonState extends State<GetButton> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VpnStatusBloc>(context).add(GetStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VpnStatusBloc, VpnStatusState>(
      listener: (context, state) {
        if (state.vpnStatus == VpnStatus.connect) {
          BlocProvider.of<TimerBloc>(context).add(StartTimer());
        }

        if (state.vpnStatus == VpnStatus.disconnect) {
          BlocProvider.of<TimerBloc>(context).add(StopTimer());
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (state.vpnStatus == VpnStatus.connect) {
              await VpnManager().disconnect();
              await TimerManager.cleartimer();
            }
            if (state.vpnStatus == VpnStatus.connecting) {
              await VpnManager().disconnect();
            }
            if (state.vpnStatus == VpnStatus.disconnect) {
              var now = DateTime.now();
              await TimerManager.saveTimer(now);
              await VpnManager().connect();
            }
          },
          child: Container(
            width: 145,
            height: 70,
            decoration: ShapeDecoration(
              gradient: CustomColors.powergradient,
              shadows: const [
                BoxShadow(
                  color: CustomColors.blackshadow,
                  blurRadius: 20,
                  offset: Offset(0, 12),
                  spreadRadius: 2,
                ),
              ],
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: state.vpnStatus == VpnStatus.connect ? 2 : 0.8,
                  color: state.vpnStatus == VpnStatus.connect
                      ? CustomColors.secendry
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(56),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: state.vpnStatus == VpnStatus.connect ? false : true,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.keyboard_double_arrow_right,
                            color: CustomColors.buttonhint,
                            size: 24,
                          ),
                          Text(
                            'START',
                            style: TextStyle(
                              color: CustomColors.buttonhint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      state.vpnStatus == VpnStatus.disconnect ? false : true,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'STOP',
                            style: TextStyle(
                              color: CustomColors.buttonhint,
                              fontSize: 12,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_double_arrow_left,
                            color: CustomColors.buttonhint,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  alignment: state.vpnStatus == VpnStatus.connect
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: state.vpnStatus == VpnStatus.connect
                          ? CustomColors.secendry
                          : CustomColors.buttondeactive,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      size: 30,
                      color: state.vpnStatus == VpnStatus.connect
                          ? null
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
