import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/widgets/button_widget.dart';

class UpdateAdSuccess extends StatefulWidget {
  const UpdateAdSuccess({super.key});

  @override
  State<UpdateAdSuccess> createState() => _UpdateAdSuccessState();
}

class _UpdateAdSuccessState extends State<UpdateAdSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "The Advert has been Updated!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                const Text(
                  "Your Advert has been updated, but it's not available to the customers yet. We make a quick verification of provided information before it's published. It could take a while",
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                CustomButton(
                    onTap: () {
                      context.pop();
                    },
                    text: const Text("Go to advert",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),)),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
