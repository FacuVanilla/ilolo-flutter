import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/widgets/button_widget.dart';

class PostAdSuccess extends StatefulWidget {
  const PostAdSuccess({super.key});

  @override
  State<PostAdSuccess> createState() => _PostAdSuccessState();
}

class _PostAdSuccessState extends State<PostAdSuccess> {
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
                  "The Advert has been create!",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                const Text(
                  "Your Advert has been create, but it's not available to the customers yet. We make a quick verification of provided information before it's published. It could take a while",
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                CustomButton(
                    onTap: () {
                      // Navigator.pop(context);
                      context.pop();
                      context.push('/my-adverts');
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
