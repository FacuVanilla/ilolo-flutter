import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/auth/repository/reset_password_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isHiddenPassword = true;
  void togglePasswordVisibility() =>
      setState(() => isHiddenPassword = isHiddenPassword ? false : true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stateProvider =
          Provider.of<ResetPasswordRepository>(context, listen: false);
      stateProvider.resetState = ResetState.sendOtpMail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResetState passwordResetState =
        context.watch<ResetPasswordRepository>().resetState;
    final LoadState buttonState =
        context.watch<ResetPasswordRepository>().loader;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password?"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: passwordResetState == ResetState.sendOtpMail
              ? Form(
                  key: _formKey,
                  child: Column(children: [
                    const Gap(28),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text("Don't worry, happens to the best of us"),
                    ),
                    const Gap(28),
                    CustomTextFormField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter your mail';
                          String exp = "[a-zA-Z0-9+._%-+]{1,256}\\@"
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}("
                              "\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
                          if (!RegExp(exp).hasMatch(value))
                            return 'This is not a valid email address.';
                          return null;
                        }),
                    const Gap(28),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CustomButton(
                        text: buttonState == LoadState.loading
                            ? const CupertinoActivityIndicator(
                                radius: 16.0,
                                color: Colors.white,
                              )
                            : const Text(
                                "Submit",
                                style: listItemHeaderStyle,
                              ),
                        onTap: buttonState == LoadState.loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final sendEmailProvider =
                                      context.read<ResetPasswordRepository>();
                                  sendEmailProvider.setLoader();
                                  Map<String, dynamic> data = {
                                    'email': emailController.text.trim(),
                                  };
                                  await sendEmailProvider.passwordOtp(
                                      data: data, ctx: context);
                                  sendEmailProvider.setIdle();
                                }
                              },
                      ),
                    ),
                  ]),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(28),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Enter the 4-digit otp sent to your email\n(${emailController.text}) \nto reset your password',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Gap(28),
                        // validate and collect the otp code
                        Padding(
                          padding: const EdgeInsets.only(left: 13, right: 13),
                          child: Pinput(
                            controller: otpController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4)
                                return 'Please complete the otp';
                              return null;
                            },
                          ),
                        ),
                        const Gap(14),
                        // validate and collect and password
                        CustomTextFormField(
                          hintText: 'New password',
                          obscureText: isHiddenPassword,
                          inputType: TextInputType.visiblePassword,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter your password';
                            if (value.length < 6)
                              return 'Password must be at least 6 character long';
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
                        // validate and collect the retype password
                        CustomTextFormField(
                          hintText: 'Retype-password',
                          obscureText: isHiddenPassword,
                          inputType: TextInputType.visiblePassword,
                          controller: confirmPasswordController,
                          validator: (value) {
                            if ((value?.isEmpty ?? true) ||
                                value != passwordController.text)
                              return 'Passwords do not match.';
                            return null;
                          },
                          suffixIcon2: IconButton(
                            icon: Icon(isHiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        const Gap(28),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: CustomButton(
                            text: buttonState == LoadState.loading
                                ? const CupertinoActivityIndicator(
                                    radius: 16.0,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Reset password",
                                    style: listItemHeaderStyle,
                                  ),
                            onTap: buttonState == LoadState.loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final setPasswordProvider = context
                                          .read<ResetPasswordRepository>();
                                      setPasswordProvider.setLoader();
                                      Map<String, dynamic> data = {
                                        'email': emailController.text.trim(),
                                        'otp': otpController.text,
                                        'new_password':
                                            passwordController.text.trim(),
                                        'password_confirm':
                                            confirmPasswordController.text
                                                .trim(),
                                      };
                                      await setPasswordProvider.resetPassword(
                                          data: data, ctx: context);
                                      setPasswordProvider.setIdle();
                                    }
                                  },
                          ),
                        ),
                      ]),
                ),
        ),
      ),
    );
  }
}
