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
import 'package:shimmer/shimmer.dart';

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
            body: CustomScrollView(
              slivers: [
                const SliverPadding(padding: EdgeInsets.only(top: 20)),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.error),
                        backgroundColor: CustomColors.error,
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      var profileData = state.profileData;
                      var dataUsage = state.dataUsage;
                      return SliverToBoxAdapter(
                          child: Container(
                        height: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              AuthManager.readProfileImage() ?? 'assets/34.png',
                              fit: BoxFit.fitHeight,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileData.data.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.60,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profileData.data.email,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: CustomColors.buttonhint,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: CustomColors.secendry
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${dataUsage.data.status.dataUsage}GB / ${dataUsage.data.plan.dataLimit}GB',
                                          style: const TextStyle(
                                            color: CustomColors.secendry,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${30 - DateTime.now().difference(profileData.data.registeredAt).inDays} Days Reamining',
                                          style: const TextStyle(
                                            color: CustomColors.secendry,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 90,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                highlightColor: Colors.white24,
                                baseColor: Colors.white10,
                                child: Container(
                                  height: 90,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      highlightColor: Colors.white24,
                                      baseColor: Colors.white10,
                                      child: Container(
                                        height: 20,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Shimmer.fromColors(
                                      highlightColor: Colors.white24,
                                      baseColor: Colors.white10,
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ),
                                    const Spacer(),
                                    Shimmer.fromColors(
                                      highlightColor: Colors.white24,
                                      baseColor: Colors.white10,
                                      child: Container(
                                        height: 20,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 30)),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    Uri getaccurl = Uri.parse('https://13v.site/register');
                    switch (index) {
                      case 0:
                        return MenuItem(
                            icon: const Icon(Icons.payment),
                            ontap: () => open13url(getaccurl),
                            title: 'Premium');
                      case 2:
                        return MenuItem(
                            ontap: () => open13url(
                                Uri.parse("https://t.me/secretjager")),
                            icon: const Icon(Icons.support),
                            title: 'Support');

                      case 1:
                        return MenuItem(
                            ontap: () => open13url(Uri.parse(
                                "https://t.me/addlist/RThLdOdMaNBiMTZk")),
                            icon: const Icon(Icons.telegram),
                            title: 'Contact US');
                      case 3:
                        return MenuItem(
                            ontap: () {
                              final value = CustomColors.fontNotifier.value;
                              if (value == 'SpaceGrotesk') {
                                CustomColors.fontNotifier.value = 'Roboto';
                              } else {
                                CustomColors.fontNotifier.value =
                                    'SpaceGrotesk';
                              }
                            },
                            icon: const Icon(Icons.abc),
                            title: 'Change Font');

                      case 4:
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              CustomColors
                                                                  .secendry),
                                                  onPressed: () async {
                                                    await AuthManager
                                                        .clearAuthData();
                                                    await hiveConfig.clear();

                                                    CustomNav.pushAndRemove(
                                                        context,
                                                        const LoginPage());
                                                  },
                                                  child: const Text('Yes')),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.logout),
                            title: 'Sign Out');
                    }
                    return null;
                  },
                  itemCount: 5,
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 20)),
              ],
            )
            //
            ),
      ),
    );
  }
}
