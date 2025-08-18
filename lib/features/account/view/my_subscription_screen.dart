import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/subscription/model/subscription_model.dart';
import 'package:ilolo/features/subscription/repository/subscription_repository.dart';
import 'package:provider/provider.dart';

class MySubscriptionScreen extends StatefulWidget {
  const MySubscriptionScreen({super.key});

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  planCategory(String cat) {
    switch (cat) {
      case "L":
        return "Land & Properties";
      case "C":
        return "Cars";
      case "O":
        return "Others";
      default:
        return "Unknown Category.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SubscriptionModel> subscriptions = context.watch<SubscriptionRepository>().subscriptions;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Subscription"),
      ),
      body: subscriptions.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Boxicons.bx_credit_card,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                const Gap(10),
                const Text('No active subscription found')
              ],
            ))
          : Consumer<SubscriptionRepository>(builder: (context, dataProvider, state) {
              final List<SubscriptionModel> subscriptionData = dataProvider.subscriptions;
              return ListView.builder(
                  itemCount: subscriptionData.length,
                  itemBuilder: (context, index) {
                    final data = subscriptionData[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: ListTile(
                        onTap: () {},
                        tileColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Plan: ${data.plan.title.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            Divider(
                              thickness: 0.5,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Category: ",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  TextSpan(
                                    text: "${planCategory(data.plan.categoryType)}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Duration:",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  TextSpan(
                                    text: " ${data.plan.duration} months",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(5),
                            Container(
                              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColorLight, border: Border.all(color: Theme.of(context).primaryColor)),
                              child: Text(
                                data.status,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formatPriceToMoney(data.plan.price.toInt()), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87)),
                            Text(timeAgo(data.createdAt), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  });
            }),
    );
  }
}
