import 'dart:ui';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
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
                  current is VpnStatusConnected ||
                  current is VpnStatusDisconnected,
              builder: (context, state) {
                return AnimatedScale(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500),
                  scale: state is VpnStatusConnected ? 1 : 0.9,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: state is VpnStatusConnected
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
                            fit: BoxFit.fill, filterQuality: FilterQuality.low),
                        AnimatedOpacity(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                          opacity: state is VpnStatusConnected ? 1 : 0,
                          child: Lottie.asset(
                            'assets/data.zip',
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
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
                      current is VpnStatusConnected ||
                      current is VpnStatusDisconnected,
                  builder: (context, state) {
                    var status = 'Disconnected';
                    if (state is VpnStatusConnected) {
                      status = 'Connected';
                    }

                    if (state is VpnStatusDisconnected) {
                      status = 'Disconnected';
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const StopWatch(),
                        const SizedBox(height: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: state is VpnStatusConnected
                                ? CustomColors.secendry
                                : CustomColors.glasscardhint,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // FutureBuilder<String>(
                        //   future: getIP(),
                        //   builder: (context, snapshot) => snapshot.data != null
                        //       ? RichText(
                        //           maxLines: 1,
                        //           text: TextSpan(
                        //             style: const TextStyle(
                        //               color: CustomColors.glasscardhint,
                        //               fontSize: 14,
                        //               fontFamily: 'SpaceGrotesk',
                        //             ),
                        //             children: [
                        //               TextSpan(
                        //                   text: '${snapshot.data}',
                        //                   style: TextStyle(
                        //                       color: state is VpnStatusConnected
                        //                           ? CustomColors.secendry
                        //                           : CustomColors
                        //                               .glasscardhint)),
                        //             ],
                        //           ),
                        //         )
                        //       : const Text('Loading',
                        //           style: TextStyle(
                        //               color: CustomColors.glasscardhint)),
                        // )
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

// Future<String> getIP() async {
//   try {
//     await Future.delayed(const Duration(milliseconds: 300));
//     final dio = Dio();
//     final response = await dio
//         .get('https://api.ip2location.io/?key=00F5F10B8B442C2941E4D304CF77CBDC')
//         .timeout(const Duration(seconds: 6));
//     print(response.data['ip']);
//     print(response.data['as']);
//     return response.data['ip'];
//   } catch (e) {
//     print(e);
//     return 'Failed';
//   }
// }
