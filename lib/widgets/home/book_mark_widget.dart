import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/book_mark/model/book_mark_model.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/view/single_advert_screen.dart';
import 'package:provider/provider.dart';

class BookMarkWidget extends StatefulWidget {
  const BookMarkWidget({super.key});

  @override
  State<BookMarkWidget> createState() => _BookMarkWidgetState();
}

class _BookMarkWidgetState extends State<BookMarkWidget> {
  @override
  Widget build(BuildContext context) {
    final List<BookMarkDataModel> bookMarkList = context.watch<BookMarkRepository>().bookMarkAdverts;
    return RefreshIndicator.adaptive(
      onRefresh: () async => await context.read<BookMarkRepository>().getBookMarks(),
      child: ListView(
        children: bookMarkList.isEmpty
            ? [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(65),
                      Icon(
                        Icons.bookmarks_rounded,
                        size: 45,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Gap(20),
                      const Text('No Bookmarks found')
                    ],
                  ),
                )
              ]
            : bookMarkList.map((listItem) => BookMarkCard(bookMarkItem: listItem)).toList(),
      ),
    );
  }
}

class BookMarkCard extends StatefulWidget {
  const BookMarkCard({required this.bookMarkItem, super.key});
  final BookMarkDataModel bookMarkItem;

  @override
  State<BookMarkCard> createState() => _BookMarkCardState();
}

class _BookMarkCardState extends State<BookMarkCard> {
  LoadState bookMakeState = LoadState.idle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleAdvertScreen(
              images: widget.bookMarkItem.advert.images,
              advertId: widget.bookMarkItem.advert.id,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 0.99),
          borderRadius: BorderRadius.circular(12.0), // Customize the border radius here
        ),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
        elevation: 0.99,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.bookMarkItem.advert.images[0].source,
                placeholder: (context, url) => const SizedBox(
                    height: 10,
                    width: 10,
                    child: CupertinoActivityIndicator(
                      radius: 20.0,
                    )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      widget.bookMarkItem.advert.title, // Replace with your product name
                      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 10),
                      Expanded(
                        child: Text(
                          "${widget.bookMarkItem.advert.state}, ${widget.bookMarkItem.advert.lga}",
                          style: const TextStyle(fontSize: 9.0, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7, right: 5, top: 4, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            formatPriceToMoney(widget.bookMarkItem.advert.price), // Replace with your product amount
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                          ),
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
                                    setState(() => bookMakeState = LoadState.loading);
                                    Map<String, dynamic> data = {'advert_id': widget.bookMarkItem.advert.id.toString()};
                                    await context.read<BookMarkRepository>().removeBookMark(data, context);
                                    setState(() => bookMakeState = LoadState.idle);
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_rounded,
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
            )
          ],
        ),
      ),
    );
  }
}
