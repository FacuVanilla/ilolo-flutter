import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/book_mark/model/book_mark_model.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/view/single_advert_screen.dart';
import 'package:provider/provider.dart';

class AdvertCardWidget extends StatefulWidget {
  const AdvertCardWidget({required this.advert, super.key});
  final dynamic advert;

  @override
  State<AdvertCardWidget> createState() => _AdvertCardWidgetState();
}

class _AdvertCardWidgetState extends State<AdvertCardWidget> {
  LoadState bookMakeState = LoadState.idle;

  // check if the user is authenticated before bookmarking
 Future<bool> bookMarkAuthCheck()async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BookMarkDataModel> bookMarks = context.watch<BookMarkRepository>().bookMarkAdverts;
    bool existInBook = bookMarks.any((element) => element.advertId == widget.advert.id);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleAdvertScreen(
              images: widget.advert.images,
              category: widget.advert.category,
              subcategory: " / ${widget.advert.subcategory}",
              advertId: widget.advert.id,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: widget.advert.badge == null ? BorderSide.none : BorderSide(color: Theme.of(context).primaryColor, width: 1.50),
          borderRadius: BorderRadius.circular(12.0), // Customize the border radius here
        ),
        elevation: 0.99,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                // borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.advert.images[0].source,
                        placeholder: (context, url) => const SizedBox(
                            height: 10,
                            width: 10,
                            child: CupertinoActivityIndicator(
                              radius: 20.0,
                            )),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 1000,
                        width: double.infinity,
                      ),
                    ),
                    widget.advert.badge == null
                        ? const SizedBox()
                        : Container(
                            height: 25,
                            width: 30,
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5)),
                            ),
                            child: Image.asset(
                              'assets/images/${widget.advert.badge}.png',
                              height: 20,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.advert.title, // Replace with your product name
                    style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 10,
                      ),
                      Expanded(
                        child: Text(
                          "${widget.advert.state}, ${widget.advert.lga}",
                          style: const TextStyle(fontSize: 9.0, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 5, top: 4, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatPriceToMoney(widget.advert.price), // Replace with your product amount
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                  ),
                  // const SizedBox(width: 8.0),
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(203, 213, 225, 5), // Set the background color here 203 213 225
                      borderRadius: BorderRadius.circular(50.0), // Optional: Rounded corners
                    ),
                    child: bookMakeState == LoadState.idle
                        ? IconButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              final bool isLogged = await authMiddleware();
                              Future.microtask(() async {
                                if (isLogged) {
                                  setState(() => bookMakeState = LoadState.loading);
                                  Map<String, dynamic> data = {'advert_id': widget.advert.id.toString()};
                                  existInBook
                                      ? await context.read<BookMarkRepository>().removeBookMark(data, context)
                                      : await context.read<BookMarkRepository>().addBookmark(data, context);
                                  setState(() => bookMakeState = LoadState.idle);
                                } else {
                                  GoRouter.of(context).push('/login');
                                }
                              });
                            },
                            icon: Icon(
                              existInBook ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              size: 20,
                            ),
                          )
                        : SizedBox(height: 20, width: 20, child: CupertinoActivityIndicator(radius: 12.0, color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
