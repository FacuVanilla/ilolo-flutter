import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/account/model/profile_model.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/services/cloudinary_service.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_icon_button.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  bool imgLoading = false;
  bool disAbledInput = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ProfileDataModel? profile = context.watch<ProfileRepository>().profileData;
    final buttonState = context.watch<ProfileRepository>().loader;
    final TextEditingController firstNameController = TextEditingController(text: profile!.firstname);
    final TextEditingController lastNameController = TextEditingController(text: profile.lastname);
    final TextEditingController emailController = TextEditingController(text: profile.email);
    final TextEditingController phoneNumberController = TextEditingController(text: profile.phone);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Personal Details"),
        actions: [
          CustomIconButton(
            onPressed: () => setState(() => disAbledInput = disAbledInput ? false : true),
            icon: Icons.edit_square,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(30),
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      // margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl: profile.avatar!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 14,
                      child: GestureDetector(
                        onTap: () async {
                          final provider = context.read<ProfileRepository>();
                          var imageUrl = await CloudinaryService().saveToCloud();
                          if (imageUrl != null) {
                            final localContext = context;
                            Future.microtask(() async {
                              setState(() => imgLoading = true);
                              Map<String, dynamic> data = {'avatar': imageUrl};
                              await provider.postAvater(data, localContext);
                              setState(() => imgLoading = false);
                            });
                          }
                        },
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3.0),
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: imgLoading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CupertinoActivityIndicator(
                                    radius: 10.0,
                                    color: Colors.white,
                                  ))
                              : const Center(
                                  child: Icon(
                                  Icons.mode_edit_outlined,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Center(
                child: Container(
                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        )),
                    child: Text("Joined: ${timeAgo(profile.createdAt.toString())}")),
              ),
              const Gap(30.0),
              // ***********************************************************************
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Firstname",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                      readOnly: disAbledInput,
                      controller: firstNameController,
                      hintText: "enter first name",
                      validator: (value) {
                        if (value!.isEmpty) return "first name is required";
                        return null;
                      },
                    ),
                    const Gap(20.0),
                    // *******************************************************************

                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Lastname",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                      readOnly: disAbledInput,
                      controller: lastNameController,
                      hintText: "enter last name",
                      validator: (value) {
                        if (value!.isEmpty) return "last name is required";
                        return null;
                      },
                    ),
                    const Gap(20.0),
                    // *******************************************************************

                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Phone Number",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                        readOnly: disAbledInput,
                        controller: phoneNumberController,
                        numberOnly: true,
                        hintText: "enter phone number",
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter your phone number';
                          final number = int.tryParse(value);
                          if (number == null || number < 10000000 || number > 99999999999999) return 'Phone number is not valid.';
                          return null;
                        }),
                    const Gap(20.0),
                    // *******************************************************************

                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Email",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                        readOnly: disAbledInput,
                        controller: emailController,
                        hintText: "enter email address",
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter your mail';
                          String exp = "[a-zA-Z0-9+._%-+]{1,256}\\@" "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(" "\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
                          if (!RegExp(exp).hasMatch(value)) return 'This is not a valid email address.';
                          return null;
                        }),
                    // *******************************************************************
                    const Gap(30.0),
                    // *******************************************************************
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: CustomButton(
                          onTap: disAbledInput
                              ? null
                              : buttonState == LoadState.loading
                                  ? null
                                  : () async {
                                      final provider = context.read<ProfileRepository>();
                                      if (_formKey.currentState!.validate()) {
                                        provider.setLoader();
                                        Map<String, dynamic> data = {
                                          'firstname': firstNameController.text,
                                          'lastname': lastNameController.text,
                                          'phone': phoneNumberController.text,
                                          'email': emailController.text,
                                        };
                                        await provider.updateProfileData(data, context);
                                        provider.setIdle();
                                        setState(() => disAbledInput = true);
                                      }
                                    },
                          text: buttonState == LoadState.loading
                              ? CupertinoActivityIndicator(
                                  radius: 16.0,
                                  color: Theme.of(context).primaryColor,
                                )
                              : const Text(
                                  "Update Profile",
                                  style: TextStyle(color: Colors.white),
                                )),
                    ),
                    const Gap(10.0),
                    // *******************************************************************
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
