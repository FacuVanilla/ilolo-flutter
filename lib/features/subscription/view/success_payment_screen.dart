import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';

class SuccessPaymentScreen extends StatefulWidget {
  const SuccessPaymentScreen({super.key});

  @override
  State<SuccessPaymentScreen> createState() => _SuccessPaymentScreenState();
}

class _SuccessPaymentScreenState extends State<SuccessPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(80),
                Image.asset("assets/images/success.png", height: 100,),
                const Gap(20.0),
                const Text(
                  "Payment Successful!",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w900),
                ),
                const Gap(15),
                const Text(
                  "Thanks for choosing ilolo. Your Ads are now boosted.",
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>const HomeScreen()),
                        (route) => true, // This condition specifies that all routes should be removed.
                      );
                      // print("error");
                    },
                    text: const Text(
                      "Back Home",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                    )),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
