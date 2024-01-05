import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/utils/vpn_manager.dart';
import 'package:vpn/widgets/customappbar.dart';

class ConfigsPage extends StatefulWidget {
  const ConfigsPage({super.key});

  @override
  State<ConfigsPage> createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> {
  //nativeside
  final String allRealPingEventChannel =
      "com.v2ray.ang/all_real_ping_event_channel";
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  late List<HiveConfig> configslist;
  late HiveConfig clickedConfig;
  late StreamSubscription eventChannelListener;
  @override
  void initState() {
    super.initState();
    getpingAllConfigs();
  }

  getpingAllConfigs() {
    final EventChannel stream = EventChannel(allRealPingEventChannel);
    eventChannelListener =
        stream.receiveBroadcastStream('pingall').listen((data) {
      final response = jsonDecode(data);
      print(response);
      BlocProvider.of<GetConfigBloc>(context).add(PingAllConfigs(
        link: '${response['first']}',
        ping: '${response['second']}',
      ));
    });
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
            appBar: getCustomAppbar(
                context,
                [
                  IconButton(
                      splashRadius: 30,
                      onPressed: () {
                        BlocProvider.of<GetConfigBloc>(context)
                            .add(GetApiConfigs());
                      },
                      icon: BlocBuilder<GetConfigBloc, GetConfigState>(
                        builder: (context, state) {
                          return AnimatedRotation(
                            turns: state is ConfigLoading ? -10 : 0,
                            duration: Duration(
                                seconds: state is ConfigLoading? ? 10 : 0),
                            child: const Icon(
                              Icons.sync,
                              size: 20,
                            ),
                          );
                        },
                      )),
                  IconButton(
                      splashRadius: 30,
                      onPressed: () {
                        BlocProvider.of<GetConfigBloc>(context)
                            .add(ResetAllPings());
                        VpnManager().testAllRealPing(List.generate(
                            configslist.length,
                            (index) => configslist[index].link));
                      },
                      icon: const Icon(
                        Icons.speed,
                        size: 20,
                      )),
                ],
                title: 'Configs'),
            body: BlocBuilder<GetConfigBloc, GetConfigState>(
              builder: (context, state) {
                if (state is ConfigLoaded) {
                  configslist = state.configlist;
                  clickedConfig = configslist
                      .where((element) => element.isclicked)
                      .toList()
                      .first;
                } else {
                  configslist = hiveConfig.values.toList();
                  clickedConfig = configslist
                      .where((element) => element.isclicked)
                      .toList()
                      .first;
                }

                return ListView.separated(
                  itemCount: configslist.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    Color bordercolor = CustomColors.cardborder;
                    double borderwidth = 0.5;
                    if (configslist[index] == clickedConfig) {
                      bordercolor = CustomColors.secendry;
                      borderwidth = 8;
                    }
                    return BlocBuilder<VpnStatusBloc, VpnStatusState>(
                      builder: (context, statusstate) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: CustomColors.secendry,
                          onTap: () {
                            if (configslist[index] != clickedConfig) {
                              BlocProvider.of<GetConfigBloc>(context).add(
                                  ChangeConfig(
                                      configslist[index],
                                      statusstate.vpnStatus ==
                                          VpnStatus.connect));
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            padding: const EdgeInsets.all(16),
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.glasscardfill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                top: BorderSide(
                                  width: 0.5,
                                  color: bordercolor,
                                ),
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: bordercolor,
                                ),
                                right: BorderSide(
                                  width: 0.5,
                                  color: bordercolor,
                                ),
                                left: BorderSide(
                                  width: borderwidth,
                                  color: bordercolor,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 40,
                                    child:
                                        Image.asset(configslist[index].image)),
                                const SizedBox(width: 16),
                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: CustomColors.buttonhint,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        configslist[index].remark,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            configslist[index].type,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: CustomColors.buttonhint,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Builder(builder: (context) {
                                            Color pingcolor =
                                                CustomColors.secendry;
                                            if (configslist[index].ping != '') {
                                              double ping = double.parse(
                                                  configslist[index].ping);
                                              if (ping > 800 && ping <= 1600) {
                                                pingcolor = Colors.amber;
                                              } else if (ping <= 800 &&
                                                  ping > 0) {
                                                pingcolor =
                                                    CustomColors.secendry;
                                              } else {
                                                pingcolor = Colors.red;
                                              }
                                            }
                                            return Text(
                                              configslist[index].ping == ''
                                                  ? ''
                                                  : '${configslist[index].ping} ms',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: pingcolor,
                                                fontSize: 12,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                );
              },
            )
            //
            ),
      ),
    );
  }
}
