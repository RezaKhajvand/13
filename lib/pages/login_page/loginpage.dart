import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/login_bloc/login_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/pages/splash_page/splashpage.dart';
import 'package:vpn/utils/navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //nativeside
  String statusEventChannel = "com.v2ray.ang/status_event_channel";
  String pingEventChannel = "com.v2ray.ang/ping_event_channel";
  final double metaballheight = 250;
  final TextEditingController usercontroler =
      TextEditingController(text: 'dev@13v.site');
  final TextEditingController passcontroler =
      TextEditingController(text: 'password');
  final FocusNode usernameNode = FocusNode();
  final FocusNode passsNode = FocusNode();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    usernameNode.addListener(() => setState(() {}));
    passsNode.addListener(() => setState(() {}));
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
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'LOGIN TO\nYOURE ACCOUNT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Alatsi',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: metaballheight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/metaball_left.png',
                        ),
                        Image.asset(
                          'assets/metaball_right.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                height: usernameNode.hasFocus || passsNode.hasFocus
                    ? MediaQuery.of(context).size.height * 1
                    : MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: CustomColors.glasscardfill.withOpacity(0.4),
                  border: Border(
                    top: BorderSide(
                      width: 0.6,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        key: formGlobalKey,
                        child: Column(
                          children: [
                            Text(
                              'Enter youre login information',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              controller: usercontroler,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Please Type Youre Username';
                                  }
                                } else {
                                  return 'Please Type Youre Username';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              focusNode: usernameNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Username',
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 24,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passcontroler,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Please Type Youre Password';
                                  }
                                } else {
                                  return 'Please Type Youre Password';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              focusNode: passsNode,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  size: 24,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BlocConsumer<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state is LoginError) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      state.message,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: CustomColors.error,
                                  ));
                                }
                                if (state is LoginSuccess) {
                                  CustomNav.pushReplacement(
                                      context, const SplashPage());
                                }
                              },
                              builder: (context, state) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                  height: 50,
                                  width: state is LoginLoading
                                      ? 50
                                      : MediaQuery.of(context).size.width - 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        Color(0xFF00E893),
                                        Color(0xFF009960)
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () async {
                                        if (state is! LoginLoading &&
                                            formGlobalKey.currentState!
                                                .validate()) {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(LoginEvent(
                                                  usercontroler.text,
                                                  passcontroler.text));
                                        }
                                      },
                                      child: state is! LoginLoading
                                          ? const Text('Login')
                                          : const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 2,
                                              ))),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
