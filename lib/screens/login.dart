import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_helper.dart';
import '../core/remote_configuration/models/login.dart';
import '../extensions.dart';
import '../globals.dart';
import 'screen_base.dart';

class LoginScreen extends StatelessWidget with ScreenBase {
  const LoginScreen({super.key});
  LoginScreenModel get loginProps => Globals.configuration.loginScreen;

  @override
  Widget build(BuildContext context) {
    configure(context: context, fullscreen: true);
    var providers = <AuthProvider>[
      fui.EmailAuthProvider(),
    ];
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: loginProps.brightness,
          visualDensity: VisualDensity.standard,
          primarySwatch: MaterialColor(loginProps.linkColor.value,
              AppHelper.getSwatch(loginProps.linkColor)),
          scaffoldBackgroundColor: loginProps.backgroundColor,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? SignInScreen(
                showAuthActionSwitch: !loginProps.disableRegister,
                providers: providers,
                headerBuilder: (context, constrains, size) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Image(
                            image: loginProps.logoField.url.toImageProvider,
                            width: min(loginProps.logoField.width,
                                constrains.maxWidth),
                            height: min(loginProps.logoField.height,
                                constrains.maxHeight),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Navigator.of(context, rootNavigator: true).canPop()
                          ? Positioned(
                              right: 25,
                              top: 5,
                              child: InkWell(
                                child: const Icon(
                                  Icons.close,
                                  size: 40,
                                ),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .maybePop();
                                },
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  );
                },
                footerBuilder: loginProps.disableGoHomeButton
                    ? null
                    : (context, action) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Globals.configuration.primaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              label: Text(tr("quit_to_home")),
                              onPressed: () async {
                                AppHelper.goLandingScreen();
                              },
                            ),
                          ],
                        );
                      },
                actions: [
                  AuthStateChangeAction<SignedIn>((context, state) async {
                    ScaffoldMessenger.of(Globals.buildContext!).showSnackBar(
                      SnackBar(
                        content: Text(
                          tr("logged_in"),
                          textAlign: TextAlign.center,
                        ),
                      ).toStandart,
                    );
                    AppHelper.goLandingScreen();
                  }),
                ],
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          tr("Account"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Globals.configuration.primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: const Text("Logout"),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                tr("logged_out"),
                                textAlign: TextAlign.center,
                              ),
                            ).toStandart,
                          );
                          await FirebaseAuth.instance.signOut();
                          AppHelper.goLandingScreen();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Globals.configuration.primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        icon: const Icon(
                          Icons.person_off,
                          color: Colors.white,
                        ),
                        label: const Text("Delete My Account"),
                        onPressed: () async {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: tr("delete_my_account_title"),
                            desc: tr("delete_my_account_body"),
                            btnOkText: tr("delete"),
                            btnCancelText: tr("cancel"),
                            btnOkIcon: Icons.delete,
                            btnCancelIcon: Icons.close,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    tr("account_is_deleted"),
                                    textAlign: TextAlign.center,
                                  ),
                                ).toStandart,
                              );
                              await FirebaseAuth.instance.signOut();
                              AppHelper.goLandingScreen();
                            },
                          ).show();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Globals.configuration.primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        label: Text(tr("quit_to_home")),
                        onPressed: () async {
                          AppHelper.goLandingScreen();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
