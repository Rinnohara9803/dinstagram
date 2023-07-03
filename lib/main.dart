import 'package:dinstagram/presentation/pages/Dashboard/initial_page.dart';
import 'package:dinstagram/presentation/pages/Register/register_with_email_page.dart';
import 'package:dinstagram/presentation/pages/Register/register_with_phone_page_one.dart';
import 'package:dinstagram/presentation/pages/Splash/splash_page.dart';
import 'package:dinstagram/presentation/pages/UploadPost/select_image_page.dart';
import 'package:dinstagram/presentation/pages/Verify-Email/verify_email_page.dart';
import 'package:dinstagram/providers/profile_data_provider.dart';
import 'package:dinstagram/providers/profile_provider.dart';
import 'package:dinstagram/providers/user_posts_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'firebase_options.dart';
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
        // profile provider
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),

        // followings-followers provider
        ChangeNotifierProvider<ProfileDataProvider>(
          create: (context) => ProfileDataProvider(),
        ),

        // user posts provider
        ChangeNotifierProvider<UserPostsProvider>(
          create: (context) => UserPostsProvider(),
        ),

        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeData, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Dinstagram',

            // themes manager
            theme: themeData.isLightTheme
                ? getLightApplicationTheme()
                : getDarkApplicationTheme(),
            home: const SplashPage(),

            // named page-routes
            routes: {
              LoginPage.routename: (context) => const LoginPage(),
              RegisterWithEmailPageOne.routename: (context) =>
                  const RegisterWithEmailPageOne(),
              RegisterWithPhonePageOne.routename: (context) =>
                  const RegisterWithPhonePageOne(),
              VerifyEmailPage.routename: (context) => const VerifyEmailPage(),
              InitialPage.routename: (context) => const InitialPage(),
              SelectImagePage.routename: (context) => const SelectImagePage(),
            },
          );
        },
      ),
    );
  }
}
