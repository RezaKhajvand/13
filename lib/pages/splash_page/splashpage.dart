import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/models/configmodel.dart';
import 'package:vpn/pages/home_page/homepage.dart';
import 'package:vpn/pages/login_page/loginpage.dart';
import 'package:vpn/utils/authmanager.dart';
import 'package:vpn/utils/navigator.dart';
import 'package:vpn/utils/vpn_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String allRealPingEventChannel =
      "com.v2ray.ang/all_real_ping_event_channel";

  List<Config> configlist = [];
  StreamSubscription? eventChannelListener;
  bool firstrealping = true;
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  @override
  void initState() {
    super.initState();
    if (AuthManager.readConnect() == true) {
      BlocProvider.of<GetConfigBloc>(context).add(GetCachedConfigs());
    } else if (hiveConfig.values.isNotEmpty) {
      handleVpnPingChanges();
      BlocProvider.of<GetConfigBloc>(context).add(GetCachedConfigs());
    } else {
      handleVpnPingChanges();
      BlocProvider.of<GetConfigBloc>(context).add(GetConfigs());
    }
  }

  handleVpnPingChanges() async {
    List<Map<String, double>> pinglist = [];
    final EventChannel stream = EventChannel(allRealPingEventChannel);
    eventChannelListener =
        stream.receiveBroadcastStream('pingall').listen((data) {
      final response = jsonDecode(data);
      pinglist
          .add({'${response['first']}': double.parse('${response['second']}')});
      if (pinglist.length == 1) {
        var bestconfig = configlist
            .where((element) => element.link == pinglist.first.keys.first);
        if (pinglist.first.values.first == -1 && firstrealping) {
          firstrealping = false;
          BlocProvider.of<GetConfigBloc>(context).add(GetConfigs());
        } else {
          BlocProvider.of<GetConfigBloc>(context)
              .add(ChangeConfig(bestconfig.first, false));
          CustomNav.pushReplacement(context, const MyHomePage());
        }
      }
    });
  }

  @override
  void dispose() {
    if (eventChannelListener != null) {
      print('eventChannelListener cancled');
      eventChannelListener!.cancel();
    }
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
        body: BlocConsumer<GetConfigBloc, GetConfigState>(
          listener: (context, state) async {
            if (state is ConfigLoaded) {
              configlist = state.configlist;
              if (AuthManager.readConnect() == true) {
                var activecnfig = configlist
                    .where((element) =>
                        element.link ==
                        hiveConfig.values
                            .toList()
                            .where((element) => element.isclicked == true)
                            .first
                            .link)
                    .toList()
                    .first;

                BlocProvider.of<GetConfigBloc>(context)
                    .add(ChangeConfig(activecnfig, false));
                CustomNav.pushReplacement(context, const MyHomePage());
              } else if (hiveConfig.values.isNotEmpty) {
                if (firstrealping) {
                  VpnManager().testAllRealPing(List.generate(
                      configlist.length, (index) => configlist[index].link));
                } else {
                  CustomNav.pushReplacement(context, const MyHomePage());
                }
              } else {
                if (firstrealping) {
                  VpnManager().testAllRealPing(List.generate(
                      configlist.length, (index) => configlist[index].link));
                } else {
                  CustomNav.pushReplacement(context, const MyHomePage());
                }
              }
            }
          },
          builder: (context, state) {
            if (state is! ConfigError) {
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
                            fontFamily: 'Alatsi',
                            fontSize: 36,
                            letterSpacing: 5,
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
            }
            return Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error,
                    style: const TextStyle(color: Colors.white),
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
                                  .add(GetConfigs()),
                          child: const Text('Retry'))),
                  const SizedBox(height: 16),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () =>
                          CustomNav.pushAndRemove(context, const LoginPage()),
                      child: const Text(
                        'Cancle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
