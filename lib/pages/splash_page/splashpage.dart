import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/pages/home_page/homepage.dart';
import 'package:vpn/pages/login_page/loginpage.dart';
import 'package:vpn/utils/navigator.dart';
import 'package:vpn/utils/openurl.dart';
import 'package:vpn/utils/vpn_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String allRealPingEventChannel =
      "com.v2ray.ang/all_real_ping_event_channel";

  List<HiveConfig> configlist = [];
  late StreamSubscription eventChannelListener;
  //
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  bool firsttestping = true;
  //

  @override
  void initState() {
    super.initState();
    handleVpnPingChanges();
    if (hiveConfig.values.isNotEmpty) {
      print('init from cached');
      BlocProvider.of<GetConfigBloc>(context).add(GetCachedConfigs());
    } else {
      print('init from api');
      BlocProvider.of<GetConfigBloc>(context).add(GetApiConfigs());
    }
  }

  handleVpnPingChanges() async {
    List<Map<String, double>> pinglist = [];
    final EventChannel stream = EventChannel(allRealPingEventChannel);
    eventChannelListener =
        stream.receiveBroadcastStream('pingall').listen((data) async {
      final response = jsonDecode(data);
      pinglist
          .add({'${response['first']}': double.parse('${response['second']}')});
      if (pinglist.length == 1) {
        var bestconfig = configlist
            .where((element) => element.link == pinglist.first.keys.first)
            .toList();
        firsttestping = false;
        BlocProvider.of<GetConfigBloc>(context)
            .add(ChangeConfig(bestconfig.first, false));
        CustomNav.pushReplacement(context, const MyHomePage());
      }
    });
  }

  @override
  void dispose() async {
    print('eventChannelListener cancled');
    eventChannelListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<VpnStatusBloc, VpnStatusState>(
          builder: (context, status) {
            return BlocConsumer<GetConfigBloc, GetConfigState>(
              listener: (context, state) {
                if (state is ConfigLoaded && firsttestping) {
                  if (status.vpnStatus == VpnStatus.connect) {
                    CustomNav.pushReplacement(context, const MyHomePage());
                  } else {
                    configlist = state.configlist;
                    VpnManager().testAllRealPing(List.generate(
                        configlist.length, (index) => configlist[index].link));
                  }
                }
              },
              builder: (context, state) {
                if (state is ConfigError) {
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            state.error,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: [Color(0xFF00E893), Color(0xFF009960)],
                              ),
                            ),
                            child: ElevatedButton(
                                onPressed: () =>
                                    BlocProvider.of<GetConfigBloc>(context)
                                        .add(GetApiConfigs()),
                                child: const Text('Retry'))),
                        const SizedBox(height: 16),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomColors.pimary),
                          child: ElevatedButton(
                            onPressed: () => open13url(
                                Uri.parse('https://13v.site/register')),
                            child: const Text(
                              'Get Premium Account',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: () => CustomNav.pushAndRemove(
                                context, const LoginPage()),
                            child: const Text(
                              'Cancle',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: CustomColors.primaryshadow.withOpacity(0.8),
                          blurRadius: 120,
                          offset: const Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ]),
                      child: ClipOval(
                        child: Image.asset('assets/metaball.png',
                            colorBlendMode: BlendMode.colorBurn,
                            color: Colors.white.withOpacity(0.05),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.low),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 32,
                              letterSpacing: 5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          children: [
                            TextSpan(text: '1'),
                            TextSpan(text: '3'),
                            TextSpan(text: 'VPN')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 180,
                      width: 180,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: CustomColors.secendry,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
