import "dart:async";

import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:flutter/material.dart";
import "package:one_context/one_context.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:sentry_flutter/sentry_flutter.dart";

import "package:inventree/inventree/sentry.dart";
//import "package:inventree/dsn.dart";
import "package:inventree/widget/home.dart";

// Supported translations are automatically updated
import "package:inventree/l10n/supported_locales.dart";


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded<Future<void>>(() async {

    PackageInfo info = await PackageInfo.fromPlatform();
    String pkg = info.packageName;
    String version = info.version;
    String build = info.buildNumber;

    String release = "${pkg}@${version}:${build}";

    /*await Sentry.init((options) {
      //options.dsn = SENTRY_DSN_KEY;
      options.release = release;
      options.environment = isInDebugMode() ? "debug" : "release";
    });*/

    // Pass any flutter errors off to the Sentry reporting context!
    FlutterError.onError = (FlutterErrorDetails details) async {

      // Ensure that the error gets reported to sentry!
      await sentryReportError(details.exception, details.stack);
    };

    runApp(
      InvenTreeApp()
    );

  }, (Object error, StackTrace stackTrace) async {
    sentryReportError(error, stackTrace);
  });

}

class InvenTreeApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      onGenerateTitle: (BuildContext context) => "InvenTree",
      /*theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        secondaryHeaderColor: Colors.blueGrey,
      ),*/
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        secondaryHeaderColor: Colors.blueGrey,
        primaryColor: Colors.black,

        backgroundColor: Colors.black,

        indicatorColor: Color(0xff0E1D36),
        buttonColor: Color(0xff3B3B3B),

        hintColor: Color(0xff280C0B),

        highlightColor: Color(0xff372901),
        hoverColor: Color(0xff3A3A3B),

        focusColor: Color(0xff0B2512),
        disabledColor: Colors.grey,
        textSelectionColor: Colors.white ,
        cardColor: Color(0xFF151515),
        canvasColor: Colors.black,
        brightness: Brightness.dark,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: ColorScheme.dark()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
      ),
      home: InvenTreeHomePage(),
      localizationsDelegates: [
        I18N.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supported_locales,
    );
  }
}