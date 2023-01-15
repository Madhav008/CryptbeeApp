// ignore_for_file: use_build_context_synchronously

import 'package:cryptbee/Config/api_integration.dart';
import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Utilities/Widgets/auth_heading.dart';
import 'package:cryptbee/Utilities/Widgets/email_text_area.dart';
import 'package:cryptbee/Utilities/Widgets/form_errors.dart';
import 'package:cryptbee/Utilities/Widgets/log_in_button.dart';
import 'package:cryptbee/Utilities/Widgets/logo_with_name.dart';
import 'package:cryptbee/Utilities/Widgets/o_auth_button.dart';
import 'package:cryptbee/Utilities/Widgets/password_text_area.dart';
import 'package:cryptbee/Utilities/Widgets/sign_in_up_tabs.dart';
import 'package:cryptbee/Utilities/api_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});
  final EmailTextArea emailField = EmailTextArea(
    labelText: "Email Address",
    hintText: "  Enter Email",
    emailErrorNotifier: signUpEmailErrorNotifer,
  );
  final ErrorLines emailError = ErrorLines(
    errorProvider: signUpEmailErrorProvider,
    height: 35,
  );
  final passArea = PasswordTextArea(
    labelText: "Password",
    hintText: "Atleast 8 characters",
    passErrorNotifier: signUpPasswordErrorNotifer,
  );

  final ErrorLines passErrorLines = ErrorLines(
    errorProvider: signUpPasswordErrorProvider,
    height: 35,
  );

  final confirmPassArea = PasswordTextArea(
    labelText: "Password",
    hintText: "Atleast 8 characters",
    passErrorNotifier: signUpConfirmPasswordErrorNotifer,
  );

  final ErrorLines confirmPassErrorLines = ErrorLines(
    errorProvider: signUpConfirmPasswordErrorProvider,
    height: 35,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final emailErrorMsg = ref.watch(signUpEmailErrorProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(children: [
          Image.asset(
            "assests/background.png",
            height: size.height,
            width: size.width,
          ),
          Column(
            children: [
              const SizedBox(height: 38),
              const CenterLogo(),
              const SizedBox(height: 40),
              const SignInUpTabs(
                choice: 1,
              ),
              const SizedBox(height: 36),
              authHeading("Register Now"),
              const SizedBox(height: 24),
              emailField,
              emailError,
              const SizedBox(height: 16),
              passArea,
              passErrorLines,
              const SizedBox(height: 16),
              confirmPassArea,
              confirmPassErrorLines,
              const SizedBox(height: 12),
              LogInButton(
                text: "Sign Up",
                loaderProvider: signUpEmailButtonLoaderProvider,
                function: () async {
                  if (emailErrorMsg == ' ') {
                    if (!emailErrorMsg.toLowerCase().contains('password')) {
                      if (passArea.controller.text ==
                          confirmPassArea.controller.text) {
                        signUpEmailButtonLoaderNotifier.toggle();
                        final response = await ApiCalls.signUp(
                            email: emailField.controller.text,
                            password: passArea.controller.text);
                        signUpEmailButtonLoaderNotifier.toggle();
                        if (response == noInternet) {
                          internetHandler(context);
                        } else if (response['statusCode'] == 200) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('email', emailField.controller.text);
                          prefs.setString(
                              'password', confirmPassArea.controller.text);
                          context.goNamed(RouteNames.mailOpener,
                              params: {'email': emailField.controller.text});
                        } else {
                          if (true) {
                            signUpConfirmPasswordErrorNotifer.setVal(
                                response[response.keys.first][0].toString());
                          }
                        }
                      } else {
                        signUpConfirmPasswordErrorNotifer
                            .setVal("Passwords Dont Match");
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              authCenterText("Or Sign Up With"),
              const SizedBox(height: 20),
              const OAuthButton(),
            ],
          ),
        ]),
      ),
    );
  }
}
