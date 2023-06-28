import 'package:dinstagram/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:dinstagram/presentation/pages/Dashboard/initial_page.dart';
import 'package:dinstagram/presentation/pages/Register/email_confirmation_page.dart';
import 'package:dinstagram/presentation/pages/Register/register_with_email_page.dart';
import 'package:dinstagram/presentation/pages/Register/register_with_phone_page_one.dart';
import 'package:dinstagram/presentation/pages/Splash/splash_page.dart';
import 'package:dinstagram/presentation/pages/Verify-Email/verify_email_page.dart';
import 'package:dinstagram/providers/followings_followers_provider.dart';
import 'package:dinstagram/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'firebase_options.dart';
import 'presentation/pages/Chat/chats_page.dart';
import 'presentation/pages/Login/login_page.dart';
import 'presentation/resources/themes_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final navigatorKey = GlobalKey<NavigatorState>();

  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // ZegoUIKit().initLog().then((value) {
  //   ///  Call the `useSystemCallingUI` method
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );

  runApp(MyApp(navigatorKey: navigatorKey));
  // });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<FollowingFollowersProvider>(
          create: (context) => FollowingFollowersProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Dinstagram',
        theme: getApplicationTheme(),
        home: const SplashPage(),
        routes: {
          LoginPage.routename: (context) => const LoginPage(),
          RegisterWithEmailPageOne.routename: (context) =>
              const RegisterWithEmailPageOne(),
          EmailConfirmationPage.routename: (context) =>
              const EmailConfirmationPage(),
          RegisterWithPhonePageOne.routename: (context) =>
              const RegisterWithPhonePageOne(),
          VerifyEmailPage.routename: (context) => const VerifyEmailPage(),
          InitialPage.routename: (context) => const InitialPage(),
          DashboardPage.routename: (context) => const DashboardPage(),
          ChatsPage.routename: (context) => const ChatsPage(),
        },
      ),
    );
  }
}
