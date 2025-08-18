import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/home/repository/seller_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ReportSellerScreen extends StatefulWidget {
  const ReportSellerScreen({required this.sellerId, required this.sellerName, required this.sellerAvater, super.key});
  // final SellerModel seller;
  final String sellerId;
  final String sellerName;
  final String sellerAvater;

  @override
  State<ReportSellerScreen> createState() => _ReportSellerScreenState();
}

class _ReportSellerScreenState extends State<ReportSellerScreen> {
  List<String> reasonOptions = <String>['...', 'Scam', 'Inappropriate content', 'Others'];
  String dropdownValue = '...';
  bool selectError = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: const Text("Report User"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: const Color.fromRGBO(203, 213, 225, 5),
                      width: 30,
                      height: 30,
                      child: CachedNetworkImage(
                        imageUrl: widget.sellerAvater,
                        placeholder: (context, url) => const CupertinoActivityIndicator(radius: 14.0),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.sellerName,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const Divider(color: Color.fromARGB(13, 0, 0, 0)),
              const Gap(10),
              Container(
                margin: const EdgeInsets.all(17),
                padding: const EdgeInsets.only(right: 10, left: 10, top: 13),
                decoration: BoxDecoration(
                  color: selectError ? Colors.red[50] : Colors.blue[50],
                  border: Border.all(color: selectError ? Colors.red : Theme.of(context).primaryColorLight, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select a reason", style: TextStyle(color: selectError ? Colors.red : Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                          selectError = false;
                        });
                      },
                      underline: const SizedBox(),
                      isExpanded: true,
                      style: const TextStyle(color: Colors.black),
                      selectedItemBuilder: (BuildContext context) {
                        return reasonOptions.map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dropdownValue,
                            ),
                          );
                        }).toList();
                      },
                      items: reasonOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("Description", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),
              ),
              const Gap(5),
              CustomTextFormField(
                rows: 5,
                hintText: "Please describe what the issue is?",
                controller: descriptionController,
                validator: (value) {
                  if (value!.isEmpty) return "please explain the issue";
                  return null;
                },
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomButton(
                  onTap: isLoading
                      ? null
                      : () async {
                          if (dropdownValue == '...') {
                            setState(() => selectError = true);
                          } else if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            Map<String, dynamic> reportData = {
                              'seller_id': widget.sellerId,
                              'reason': dropdownValue,
                              'description': descriptionController.text,
                            };
                            // print(reportData);
                            await context.read<SellerRepository>().reportSeller(reportData, context);
                            setState(() {
                              descriptionController.clear();
                              dropdownValue = '...';
                              isLoading = false;
                            });
                          }
                        },
                  text: isLoading
                      ? CupertinoActivityIndicator(
                          radius: 16.0,
                          color: Theme.of(context).primaryColor,
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
