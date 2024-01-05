import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/data/getconfig_datasource.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/models/apiconfigsmode.dart';
import 'package:vpn/utils/vpn_manager.dart';
part 'get_config_event.dart';
part 'get_config_state.dart';

class GetConfigBloc extends Bloc<GetConfigEvent, GetConfigState> {
  int activeindex = 0;
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  GetConfigBloc() : super(ConfigInitial()) {
    on<GetCachedConfigs>(
      (event, emit) async {
        emit(ConfigLoading());
        //Read from hive
        final List<HiveConfig> configs = hiveConfig.values.toList();
        await Future.delayed(const Duration(seconds: 2));
        emit(ConfigLoaded(configlist: configs, isGettingConfigs: true));
      },
    );
    on<GetApiConfigs>(
      (event, emit) async {
        emit(ConfigLoading());
        try {
          final List<String> resault =
              configsFromJson(await GetConfigDataSource().getApiConfig())
                  .data
                  .configs
                  .values
                  .toList();

          await hiveConfig.clear();
          final List<String> imageList = ['34', '342', '343', '344'];
          for (var i = 0; i < resault.length; i++) {
            var config = resault[i];
            await hiveConfig.put(
                i,
                HiveConfig(
                  config,
                  config.contains('vless') || config.contains('trojan')
                      ? config.substring(config.indexOf('#') + 1)
                      : '13VPN',
                  'assets/${imageList[Random().nextInt(4)]}.png',
                  config.substring(0, config.indexOf('://')),
                  i == 0 ? true : false,
                  '',
                ));
          }
          //
          final List<HiveConfig> configs = hiveConfig.values.toList();
          emit(ConfigLoaded(configlist: configs, isGettingConfigs: true));
        } on DioException catch (error) {
          emit(
              ConfigError(error.response?.data['message'] ?? 'Provider Error'));
        } catch (e) {
          emit(ConfigError(e.toString()));
        }
      },
    );
    on<ChangeConfig>(
      (event, emit) async {
        List<HiveConfig> configs = hiveConfig.values.toList();
        for (var element in configs) {
          if (element.link == event.config.link) {
            element.isclicked = true;
            element.save();
          } else {
            element.isclicked = false;
            element.save();
          }
        }
        if (event.isConnected) {
          await VpnManager().disconnect();
          await Future.delayed(const Duration(milliseconds: 500));
          await VpnManager().connect();
        }

        emit(ConfigLoaded(configlist: configs));
      },
    );
    on<PingAllConfigs>(
      (event, emit) {
        List<HiveConfig> configs = hiveConfig.values.toList();
        for (var element in configs) {
          if (event.link == element.link) {
            element.ping = event.ping;
          }
        }
        emit(ConfigLoaded(configlist: configs));
      },
    );
    on<ResetAllPings>(
      (event, emit) {
        List<HiveConfig> configs = hiveConfig.values.toList();
        for (var element in configs) {
          element.ping = '';
          element.save();
        }
        emit(ConfigLoaded(configlist: configs));
      },
    );
  }
}
