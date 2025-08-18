import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/home/model/single_advert_model.dart';
import 'package:ilolo/features/home/view/report_seller_screen.dart';
import 'package:ilolo/features/message/model/message_model.dart';
import 'package:ilolo/features/message/repository/contact_repository.dart';
import 'package:ilolo/features/message/repository/message_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.screenTitle, required this.contactId, required this.presence, required this.avater, this.advert, super.key});
  final String avater;
  final String screenTitle;
  final int contactId;
  final String presence;
  final SingleAdvertModel? advert;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final List<Message> messages = [
  //   Message(text: 'Hello!', isMe: false),
  //   Message(text: 'Hi there!', isMe: true),
  // ];
  SingleAdvertModel? localAdvert;

  final TextEditingController _textController = TextEditingController();
  bool isLoaded = false;
  bool sendLoader = false;
  void _sendMessage() async {
    if (_textController.text.isEmpty) return;
    setState(() => sendLoader = true);
    await context.read<MessageRepository>().sendMessage(toId: widget.contactId, message: _textController.text, advertId: widget.advert == null ? "" : widget.advert!.id.toString(), ctx: context);
    setState(() {
      sendLoader = false;
      _textController.clear();
      localAdvert = null;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listViewController.animateTo(
        _listViewController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  fetchChats() async {
    await context.read<MessageRepository>().getMessages(widget.contactId);
    setState(() => isLoaded = true);
  }

  @override
  void initState() {
    super.initState();
    fetchChats();
    localAdvert = widget.advert;
  }

  final ScrollController _listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final List<MessageModel> messageProvider = context.watch<MessageRepository>().messages;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.screenTitle,
              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800),
            ),
            Text(
              widget.presence,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        actions: [
          CustomIconButton(
            onPressed: () {
              OptionBottomSheet(
                userName: widget.screenTitle,
                userAvater: widget.avater,
                userId: widget.contactId.toString(),
              ).show(context);
            },
            icon: Icons.more_vert,
          ),
          const Gap(5),
        ],
      ),
      body: isLoaded
          ? SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
                      child: Consumer<MessageRepository>(
                        builder: (context, dataProvider, state) {
                          final List<MessageModel> messageProvider = dataProvider.messages;
                          return ListView.builder(
                            controller: _listViewController,
                            itemCount: messageProvider.length,
                            itemBuilder: (BuildContext context, int index) {
                              final message = messageProvider[index];
                              return MessageWidget(message: message);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  localAdvert == null ? const SizedBox() : AdvertCard(bookMarkItem: localAdvert!),
                  const Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        _buildTextComposer(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(radius: 12.0, color: Theme.of(context).primaryColor),
            ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    // You can add real-time input handling here
                  });
                },
                onSubmitted: (String text) {
                  _sendMessage();
                },
                decoration: const InputDecoration.collapsed(hintText: 'Type your message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: sendLoader
                  ? const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CupertinoActivityIndicator(radius: 14.0),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final MessageModel message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.from.id == context.read<ProfileRepository>().profileData!.id ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.30,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: message.from.id == context.read<ProfileRepository>().profileData!.id ? mainColor : Colors.blue[50],
          borderRadius: message.from.id == context.read<ProfileRepository>().profileData!.id
              ? const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
              : const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.advert != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.advert!.title,
                        style: TextStyle(color: message.from.id == context.read<ProfileRepository>().profileData!.id ? Colors.white : Colors.black87, fontWeight: FontWeight.w900),
                      ),
                      const Gap(3),
                      Text(
                        formatPriceToMoney(message.advert!.price),
                        style: TextStyle(color: message.from.id == context.read<ProfileRepository>().profileData!.id ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
                      ),
                      const Gap(5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: const Color.fromRGBO(203, 213, 225, 5),
                          width: double.infinity,
                          height: 150,
                          child: CachedNetworkImage(
                            imageUrl: message.advert!.images[0].source,
                            placeholder: (context, url) => const CupertinoActivityIndicator(radius: 14.0),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            message.advert != null ? const Gap(10) : const Gap(0),
            Text(
              message.message,
              style: TextStyle(color: message.from.id == context.read<ProfileRepository>().profileData!.id ? Colors.white : Colors.black87, fontWeight: FontWeight.w800),
            ),
            Text(
              timeAgo(message.createdAt),
              style: TextStyle(color: message.from.id == context.read<ProfileRepository>().profileData!.id ? Colors.white : Colors.black87, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

class AdvertCard extends StatefulWidget {
  const AdvertCard({required this.bookMarkItem, super.key});
  final SingleAdvertModel bookMarkItem;

  @override
  State<AdvertCard> createState() => _AdvertCardState();
}

class _AdvertCardState extends State<AdvertCard> {
  // LoadState bookMakeState = LoadState.idle;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              imageUrl: widget.bookMarkItem.images[0].source,
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
                    widget.bookMarkItem.title, // Replace with your product name
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
                        "${widget.bookMarkItem.state}, ${widget.bookMarkItem.lga}",
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
                          formatPriceToMoney(widget.bookMarkItem.price), // Replace with your product amount
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OptionBottomSheet extends StatefulWidget {
  const OptionBottomSheet({required this.userName, required this.userAvater, required this.userId, super.key});
  final String userName;
  final String userAvater;
  final String userId;
  show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      isDismissible: false,
      builder: (_) => this,
    );
  }

  @override
  State<OptionBottomSheet> createState() => _OptionBottomSheetState();
}

class _OptionBottomSheetState extends State<OptionBottomSheet> {
  bool isLoading = false;
  bool isLoadingDelete = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Gap(5.0),
          Container(height: 5.0, width: 70, decoration: BoxDecoration(color: const Color(0xffE0E0E0), borderRadius: BorderRadius.circular(30))),
          const Gap(5.0),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () async {
                setState(() => isLoadingDelete = true);
                await context.read<MessageRepository>().deleteMessage(context, widget.userId);
                setState(() => isLoadingDelete = false);
              },
              leading: const Icon(Boxicons.bx_trash_alt),
              title: const Text("Delete Chat"),
              trailing: isLoadingDelete
                  ? CupertinoActivityIndicator(
                      radius: 16.0,
                      color: Theme.of(context).primaryColor,
                    )
                  : const SizedBox(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () async {
                setState(() => isLoading = true);
                await context.read<ContactRepository>().blockContact(context, widget.userId);
                setState(() => isLoading = false);
              },
              leading: const Icon(Boxicons.bx_block),
              title: const Text("Block this user"),
              trailing: isLoading
                  ? CupertinoActivityIndicator(
                      radius: 16.0,
                      color: Theme.of(context).primaryColor,
                    )
                  : const SizedBox(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportSellerScreen(
                      sellerAvater: widget.userAvater,
                      sellerName: widget.userName,
                      sellerId: widget.userId.toString(),
                    ),
                  ),
                );
              },
              leading: const Icon(Boxicons.bx_flag, color: Colors.red),
              title: const Text(
                "Report this user",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
