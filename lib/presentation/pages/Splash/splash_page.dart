import 'dart:io';

import 'package:dinstagram/presentation/pages/Login/login_page.dart';
import 'package:dinstagram/presentation/resources/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../apis/chat_apis.dart';
import '../../../providers/profile_provider.dart';
import '../Dashboard/initial_page.dart';
import '../Verify-Email/verify_email_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future fetchUser() async {
    // ignore: unrelated_type_equality_checks
    if (FirebaseAuth.instance.authStateChanges().isEmpty == true) {
      Navigator.pushNamed(context, LoginPage.routename);
    } else {
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == false) {
        Navigator.pushNamed(context, VerifyEmailPage.routename);
        return;
      } else {
        try {
          await Provider.of<ProfileProvider>(context, listen: false)
              .fetchProfile()
              .then((value) {
            Navigator.pushReplacementNamed(context, InitialPage.routename);
          });
        } on SocketException catch (_) {
          Navigator.pushReplacementNamed(context, LoginPage.routename);
        } catch (e) {
          Navigator.pushReplacementNamed(context, LoginPage.routename);
        }
      }
    }
  }

  @override
  void initState() {
    // ZegoUIKitPrebuiltCallInvitationService().init(
    //   appID: 2064517723 /*input your AppID*/,
    //   appSign:
    //       '6435425b31f12e800b4933a69a457a8209748a8a8c28da8972200ec05ac1db42' /*input your AppSign*/,
    //   userID: ChatApis.user!.uid,
    //   userName: ChatApis.user!.email.toString(),
    //   plugins: [ZegoUIKitSignalingPlugin()],
    // );
    Future.delayed(const Duration(seconds: 0), () {
      fetchUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black87,
              Colors.black,
            ],
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  height: 65,
                  width: 65,
                  image: AssetImage(
                    AssetsManager.distagramLogo,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Dinstagram',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
