import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/message/model/contact_model.dart';
import 'package:ilolo/features/message/model/notification_model.dart';
import 'package:ilolo/features/message/repository/contact_repository.dart';
import 'package:ilolo/features/message/repository/notification_repository.dart';
import 'package:ilolo/features/message/view/message_screen.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class MessengerWidget extends StatefulWidget {
  const MessengerWidget({super.key});

  @override
  State<MessengerWidget> createState() => _MessengerWidgetState();
}

class _MessengerWidgetState extends State<MessengerWidget> {
  int _selectedIndex = 0;

  void _onSegmentChanged(int? index) {
    setState(() {
      _selectedIndex = index!;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationRepository>().getNotifications();
    context.read<ContactRepository>().getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity, // Full width
            child: CupertinoSlidingSegmentedControl(
              children: const {
                0: Text('Chats'),
                1: Text('Alerts'),
              },
              groupValue: _selectedIndex,
              onValueChanged: _onSegmentChanged,
            ),
          ),
          const SizedBox(height: 16),
          _selectedIndex == 0 ? const Expanded(child: ChatWidget()) : const Expanded(child: AlertWidget()),
        ],
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ContactModel> myContacts = context.watch<ContactRepository>().contacts;
    List<ContactModel> blockedContacts = context.watch<ContactRepository>().blockedContacts;

    return myContacts.isEmpty
        ? const Center(
            child: Column(
              children: [Icon(Icons.messenger_rounded), Text("No chat yet...")],
            ),
          )
        : RefreshIndicator.adaptive(
          onRefresh: ()async=> await context.read<ContactRepository>().getContacts(),
          child: Consumer<ContactRepository>(
              builder: (context, dataProvider, state) {
                final List<ContactModel> contactData = dataProvider.contacts;
                return ListView.builder(
                    itemCount: contactData.length,
                    itemBuilder: (context, snapshot) {
                      final ContactModel contact = contactData[snapshot];
                      bool existInBlockContact = blockedContacts.any((element) => element.id == contact.id);
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: ListTile(
                          onTap: () {
                            if (existInBlockContact) {
                              BlockContactBottomSheet(userId: contact.id.toString(), userName: "${contact.firstname} ${contact.lastname}").show(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            avater: contact.avatar,
                                            screenTitle: "${contact.firstname} ${contact.lastname}",
                                            contactId: contact.id,
                                            presence: contact.presence,
                                          )));
                            }
                          },
                          tileColor: contact.unseenMessages != 0 ? Colors.blue[50] : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: const Color.fromRGBO(203, 213, 225, 5),
                              width: 40,
                              height: 40,
                              child: CachedNetworkImage(
                                imageUrl: contact.avatar,
                                placeholder: (context, url) => const CupertinoActivityIndicator(radius: 14.0),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("${contact.firstname} ${contact.lastname}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: existInBlockContact
                              ? const Text("You blocked this contact", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic))
                              : Text(contact.lastMessage!.message, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.normal)),
                          trailing: existInBlockContact
                              ? const Icon(Icons.arrow_forward_ios_rounded, size: 15)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(timeAgo(contact.lastMessage!.createdAt)),
                                    Badge.count(
                                      count: contact.unseenMessages,
                                      isLabelVisible: contact.unseenMessages == 0 ? false : true,
                                    )
                                  ],
                                ),
                        ),
                      );
                    });
              },
            ),
        );
  }
}

class AlertWidget extends StatelessWidget {
  const AlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> alerts = context.watch<NotificationRepository>().notifications;
    return alerts.isEmpty
        ? const Center(
            child: Column(
              children: [Icon(Icons.notifications_rounded), Text("No Alert yet...")],
            ),
          )
        : ListView(
            children: alerts
                .map(
                  (item) => Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: ListTile(
                      onTap: () async {
                        final provider = context.read<NotificationRepository>();
                        Alert().show(context, message: item.data['message']);
                        await ApiService().authPostData(endpoint: 'markalertasseen', data: {'user_id': item.id});
                        await provider.getNotifications();
                      },
                      tileColor: item.readAt == null ? Colors.blue[50] : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        item.data['message'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(timeAgo(item.createdAt)),
                    ),
                  ),
                )
                .toList(),
          );
  }
}

class BlockContactBottomSheet extends StatefulWidget {
  const BlockContactBottomSheet({required this.userId, required this.userName, super.key});
  final String userId;
  final String userName;
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
  State<BlockContactBottomSheet> createState() => _BlockContactBottomSheetState();
}

class _BlockContactBottomSheetState extends State<BlockContactBottomSheet> {
  bool isLoading = false;
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
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Unblock this User!",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(25),
                  const Text(
                    "Would you like to unblock this contact?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(6.0),
                  Text(
                    widget.userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(20.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomButton(
              text: isLoading
                  ? CupertinoActivityIndicator(
                      radius: 14.0,
                      color: Theme.of(context).primaryColor,
                    )
                  : const Text(
                      "Yes Unblock",
                      style: TextStyle(color: Colors.white),
                    ),
              onTap: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      await context.read<ContactRepository>().unBlockContact(context, widget.userId);
                      setState(() => isLoading = false);
                    },
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomButton(
              color: Colors.green,
              text: const Text(
                "No cancel",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.pop();
              },
            ),
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
