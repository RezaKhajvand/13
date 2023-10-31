import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/pages/profile_page/profilepage.dart';
import 'package:vpn/utils/authmanager.dart';
import 'package:vpn/utils/navigator.dart';
import 'package:vpn/utils/openurl.dart';
import 'package:vpn/utils/vpn_manager.dart';
import 'package:vpn/widgets/configscard.dart';
import 'package:vpn/widgets/getbutton.dart';
import 'package:vpn/widgets/gettimer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //nativeside
  final String statusEventChannel = "com.v2ray.ang/status_event_channel";
  final Uri url = Uri.parse('https://13v.site');
  late StreamSubscription eventChannelListener;
  VpnStatus _vpnStatus = VpnStatus.disconnect;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() {
    final EventChannel statusstream = EventChannel(statusEventChannel);
    eventChannelListener = statusstream.receiveBroadcastStream().listen(
      (data) async {
        _vpnStatus = VpnStatus.values.firstWhere((e) => e.code == (data ?? 2));
        await AuthManager.saveConnect(
            _vpnStatus == VpnStatus.connect ? true : false);
        
        BlocProvider.of<VpnStatusBloc>(context).add(GetStatus(_vpnStatus));
      },
    );
  }

  @override
  void dispose() {
    eventChannelListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: CustomColors.circlebutton,
                      child: IconButton(
                          splashRadius: 30,
                          onPressed: () =>
                              CustomNav.push(context, const ProfilePage()),
                          icon: SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/profile.png'))),
                    ),
                    const Text(
                      '13VPN',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: CustomColors.circlebutton,
                      child: IconButton(
                          onPressed: () => open13url(url),
                          icon: SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/premium.png'))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<GetConfigBloc, GetConfigState>(
              builder: (context, state) {
                if (state is ConfigChanged) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GetTimer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GetButton(config: state.bestconfig),
                          const SizedBox(
                            height: 60,
                          ),
                          ConfigCard(
                              image: state.bestconfig.image,
                              remark: state.bestconfig.remark),
                        ],
                      )
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
