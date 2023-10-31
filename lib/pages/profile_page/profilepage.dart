import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';
import 'package:vpn/pages/login_page/loginpage.dart';
import 'package:vpn/utils/authmanager.dart';
import 'package:vpn/utils/navigator.dart';
import 'package:vpn/utils/openurl.dart';
import 'package:vpn/widgets/customappbar.dart';
import 'package:vpn/widgets/menuitem.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //nativeside
  var hiveConfig = Hive.box<HiveConfig>('configbox');
  String pingEventChannel = "com.v2ray.ang/ping_event_channel";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(const ProfileEvent());
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
            appBar: getCustomAppbar(context, null, title: 'Profile'),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                if (state is ProfileSuccess) {
                  return CustomScrollView(
                    slivers: [
                      const SliverPadding(padding: EdgeInsets.only(top: 20)),
                      SliverToBoxAdapter(
                        child: Align(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/profile_picture.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 10)),
                      SliverToBoxAdapter(
                          child: Chip(
                              label: Text(
                                  '${30 - DateTime.now().difference(state.response.data.registeredAt).inDays}d Left'),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: CustomColors.secendry)),
                      const SliverPadding(padding: EdgeInsets.only(top: 10)),
                      SliverToBoxAdapter(
                        child: Text(
                          state.response.data.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.60,
                          ),
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 4)),
                      SliverToBoxAdapter(
                        child: Text(
                          state.response.data.email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: CustomColors.buttonhint,
                            fontSize: 14,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 20)),
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          Uri getaccurl =
                              Uri.parse('https://13v.site/register');
                          switch (index) {
                            case 0:
                              return MenuItem(
                                  icon: const Icon(Icons.payment),
                                  ontap: () => open13url(getaccurl),
                                  title: 'Get Account');
                            case 1:
                              return const MenuItem(
                                  icon: Icon(Icons.info_outlined),
                                  title: 'About US');
                            case 2:
                              return MenuItem(
                                  ontap: () async {
                                    // ignore: use_build_context_synchronously
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: CustomColors.blackshadow,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Are youe sure?',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 30),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    CustomColors
                                                                        .secendry),
                                                        onPressed: () async {
                                                          await AuthManager
                                                              .clearAuthData();
                                                          await hiveConfig
                                                              .clear();

                                                          CustomNav.pushAndRemove(
                                                              context,
                                                              const LoginPage());
                                                        },
                                                        child:
                                                            const Text('Yes')),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    // CustomNav.pushAndRemove(
                                    //     context, const LoginPage());
                                  },
                                  icon: const Icon(Icons.logout),
                                  title: 'Sign Out');
                          }
                          return null;
                        },
                        itemCount: 3,
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 20)),
                    ],
                  );
                }
                if (state is ProfileError) {
                  return Center(
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
                                    BlocProvider.of<ProfileBloc>(context)
                                        .add(const ProfileEvent()),
                                child: const Text('Retry')))
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            )
            //
            ),
      ),
    );
  }
}
