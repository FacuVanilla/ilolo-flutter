import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/account/model/profile_model.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_icon_button.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  bool disAbledInput = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ProfileDataModel? profile = context.watch<ProfileRepository>().profileData;
    final buttonState = context.watch<ProfileRepository>().loader;
    final TextEditingController businessNameController = TextEditingController(text: profile!.businessName);
    final TextEditingController aboutBusinessController = TextEditingController(text: profile.aboutBusiness);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Business Details"),
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
                        "Business name",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                      readOnly: disAbledInput,
                      controller: businessNameController,
                      hintText: "enter business name",
                      validator: (value) {
                        if (value!.isEmpty) return "business name is required";
                        return null;
                      },
                    ),
                    const Gap(20.0),
                    // *******************************************************************

                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "About Business",
                      ),
                    ),
                    const Gap(5.0),
                    CustomTextFormField(
                      rows: 3,
                      readOnly: disAbledInput,
                      controller: aboutBusinessController,
                      hintText: "",
                      validator: (value) {
                        return null;
                      },
                    ),
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
                                          'business_name': businessNameController.text,
                                          'about_business': aboutBusinessController.text,
                                        };
                                        await provider.updateBusinessData(data, context);
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
                                  "Update",
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