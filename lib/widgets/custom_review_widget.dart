import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/review/repository/review_repository.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

class CustomReviewWidget extends StatefulWidget {
  const CustomReviewWidget({required this.advertId, super.key});
  final int advertId;

  @override
  State<CustomReviewWidget> createState() => _CustomReviewWidgetState();
}

class _CustomReviewWidgetState extends State<CustomReviewWidget> {
  checkAuth(context, bool isExpanded) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      setState(() {
        _isExpanded = isExpanded;
        // print(_isExpanded);
      });
    } else {
      GoRouter.of(context).push('/login');
    }
  }

  double _rating = 0;
  bool _isExpanded = false;
  LoadState buttonLoaderState = LoadState.idle;
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12),
      ),
      child: ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 500),
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          checkAuth(context, isExpanded);
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text(
                  "Leave a review",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 0, bottom: 10),
                    child: StarRating(
                      mainAxisAlignment: MainAxisAlignment.start,
                      length: 5,
                      rating: _rating,
                      between: 5,
                      starSize: 30,
                      onRaitingTap: (rating) => setState(() => _rating = rating),
                    ),
                  ),
                  CustomTextFormField(
                    controller: _textController,
                    leftRightPadding: 13,
                    rows: 4,
                    hintText: "Write something about this seller?",
                    validator: (value) {
                      if (value!.isEmpty) return "Please write a review";
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 10),
                    child: CustomButton(
                      onTap: buttonLoaderState == LoadState.loading
                          ? null
                          : _rating == 0
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, dynamic> data = {
                                      'rating': _rating.round(),
                                      'review': _textController.text,
                                      'user_id': context.read<ProfileRepository>().profileData!.id,
                                      'advert_id': widget.advertId,
                                    };
                                    setState(() => buttonLoaderState = LoadState.loading);
                                    // print(data);
                                    await context.read<ReviewRepository>().sendReview(data, context);
                                    _rating = 0;
                                    _textController.clear();
                                    _isExpanded = false;
                                    setState(() {
                                      buttonLoaderState = LoadState.idle;
                                    });
                                  }
                                },
                      text: buttonLoaderState == LoadState.loading
                          ? CupertinoActivityIndicator(
                              radius: 12.0,
                              color: Theme.of(context).primaryColor,
                            )
                          : const Text(
                              'submit review',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          )
        ],
      ),
    );
  }
}
