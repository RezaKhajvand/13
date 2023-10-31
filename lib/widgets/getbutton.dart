import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/timer_bloc/timer_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/models/configmodel.dart';
import 'package:vpn/utils/timermanager.dart';
import 'package:vpn/utils/vpn_manager.dart';

class GetButton extends StatelessWidget {
  final Config config;
  const GetButton({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VpnStatusBloc, VpnStatusState>(
      buildWhen: (previous, current) =>
          current is VpnStatusConnected || current is VpnStatusDisconnected,
      listener: (context, state) {
        if (state is VpnStatusConnected) {
          BlocProvider.of<TimerBloc>(context).add(StartTimer());
        }
        if (state is VpnStatusConnecting) {}
        if (state is VpnStatusDisconnected) {
          BlocProvider.of<TimerBloc>(context).add(StopTimer());
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (state is VpnStatusConnected) {
              await VpnManager().disconnect();
              await TimerManager.cleartimer();
            }
            if (state is VpnStatusConnecting) {
              await VpnManager().disconnect();
            }
            if (state is VpnStatusDisconnected) {
              print(config.link);
              await VpnManager().connect(config.link);

              var now = DateTime.now();
              await TimerManager.saveTimer(now);
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
                  width: state is VpnStatusConnected ? 2 : 0.8,
                  color: state is VpnStatusConnected
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
                  visible: state is VpnStatusConnected ? false : true,
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
                  visible: state is VpnStatusDisconnected ? false : true,
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
                  alignment: state is VpnStatusConnected
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: state is VpnStatusConnected
                          ? CustomColors.secendry
                          : CustomColors.buttondeactive,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      size: 30,
                      color: state is VpnStatusConnected ? null : Colors.white,
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
