import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/auth/repository/verify_number_email_repository.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyPhoneOtpScreen extends StatefulWidget {
  const VerifyPhoneOtpScreen({required this.phoneNumber, super.key});
  final String phoneNumber;
  @override
  State<VerifyPhoneOtpScreen> createState() => _VerifyPhoneOtpScreenState();
}

class _VerifyPhoneOtpScreenState extends State<VerifyPhoneOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  bool buttonState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Otp'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Gap(28),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Enter the 4-digit otp sent to your phone number \n(${widget.phoneNumber}) \nto validate your number',
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
                  if (value!.isEmpty || value.length < 4) return 'Please complete the otp';
                  return null;
                },
              ),
            ),
            const Gap(28),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: CustomButton(
                text: buttonState
                    ? CupertinoActivityIndicator(
                        radius: 13.0,
                        color: Theme.of(context).primaryColor,
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                onTap: buttonState
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            buttonState = true;
                          });
                          await context.read<VerifyNumberEmailRepository>().verifyPhoneOtp(phoneNumber: widget.phoneNumber, otp: otpController.text, ctx: context);
                          setState(() {
                            buttonState = false;
                          });
                        }
                      },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
