import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/account/model/user_advert_model.dart';
import 'package:ilolo/features/sell/model/form_data_model.dart';
import 'package:ilolo/features/sell/repository/form_data_repository.dart';
import 'package:ilolo/features/sell/repository/post_ad_repository.dart';
import 'package:ilolo/features/sell/view/partials/category_partial.dart';
import 'package:ilolo/features/sell/view/partials/lacation_partial.dart';
import 'package:ilolo/services/cloudinary_service.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_icon_button.dart';
import 'package:ilolo/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class UpdateAdvertScreen extends StatefulWidget {
  const UpdateAdvertScreen({required this.userAdvertModel, super.key});
  final UserAdvertModel userAdvertModel;

  @override
  State<UpdateAdvertScreen> createState() => _UpdateAdvertScreenState();
}

class _UpdateAdvertScreenState extends State<UpdateAdvertScreen> {
  bool showProperty = false;
  bool showImageUpload = false;
  List<FormDataPropertyModel> properties = [];
  Map<String, String> selectedProperties = {};
  List<String> advertImages = [];
  String subCategoryName = '';
  _fetchFormData() async => await context.read<FormDataRepository>().getFormData();
  @override
  void initState() {
    super.initState();
    _fetchFormData();
    subCat();
    titleController.text = widget.userAdvertModel.title;
    priceController.text = widget.userAdvertModel.price.toString();
    descriptionController.text = widget.userAdvertModel.description;
    advertImages = widget.userAdvertModel.images.map((e) => e.source).toList();
    // print(advertImages);
  }

  findSubcategoryById() {
    for (var category in context.read<FormDataRepository>().formDataCategories) {
      for (var subcategory in category.subcategories) {
        if (subcategory.id.toString() == context.watch<PostAdRepository>().subCategoryId || subcategory.id.toString() == widget.userAdvertModel.subcategoryId.toString()) {
          if (subcategory.properties.isEmpty) {
            setState(() {
              showProperty = false;
              properties = [];
              selectedProperties = {};
            });
          } else {
            setState(() {
              showProperty = true;
              properties = subcategory.properties;
            });
          }
        }
      }
    }
  }

  String subCat() {
    for (var category in context.read<FormDataRepository>().formDataCategories) {
      for (var subcategory in category.subcategories) {
        if (subcategory.id.toString() == widget.userAdvertModel.subcategoryId.toString()) {
          return subcategory.title;
        }
      }
    }
    return '';
  }

  showPropertyBottomSheet<T>(BuildContext context, FormDataPropertyModel property) {
    return showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      barrierColor: Colors.black87,
      isDismissible: true,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: property.values
              .map((element) => ListTile(
                    tileColor: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    textColor: Theme.of(context).primaryColor,
                    onTap: () {
                      setState(() {
                        selectedProperties[property.label] = element;
                        if (property.label == 'color') {
                          propertyColorController.text = element;
                        } else if (property.label == 'condition') {
                          propertyConditionController.text = element;
                        } else {
                          otherPropertyController.text = element;
                        }
                      });
                      Navigator.pop(context);
                    },
                    title: Text(element),
                  ))
              .toList(),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController propertyColorController = TextEditingController();
  final TextEditingController propertyConditionController = TextEditingController();
  final TextEditingController otherPropertyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    subCategoryName = context.watch<PostAdRepository>().subCategoryName == '' ? subCat() : context.watch<PostAdRepository>().subCategoryName;
    final String lga = context.watch<PostAdRepository>().lga == '' ? widget.userAdvertModel.lga : context.watch<PostAdRepository>().lga;
    final TextEditingController categoryController = TextEditingController(text: subCategoryName);
    final TextEditingController locationController = TextEditingController(text: lga);
    final buttonState = context.watch<PostAdRepository>().loader;
    findSubcategoryById();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Update Ads'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    showImageUpload == false
                        ? Container(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Describe your product", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                const Gap(5),
                                const Text("Help Buyers to find your advert by providing a proper description.", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
                                const Gap(8),
                                Divider(
                                  thickness: 0.99,
                                  color: Colors.blue[50],
                                ),
                                const Text("Advert details", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                const Gap(20),
                                // accept and validate ad tile
                                CustomTextFormField(
                                  controller: titleController,
                                  leftRightPadding: 0.0,
                                  hintText: 'Title ...',
                                  validator: (value) {
                                    if (value!.isEmpty) return "Ad title is required";
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                // accept and validate price
                                CustomTextFormField(
                                  controller: priceController,
                                  numberOnly: true,
                                  inputType: TextInputType.number,
                                  leftRightPadding: 0.0,
                                  prefix: const Text('₦'),
                                  hintText: 'Price',
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Ad Price is required';
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                // accept and validate category
                                CustomTextFormField(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CategoryPartial(),
                                      ),
                                    );
                                  },
                                  suffixIcon1: const Icon(Icons.arrow_forward_ios_rounded),
                                  readOnly: true,
                                  leftRightPadding: 0.0,
                                  controller: categoryController,
                                  hintText: "Select a category",
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Ad category is required';
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                // accept and validate location
                                CustomTextFormField(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StatePartial(),
                                      ),
                                    );
                                  },
                                  suffixIcon1: const Icon(Icons.arrow_forward_ios_rounded),
                                  controller: locationController,
                                  readOnly: true,
                                  leftRightPadding: 0.0,
                                  hintText: "Select location",
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Ad location is required';
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                // accept and validate description
                                CustomTextFormField(
                                  rows: 4,
                                  controller: descriptionController,
                                  leftRightPadding: 0.0,
                                  hintText: "Description",
                                  validator: (value) {
                                    if (value!.isEmpty) return "description is required";
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                showProperty
                                    ? Container(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Properties", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                            const Gap(5),
                                            const Text("Tell us about the properties or specific features your product have.", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
                                            const Gap(15),
                                            Column(
                                              children: properties.asMap().entries.map((entry) {
                                                // final index = entry.key;
                                                final property = entry.value;
                                                return GestureDetector(
                                                  onTap: () => showPropertyBottomSheet(context, property),
                                                  child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                      margin: const EdgeInsets.only(bottom: 10),
                                                      decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(15)),
                                                      child: selectedProperties.isEmpty
                                                          ? Text(property.title)
                                                          : selectedProperties.containsKey(property.label)
                                                              ? Text("${property.title} - ${selectedProperties[property.label]!}")
                                                              : Text(property.title)),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Advert photos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                const Gap(5),
                                const Text("Upload some clear photos of your product. Good pictures can increase Buyers interest! First added photo will be your main photo",
                                    style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
                                const Gap(8),
                                CustomButton(
                                  onTap: advertImages.length == 10
                                      ? null
                                      : () async {
                                          var imageUrl = await CloudinaryService().saveToCloud();
                                          if (imageUrl != null) {
                                            setState(() => advertImages.add(imageUrl));
                                          }
                                        },
                                  text: Text(advertImages.isEmpty ? 'Choose photos to upload' : 'Add more photos', style: const TextStyle(color: Colors.white)),
                                ),
                                Divider(
                                  thickness: 0.99,
                                  color: Colors.blue[50],
                                ),
                                SizedBox(
                                  height: 80,
                                  child: Wrap(
                                    children: advertImages.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final e = entry.value;
                                      return Container(
                                        margin: const EdgeInsets.only(left: 5.0, top: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context).primaryColorLight,
                                              style: BorderStyle.solid,
                                              width: 0.99,
                                            ),
                                            borderRadius: BorderRadius.circular(12.0)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: e,
                                                placeholder: (context, url) => const SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: CupertinoActivityIndicator(
                                                      radius: 20.0,
                                                    )),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                width: 110,
                                                height: 110,
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    margin: const EdgeInsets.all(5),
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius: BorderRadius.circular(200),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      (index + 1).toString(),
                                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                                    ))),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: CustomIconButton(
                                                  onPressed: () => setState(() => advertImages = List.from(advertImages)..remove(e)),
                                                  icon: Icons.delete_rounded,
                                                ),
                                              ),
                                              index == 0
                                                  ? Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        height: 20,
                                                        width: 50,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).primaryColor,
                                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5)),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                          "main",
                                                          style: TextStyle(color: Colors.white),
                                                        )),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(color: Colors.blueGrey[50]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: showImageUpload == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  text: const Text("Cancel"),
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: CustomButton(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => showImageUpload = true);
                                      // Map<String, dynamic> data = {'title': 'some title', 'properties': selectedProperties};
                                      // print(data);
                                    }
                                  },
                                  text: const Text(
                                    "continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onTap: () {
                                    setState(() => showImageUpload = false);
                                    context.read<PostAdRepository>().setIdle();
                                  },
                                  text: const Text("back"),
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: CustomButton(
                                  onTap: advertImages.length < 3
                                      ? null
                                      : buttonState == LoadState.loading
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!.validate()) {
                                                final providerData = context.read<PostAdRepository>();
                                                providerData.setLoader();
                                                Map<String, dynamic> data = {
                                                  'advert_id': widget.userAdvertModel.id,
                                                  "title": titleController.text,
                                                  "category": providerData.categoryId == ''? widget.userAdvertModel.categoryId : providerData.categoryId,
                                                  "subcategory": providerData.subCategoryId == ''? widget.userAdvertModel.subcategoryId : providerData.subCategoryId,
                                                  "state": providerData.state == ''? widget.userAdvertModel.state : providerData.state,
                                                  "lga": providerData.lga == ''? widget.userAdvertModel.lga : providerData.lga,
                                                  "price": priceController.text,
                                                  "negotiable": false,
                                                  "description": descriptionController.text,
                                                  "photos": advertImages,
                                                  "properties": selectedProperties
                                                };
                                                // print(data);
                                                await providerData.upDateAdvert(data, context);
                                                providerData.setIdle();
                                              }
                                            },
                                  text: buttonState == LoadState.loading
                                      ? CupertinoActivityIndicator(
                                          radius: 16.0,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : const Text(
                                          "continue",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ],
                          ),
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
