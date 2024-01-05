import 'package:flutter/material.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/pages/profile_page/profilepage.dart';
import 'package:vpn/utils/navigator.dart';
import 'package:vpn/widgets/configscard.dart';
import 'package:vpn/widgets/getbutton.dart';
import 'package:vpn/widgets/gettimer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final Uri url = Uri.parse('https://13v.site');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('Current state = $state');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SizedBox(width: 18, height: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetTimer(),
                Spacer(),
                GetButton(),
                SizedBox(height: 60),
                ConfigCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
