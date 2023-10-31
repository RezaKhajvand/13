import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/data/getconfig_datasource.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/models/configmodel.dart';
import 'package:vpn/utils/vpn_manager.dart';
part 'get_config_event.dart';
part 'get_config_state.dart';

class GetConfigBloc extends Bloc<GetConfigEvent, GetConfigState> {
  late List<Config> configsList;
  int activeindex = 0;
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  GetConfigBloc() : super(ConfigInitial()) {
    on<GetCachedConfigs>(
      (event, emit) async {
        emit(ConfigLoading());
        //Read from hive
        final List<HiveConfig> configs = hiveConfig.values.toList();

        configsList = List.generate(
            configs.length,
            (index) => Config(
                link: configs[index].link,
                remark: configs[index].link.contains('vless') ||
                        configs[index].link.contains('trojan')
                    ? configs[index]
                        .link
                        .substring(configs[index].link.indexOf('#') + 1)
                    : '13VPN',
                image: 'assets/germany.png',
                type: configs[index]
                    .link
                    .substring(0, configs[index].link.indexOf('://')),
                ping: ''));

        emit(ConfigLoaded(
            configlist: configsList, bestconfig: configsList.first));
      },
    );
    on<GetConfigs>(
      (event, emit) async {
        emit(ConfigLoading());
        try {
          var response = await GetConfigDataSource().getApiConfig();
          final List<String> links = response.data.configs.values.toList();

          configsList = List.generate(
              links.length,
              (index) => Config(
                  link: links[index],
                  remark: links[index].contains('vless') ||
                          links[index].contains('trojan')
                      ? links[index].substring(links[index].indexOf('#') + 1)
                      : '13VPN',
                  image: 'assets/germany.png',
                  type: links[index].substring(0, links[index].indexOf('://')),
                  ping: ''));
          // configsList.add(Config(
          //     link:
          //         'vless://52c51c43-0281-48e4-8f15-53f149655638@hidif.toshibars.sbs:2083?encryption=none&security=reality&sni=www.speedtest.net&alpn=http%2F1.1&fp=chrome&pbk=P-wogluF--82WRuP6lNir5sm6T-PAdSFbVLnvuC-Kyo&sid=68&type=grpc&serviceName=NRWsOgo4DP6ytjjY9eXkZ&mode=gun#Speed%20reality%20grpc',
          //     remark: '13VPN',
          //     image: 'assets/germany.png',
          //     type: 'vless',
          //     ping: ''));
          //Cache Configs
          await hiveConfig.clear();
          for (var i = 0; i < configsList.length; i++) {
            var config = configsList[i];
            await hiveConfig.put(
                i,
                HiveConfig(config.link, config.remark, config.image,
                    config.type, false));
          }
          //
          emit(ConfigLoaded(
              configlist: configsList, bestconfig: configsList.first));
        } on DioException catch (error) {
          emit(ConfigError(error.response?.statusMessage ?? 'Unknown Error'));
        } catch (e) {
          emit(ConfigError(e.toString()));
        }
      },
    );
    on<ChangeConfig>(
      (event, emit) async {
        emit(ConfigChanged(
            configlist: configsList, bestconfig: event.bestconfig));
        if (event.isConnected) {
          await VpnManager().disconnect();
          await Future.delayed(const Duration(milliseconds: 500));
          await VpnManager().connect(event.bestconfig.link);
        }
        for (var element in hiveConfig.values.toList()) {
          if (element.link == event.bestconfig.link) {
            element.isclicked = true;
            element.save();
          } else {
            element.isclicked = false;
            element.save();
          }
        }
      },
    );

    on<PingAllConfigs>(
      (event, emit) {
        for (var element in configsList) {
          if (event.link == element.link) {
            element.ping = event.ping;
          }
        }
        emit(ConfigChanged(
            configlist: configsList, bestconfig: event.bestconfig));
      },
    );
    on<ResetAllPings>(
      (event, emit) {
        for (var element in configsList) {
          element.ping = '';
        }
        emit(ConfigChanged(
            configlist: configsList, bestconfig: event.bestconfig));
      },
    );
  }
}
