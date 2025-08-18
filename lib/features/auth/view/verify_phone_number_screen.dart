import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/auth/repository/verify_number_email_repository.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  bool smsLoading = false;
  bool callLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller in the initState method
    phoneNumberController = TextEditingController(
      text: context.read<ProfileRepository>().profileData!.phone,
    );
  }

  bool buttonState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify phone"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(50),
              const Text(
                "Phone number verification is required!",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const Gap(35),
              Form(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      // readOnly: true,
                      controller: phoneNumberController,
                      hintText: 'Phone number',
                      numberOnly: true,
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your phone number';
                        final number = int.tryParse(value);
                        if (number == null || number < 10000000 || number > 99999999999999) return 'Phone number is not valid.';
                        return null;
                      },
                    ),
                    const Gap(15),
                    const Text("An OTP will be sent to your phone number."),
                    const Gap(8),
                    const Text("How would you like to receive the OTP?"),
                    const Gap(15),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: callLoading
                                  ? null
                                  : smsLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            smsLoading = true;
                                          });
                                          await context.read<VerifyNumberEmailRepository>().requestSmsOtp(phoneNumber: phoneNumberController.text, ctx: context);
                                          setState(() {
                                            smsLoading = false;
                                          });
                                        },
                              icon: smsLoading ? const SizedBox() : const Icon(Boxicons.bxs_message_alt_dots, size: 19),
                              label: smsLoading
                                  ? CupertinoActivityIndicator(
                                      radius: 13.0,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : const Text('Send sms'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          const Text(
                            'or',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: smsLoading
                                  ? null
                                  : callLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            callLoading = true;
                                          });
                                          await context.read<VerifyNumberEmailRepository>().requestVoiceOtp(phoneNumber: phoneNumberController.text, ctx: context);
                                          setState(() {
                                            callLoading = false;
                                          });
                                        },
                              icon: callLoading ? const SizedBox() : const Icon(Boxicons.bxs_phone_call, size: 19),
                              label: callLoading
                                  ? CupertinoActivityIndicator(
                                      radius: 13.0,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : const Text('Call me'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(30),
                    Text(
                      "You may experience delay in getting SMS!",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    const Gap(40),
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
