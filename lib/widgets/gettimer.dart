import 'dart:ui';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/utils/timermanager.dart';
import 'package:vpn/utils/vpn_manager.dart';
import 'package:vpn/widgets/stopwatch.dart';

class GetTimer extends StatelessWidget {
  const GetTimer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            BlocBuilder<VpnStatusBloc, VpnStatusState>(
              buildWhen: (previous, current) =>
                  current.vpnStatus == VpnStatus.connect ||
                  current.vpnStatus == VpnStatus.disconnect,
              builder: (context, state) {
                return AnimatedScale(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500),
                  scale: state.vpnStatus == VpnStatus.connect ? 1 : 0.9,
                  child: GestureDetector(
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
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: state.vpnStatus == VpnStatus.connect
                            ? [
                                const BoxShadow(
                                  color: CustomColors.primaryshadow,
                                  blurRadius: 60,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Image.asset('assets/imageball.png',
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.low),
                          AnimatedOpacity(
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 500),
                            opacity:
                                state.vpnStatus == VpnStatus.connect ? 1 : 0,
                            child: Lottie.asset(
                              'assets/data.zip',
                              filterQuality: FilterQuality.low,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipSmoothRect(
            radius: const SmoothBorderRadius.all(
              SmoothRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: CustomColors.glasscardfill.withOpacity(0.5),
                  shape: SmoothRectangleBorder(
                    borderAlign: BorderAlign.inside,
                    side: const BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter,
                        width: 1.0,
                        color: CustomColors.cardborder),
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                  ),
                ),
                child: BlocBuilder<VpnStatusBloc, VpnStatusState>(
                  buildWhen: (previous, current) =>
                      current.vpnStatus == VpnStatus.connect ||
                      current.vpnStatus == VpnStatus.disconnect,
                  builder: (context, state) {
                    var status = 'Disconnected';
                    if (state.vpnStatus == VpnStatus.connect) {
                      status = 'Connected';
                    }

                    if (state.vpnStatus == VpnStatus.disconnect) {
                      status = 'Disconnected';
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Text(
                        //   '192.168.80.62',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 30,
                        //     letterSpacing: 2,
                        //   ),
                        // ),
                        const StopWatch(),
                        const SizedBox(height: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: state.vpnStatus == VpnStatus.connect
                                ? CustomColors.secendry
                                : CustomColors.glasscardhint,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
