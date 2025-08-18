import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/auth/repository/login_repository.dart';
import 'package:ilolo/services/google_signin_api_service.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHiddenPassword = true;
  void togglePasswordVisibility() =>
      setState(() => isHiddenPassword = isHiddenPassword ? false : true);
  @override
  Widget build(BuildContext context) {
    final buttonState = context.watch<LoginRepository>().loader;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kindly sign in"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(50),
              const Text("Sign in is required to continue"),
              const Gap(35),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: emailOrPhoneController,
                        hintText: 'email or phone number',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mail or phone number';
                          }
                          return null;
                        }),
                    const Gap(28),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: isHiddenPassword,
                      inputType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your password';
                        return null;
                      },
                      suffixIcon2: IconButton(
                        icon: Icon(isHiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    const Gap(14),
                    Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => context.push("/forget-password"),
                          child: const Text(
                            'Forgot password?',
                            style: buttonStyle,
                          ),
                        ),
                      ),
                    ),
                    const Gap(51),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: CustomButton(
                        text: buttonState == LoadState.loading
                            ? CupertinoActivityIndicator(
                                radius: 16.0,
                                color: Theme.of(context).primaryColor,
                              )
                            : const Text(
                                "sign in",
                                style: listItemHeaderStyle,
                              ),
                        onTap: buttonState == LoadState.loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final loginProvider =
                                      context.read<LoginRepository>();
                                  loginProvider.setLoader();
                                  Map<String, dynamic> data = {
                                    'emailorphone':
                                        emailOrPhoneController.text.trim(),
                                    'password': passwordController.text.trim(),
                                  };
                                  await loginProvider.loginAttempt(
                                      data, context);
                                  loginProvider.setIdle();
                                }
                              },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: subTextStyle,
                          ),
                          TextButton(
                            onPressed: () => context.push('/register'),
                            child: const Text(
                              'Register',
                              style: buttonTwoStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(40),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Platform.isIOS
                              ? (context.read<LoginRepository>().googleStatus ==
                                      true
                                  ? Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          try {
                                            debugPrint(
                                                "Starting iOS Google Sign-In");
                                            final loginProvider =
                                                context.read<LoginRepository>();
                                            var user = await GoogleSignInService
                                                .signIn();
                                            if (user != null) {
                                              loginProvider.setLoader();
                                              debugPrint(
                                                  "Google Sign-In successful: ${user['email']}");
                                              Map<String, dynamic> data = {
                                                'google_id': user['id'],
                                                'email': user['email'],
                                                'fullname': user['displayName'],
                                                'photo': user['photoUrl'],
                                              };
                                              await loginProvider
                                                  .googleLoginAttempt(
                                                      data, context);
                                              loginProvider.setIdle();
                                            } else {
                                              debugPrint(
                                                  "Google Sign-In cancelled or failed");
                                            }
                                          } catch (e) {
                                            debugPrint(
                                                "Error during Google Sign-In: $e");
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/google.png',
                                              scale: 1.5,
                                            ),
                                            const Gap(7),
                                            const Text(
                                              'Google',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox())
                              : Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        debugPrint(
                                            "Starting Android Google Sign-In");
                                        final loginProvider =
                                            context.read<LoginRepository>();
                                        var user =
                                            await GoogleSignInService.signIn();
                                        if (user != null) {
                                          loginProvider.setLoader();
                                          debugPrint(
                                              "Google Sign-In successful: ${user['email']}");
                                          Map<String, dynamic> data = {
                                            'google_id': user['id'],
                                            'email': user['email'],
                                            'fullname': user['displayName'],
                                            'photo': user['photoUrl'],
                                          };
                                          await loginProvider
                                              .googleLoginAttempt(
                                                  data, context);
                                          loginProvider.setIdle();
                                        } else {
                                          debugPrint(
                                              "Google Sign-In cancelled or failed");
                                        }
                                      } catch (e) {
                                        debugPrint(
                                            "Error during Google Sign-In: $e");
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google.png',
                                          scale: 1.5,
                                        ),
                                        const Gap(7),
                                        const Text(
                                          'Google',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          const Gap(10),
                          // Expanded(
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.white,
                          //       foregroundColor: Colors.black,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //       ),
                          //     ),
                          //     onPressed: () async {
                          //       var user = await AppleSigninService.signIn();
                          //       print(user);
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Image.asset(
                          //           'assets/images/apple.png',
                          //           height: 20,
                          //           scale: 1.5,
                          //         ),
                          //         const Gap(7),
                          //         const Text(
                          //           'Apple',
                          //           style: TextStyle(color: Colors.black),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
