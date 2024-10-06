import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/auth/Authenticate.dart';
import 'package:mica/screens/documents_screen/about_us.dart';
import 'package:mica/screens/documents_screen/privacy_screen.dart';
import 'package:mica/screens/documents_screen/privacy_screen_google.dart';
import 'package:mica/screens/documents_screen/privacy_screen_menu.dart';
import 'package:mica/screens/documents_screen/terms_conditions_screens.dart';
import 'package:mica/screens/documents_screen/terms_screen.dart';
import 'package:mica/screens/documents_screen/terms_screen_google.dart';
import 'package:mica/screens/house_details_screen.dart';
import 'package:mica/screens/login_screen.dart';
import 'package:mica/screens/main_screen.dart';
import 'package:mica/screens/menu/gift_screens/gift_number_screen.dart';
import 'package:mica/screens/menu/gift_screens/list_gift_screen.dart';
import 'package:mica/screens/menu/help_screen.dart';
import 'package:mica/screens/menu/instrucction_screen.dart';
import 'package:mica/screens/menu/own_numers_screen.dart';
import 'package:mica/screens/menu/profile_screens/billing_data_screen.dart';
import 'package:mica/screens/menu/profile_screens/last_name_screen.dart';
import 'package:mica/screens/menu/profile_screens/name_screen.dart';
import 'package:mica/screens/menu/profile_screens/password_screen.dart';
import 'package:mica/screens/menu/profile_screens/profile_screen.dart';
import 'package:mica/screens/menu/security_and_privacy_screen.dart';
import 'package:mica/screens/menu/share_code_screen.dart';
import 'package:mica/screens/recovery_password_screen.dart';
import 'package:mica/screens/signup/signup_google_screen.dart';
import 'package:mica/screens/signup/signup_screen.dart';
import 'package:mica/screens/splash_screen.dart';
import 'package:mica/themes/app_theme.dart';
import 'package:mica/utils/firebase_api.dart';
import 'package:mica/utils/secure_storage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]).then((_) {
    runApp(const AppWithInitialRoute());
  });
}

class AppWithInitialRoute extends StatelessWidget {
  const AppWithInitialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: "/splash",
      debugShowCheckedModeBanner: false,
      title: 'Mica',
      theme: AppTheme(selectedColor: 1).theme(),
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/signup': (context) => const SignupScreen(),
        '/signup_google': (context) => const SignupGoogleScreen(),
        '/recovery': (context) => const RecoveryPasswordScreen(),
        "/terms": (context) => const TermsConditionsScreens(),
        "/terms_signup": (context) => const TermsScreens(),
        "/terms_google": (context) => const TermsScreensGoogle(),
        '/priv': (context) => const PrivacyScreen(),
        "/priv_google": (context) => const PrivacyScreenGoogle(),
        "/priv_menu": (context) => const PrivacyScreenMenu(),
        '/house_details': (context) => const HouseDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/own_numbers': (context) => const OwnNumersScreen(),
        '/gift': (context) => const GiftNumberScreen(),
        '/list_gift': (context) => const ListGiftScreen(),
        '/help': (context) => const HelpScreen(),
        "/security": (context) => const SecurityAndPrivacyScreen(),
        "/inst": (context) => const InstrucctionScreen(),
        "/billing": (context) => const BillingDataScreen(),
        "/password": (context) => const PasswordScreen(),
        "/name": (context) => const NameScreen(),
        "/last_name": (context) => const LastNameScreen(),
        "/splash": (context) => const SplashScreen(),
        "/about": (context) => const AboutUs(),
        "/code": (context) => const ShareCodeScreen()
      },
    );
  }
}
