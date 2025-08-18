import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/auth/repository/register_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String url = 'https://www.ilolo.ng/terms';

  void _launchURL() async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stateProvider =
          Provider.of<RegisterRepository>(context, listen: false);
      stateProvider.validateState = EmailValidateState.sendOtpMail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final EmailValidateState emailValidateState =
        context.watch<RegisterRepository>().validateState;
    final LoadState buttonState = context.watch<RegisterRepository>().loader;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register (validate email)"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: emailValidateState == EmailValidateState.sendOtpMail
              ? Form(
                  key: _formKey,
                  child: Column(children: [
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
                    const Gap(10),
                    Column(
                      children: [
                        const Text(
                          'By clicking on SUBMIT show that you\'s accepted our ',
                          style: TextStyle(fontSize: 13),
                        ),
                        TextButton(
                          onPressed: _launchURL,
                          child: const Text('Terms of Service (ToS)',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1895B0))),
                        ),
                      ],
                    ),
                    const Gap(10),
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
                                      context.read<RegisterRepository>();
                                  sendEmailProvider.setLoader();
                                  await sendEmailProvider.sendEmailOtp(
                                      emailController.text.trim(), context);
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
                            'Enter the 4-digit otp sent to your email\n(${emailController.text}) \nto to validate email',
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
                        const Gap(28),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: CustomButton(
                            text: buttonState == LoadState.loading
                                ? CupertinoActivityIndicator(
                                    radius: 16.0,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : const Text(
                                    "Verify OTP",
                                    style: listItemHeaderStyle,
                                  ),
                            onTap: buttonState == LoadState.loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final verifyOtpProvider =
                                          context.read<RegisterRepository>();
                                      verifyOtpProvider.setLoader();
                                      await verifyOtpProvider.verifyEmailOtp(
                                          emailController.text.trim(),
                                          otpController.text,
                                          context);
                                      verifyOtpProvider.setIdle();
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
