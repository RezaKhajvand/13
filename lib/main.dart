import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/bloc/login_bloc/login_bloc.dart';
import 'package:vpn/bloc/profile_bloc/profile_bloc.dart';
import 'package:vpn/bloc/timer_bloc/timer_bloc.dart';
import 'package:vpn/bloc/vpnstatus_bloc/vpn_status_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/di/di.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/pages/login_page/loginpage.dart';
import 'package:vpn/pages/splash_page/splashpage.dart';
import 'package:vpn/utils/authmanager.dart';
import 'package:vpn/utils/vpn_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getItInit();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveConfigAdapter());
  await Hive.openBox<HiveConfig>('configbox');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VpnStatusBloc(),
        ),
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
        BlocProvider(
          create: (context) => GetConfigBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/background.png'), context);
    precacheImage(const AssetImage('assets/imageball.png'), context);
    precacheImage(const AssetImage('assets/metaball_left.png'), context);
    precacheImage(const AssetImage('assets/metaball_right.png'), context);
    precacheImage(const AssetImage('assets/metaball.png'), context);
    precacheImage(const AssetImage('assets/profile.png'), context);
    //Astronunts
    precacheImage(const AssetImage('assets/34.png'), context);
    precacheImage(const AssetImage('assets/342.png'), context);
    precacheImage(const AssetImage('assets/343.png'), context);
    precacheImage(const AssetImage('assets/344.png'), context);
    super.didChangeDependencies();
  }

  final String statusEventChannel = "com.v2ray.ang/status_event_channel";
  late StreamSubscription statuseventChannelListener;
  VpnStatus _vpnStatus = VpnStatus.disconnect;

  getStatus() {
    final EventChannel statusstream = EventChannel(statusEventChannel);
    statuseventChannelListener = statusstream.receiveBroadcastStream().listen(
      (data) {
        _vpnStatus = VpnStatus.values.firstWhere((e) => e.code == (data ?? 2));
        print(_vpnStatus);
        BlocProvider.of<VpnStatusBloc>(context)
            .add(GetStatus(vpnStatus: _vpnStatus));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CustomColors.fontNotifier,
      builder: (context, value, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: value,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.secendry),
          snackBarTheme: const SnackBarThemeData(
              backgroundColor: CustomColors.secendry,
              contentTextStyle: TextStyle(color: Colors.black87)),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle:
                const TextStyle(color: CustomColors.buttonhint, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: CustomColors.secendry,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            errorStyle: const TextStyle(color: CustomColors.error),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: CustomColors.error)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
          ),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(fontSize: 16),
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        home: Builder(builder: (context) {
          if (AuthManager.canLogin()) {
            return const SplashPage();
          } else {
            return const LoginPage();
          }
        }),
      ),
    );
  }
}
