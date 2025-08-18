import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/auth/repository/register_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.email, super.key});
  final String email;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isHiddenPassword = true;
  void togglePasswordVisibility() => setState(() => isHiddenPassword = isHiddenPassword ? false : true);
  // String email = '';
  // @override
  // void initState() {
  //   super.initState();
  //   email = widget.email;
  // }

  @override
  Widget build(BuildContext context) {
    final buttonState = context.watch<RegisterRepository>().loader;
    final TextEditingController emailController = TextEditingController(text: widget.email);
    // final RxBool isChecked = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(18),
                // validate and collect the email
                CustomTextFormField(
                  readOnly: true,
                    controller: emailController,
                    hintText: 'Email',
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your mail';
                      String exp = "[a-zA-Z0-9+._%-+]{1,256}\\@" "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(" "\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
                      if (!RegExp(exp).hasMatch(value)) return 'This is not a valid email address.';
                      return null;
                    }),
                const Gap(14),
                // validate and collect the first name
                CustomTextFormField(
                    controller: firstNameController,
                    hintText: 'First Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your mail';
                      }
                      return null;
                    }),
                const Gap(14),
                // validate and collect the last name
                CustomTextFormField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your mail';
                      }
                      return null;
                    }),
                const Gap(14),
                // validate and collect the phone number
                CustomTextFormField(
                    controller: phoneNumberController,
                    hintText: 'Phone number',
                    numberOnly: true,
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your phone number';
                      final number = int.tryParse(value);
                      if (number == null || number < 10000000 || number > 99999999999999) return 'Phone number is not valid.';
                      return null;
                    }),
                const Gap(14),
                // validate and collect and password
                CustomTextFormField(
                  hintText: 'password',
                  obscureText: isHiddenPassword,
                  inputType: TextInputType.visiblePassword,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your password';
                    if (value.length < 6) return 'Password must be at least 6 character long';
                    return null;
                  },
                  suffixIcon2: IconButton(
                    icon: Icon(isHiddenPassword ? Icons.visibility_off : Icons.visibility),
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
                    if ((value?.isEmpty ?? true) || value != passwordController.text) return 'Passwords do not match.';
                    return null;
                  },
                  suffixIcon2: IconButton(
                    icon: Icon(isHiddenPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: CustomButton(
                    text: buttonState == LoadState.loading
                        ? CupertinoActivityIndicator(
                            radius: 16.0,
                            color: Theme.of(context).primaryColor,
                          )
                        : const Text(
                            "Register",
                            style: listItemHeaderStyle,
                          ),
                    onTap: buttonState == LoadState.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final registerProvider = context.read<RegisterRepository>();
                              registerProvider.setLoader();
                              Map<String, dynamic> data = {
                                'firstname': firstNameController.text.trim(),
                                'lastname': lastNameController.text.trim(),
                                'email': emailController.text.trim(),
                                'phone': phoneNumberController.text.trim(),
                                'password': passwordController.text.trim(),
                                'password_confirm': confirmPasswordController.text.trim(),
                              };
                              await registerProvider.register(data, context);
                              registerProvider.setIdle();
                            }
                          },
                  ),
                ),
                const Gap(40),
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      //       final loginProvider = context.read<LoginRepository>();
                      //       final registerProvider = context.read<RegisterRepository>();
                      //       // await GoogleSignInService.logout();
                      //       var user = await GoogleSignInService.signIn();
                      //       if (user != null) {
                      //         registerProvider.setLoader();
                      //         Map<String, dynamic> data = {
                      //           'google_id': user.id,
                      //           'email': user.email,
                      //           'fullname': user.displayName,
                      //           'photo': user.photoUrl,
                      //         };
                      //         await loginProvider.googleLoginAttempt(data, context);
                      //         registerProvider.setIdle();
                      //       }
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/google.png',
                      //           scale: 1.5,
                      //         ),
                      //         const Gap(21),
                      //         const Text(
                      //           'Google',
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
        ),
      ),
    );
  }
}
