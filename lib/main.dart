import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/localization/app_localizations.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import 'models/member.dart';
import 'presentation/ui/member/initial.dart';
import 'presentation/ui/non-member/quest.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: [
          Locale('lv', 'LV'),
          Locale('ru', 'RU'),
          Locale('en', 'UK'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        theme: ThemeData(fontFamily: 'Helvetica'),
        home: AnimatedSplashScreen(
          splash: Image.asset("lib/assets/splash.png"),
          nextScreen: AuthenticationWrapper(),
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.fadeTransition,
          splashIconSize: 300,
          duration: 2500,
        ));
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper() : super();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAuthState = watch(userAuthStateProvider);
    Member member;
    try {
      member = userAuthState.data.value;
    } catch (e) {
      print(e);
    }

    if (member == null) {
      return QuestPageView();
    } else {
      return FutureBuilder(
          future: context.read(roleNameProvider).getRole(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              // context
              //     .read(sharedPreferencesProvider)
              //     .whenData((prefs) => prefs.setString('role', role));

              return FutureBuilder(
                  future: DatabaseService.getMember(context
                      .read(authenticationServiceProvider)
                      .currentUserEmail),
                  builder: (context, mem) {
                    if (mem.hasData &&
                        mem.connectionState == ConnectionState.done) {
                      var member = mem.data as Member;
                      return InitialWidget(role: snapshot.data, mem: member);
                    }
                    return Scaffold(
                      body: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2,
                            top: MediaQuery.of(context).size.height / 2),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
            }
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 3,
                    top: MediaQuery.of(context).size.height / 2),
                child: CircularProgressIndicator(),
              ),
            );
          });
    }
  }
}
