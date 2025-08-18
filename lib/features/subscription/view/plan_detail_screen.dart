import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/subscription/model/plan_model.dart';
import 'package:ilolo/features/subscription/repository/plan_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/payment_buttom_sheet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({required this.title, super.key});
  final String title;

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  int _selectedIndex = 0;

  void _onSegmentChanged(int? index) => setState(() => _selectedIndex = index!);
  getTypeProvider() {
    if (widget.title == "Cars") {
      return context.watch<PlanRepository>().plans!.cars;
    } else if (widget.title == "Land & Properties") {
      return context.watch<PlanRepository>().plans!.land;
    } else if (widget.title == "Others") {
      return context.watch<PlanRepository>().plans!.others;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PlanRepository>().getPlans();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> planWidgets = [
      OneMonthWidget(
        typeProvider: getTypeProvider(),
      ),
      ThreeMonthsWidget(
        typeProvider: getTypeProvider(),
      ),
      SixMonthsWidget(
        typeProvider: getTypeProvider(),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: LoaderOverlay(
        child: SafeArea(
            child: Column(
          children: [
            const Gap(10),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: double.infinity, // Full width
                child: CupertinoSlidingSegmentedControl(
                  children: const {
                    0: Text('1 Month'),
                    1: Text('3 Months'),
                    2: Text('6 Months'),
                  },
                  groupValue: _selectedIndex,
                  onValueChanged: _onSegmentChanged,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: planWidgets[_selectedIndex],
            ))
          ],
        )),
      ),
    );
  }
}

class OneMonthWidget extends StatefulWidget {
  const OneMonthWidget({required this.typeProvider, super.key});
  final List<Plan> typeProvider;

  @override
  State<OneMonthWidget> createState() => _OneMonthWidgetState();
}

class _OneMonthWidgetState extends State<OneMonthWidget> {
  bool isIdle = true;

  @override
  Widget build(BuildContext context) {
    final planData = widget.typeProvider.where((plan) => plan.duration == 1).toList();
    return ListView.builder(
      itemCount: planData.length,
      itemBuilder: (context, index) {
        Plan plan = planData[index];
        Color enabledColor = plan.properties.autoRenew != 0 ? Colors.black : Colors.black12;
        Color enabledSmsColor = plan.properties.sms ? Colors.black : Colors.black12;
        Color enabledBadgeColor = plan.properties.badge != null ? Colors.black : Colors.black12;
        Color enabledLinksColor = plan.properties.links ? Colors.black : Colors.black12;
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(50)),
                      child: plan.icon == "bx-cookie"
                          ? const Icon(Boxicons.bxs_cookie)
                          : plan.icon == "bx-trending-up"
                              ? const Icon(Boxicons.bx_trending_up)
                              : plan.icon == "bx-crown"
                                  ? const Icon(Boxicons.bx_crown)
                                  : plan.icon == "bx-trophy"
                                      ? const Icon(Boxicons.bx_trophy)
                                      : const Icon(Boxicons.bx_diamond),
                    ),
                    plan.tag != null
                        ? Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight), borderRadius: BorderRadius.circular(10)),
                            child: Text(plan.tag.toString()),
                          )
                        : const SizedBox(),
                  ],
                ),
                const Gap(15),
                Text(
                  plan.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Gap(10),
                Text(
                  plan.price == 0 ? "Free" : formatPriceToMoney(plan.price),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const Gap(20),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Up to ${plan.properties.count <= 1 ? '${plan.properties.count} ad' : '${plan.properties.count} ads'}",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                  subtitle: const Text('Easily post ads in category.', style: TextStyle(color: Colors.black)),
                  leading: const Icon(Boxicons.bxs_package, color: Colors.black),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Auto Renewal", style: TextStyle(color: enabledColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Auto renews every ${plan.properties.autoRenew} hours.', style: TextStyle(color: enabledColor)),
                  leading: Icon(
                    Boxicons.bx_refresh,
                    color: enabledColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("New message notification", style: TextStyle(color: enabledSmsColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Get an SMS when you get a message.', style: TextStyle(color: enabledSmsColor)),
                  leading: Icon(
                    Boxicons.bx_bell,
                    color: enabledSmsColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Ad Badge", style: TextStyle(color: enabledBadgeColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Badge set you apart from other sellers.', style: TextStyle(color: enabledBadgeColor)),
                  leading: Icon(
                    Boxicons.bx_badge,
                    color: enabledBadgeColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Website & Social media links", style: TextStyle(color: enabledLinksColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Add link to your website and social media pages.', style: TextStyle(color: enabledLinksColor)),
                  leading: Icon(
                    Boxicons.bx_link,
                    color: enabledLinksColor,
                  ),
                ),
                CustomButton(
                  color: plan.price == 0 ? Colors.white : mainColor,
                  onTap: plan.price == 0
                      ? () {}
                      : isIdle
                          ? () async {
                              final bool isLogged = await authMiddleware();
                              setState(() => isIdle = false);
                              // makePaymentBottomSheet(context, plan, 'title', 'reference');
                              Future.microtask(() async {
                                // context.loaderOverlay.show();
                                isLogged 
                                ? makePaymentBottomSheet(context, plan) 
                                : GoRouter.of(context).push('/login');
                              });
                              setState(() => isIdle = true);
                            }
                          : null,
                  text: isIdle
                      ? Text(
                          plan.price == 0 ? 'Active' : 'Get Started',
                          style: TextStyle(color: plan.price == 0 ? mainColor : Colors.white),
                        )
                      : CupertinoActivityIndicator(radius: 12.0, color: Theme.of(context).primaryColor),
                ),
                const Gap(15)
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThreeMonthsWidget extends StatefulWidget {
  const ThreeMonthsWidget({required this.typeProvider, super.key});
  final List<Plan> typeProvider;

  @override
  State<ThreeMonthsWidget> createState() => _ThreeMonthsWidgetState();
}

class _ThreeMonthsWidgetState extends State<ThreeMonthsWidget> {
  bool isIdle = true;
  @override
  Widget build(BuildContext context) {
    final planData = widget.typeProvider.where((plan) => plan.duration == 3).toList();
    return ListView.builder(
      itemCount: planData.length,
      itemBuilder: (context, index) {
        Plan plan = planData[index];
        Color enabledColor = plan.properties.autoRenew != 0 ? Colors.black : Colors.black12;
        Color enabledSmsColor = plan.properties.sms ? Colors.black : Colors.black12;
        Color enabledBadgeColor = plan.properties.badge != null ? Colors.black : Colors.black12;
        Color enabledLinksColor = plan.properties.links ? Colors.black : Colors.black12;
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(50)),
                      child: plan.icon == "bx-cookie"
                          ? const Icon(Boxicons.bxs_cookie)
                          : plan.icon == "bx-trending-up"
                              ? const Icon(Boxicons.bx_trending_up)
                              : plan.icon == "bx-crown"
                                  ? const Icon(Boxicons.bx_crown)
                                  : plan.icon == "bx-trophy"
                                      ? const Icon(Boxicons.bx_trophy)
                                      : const Icon(Boxicons.bx_diamond),
                    ),
                    plan.tag != null
                        ? Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight), borderRadius: BorderRadius.circular(10)),
                            child: Text(plan.tag.toString()),
                          )
                        : const SizedBox(),
                  ],
                ),
                const Gap(15),
                Text(
                  plan.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Gap(10),
                Text(
                  plan.price == 0 ? "Free" : formatPriceToMoney(plan.price),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const Gap(20),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Up to ${plan.properties.count <= 1 ? '${plan.properties.count} ad' : '${plan.properties.count} ads'}",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                  subtitle: const Text('Easily post ads in category.', style: TextStyle(color: Colors.black)),
                  leading: const Icon(Boxicons.bxs_package, color: Colors.black),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Auto Renewal", style: TextStyle(color: enabledColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Auto renews every ${plan.properties.autoRenew} hours.', style: TextStyle(color: enabledColor)),
                  leading: Icon(
                    Boxicons.bx_refresh,
                    color: enabledColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("New message notification", style: TextStyle(color: enabledSmsColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Get an SMS when you get a message.', style: TextStyle(color: enabledSmsColor)),
                  leading: Icon(
                    Boxicons.bx_bell,
                    color: enabledSmsColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Ad Badge", style: TextStyle(color: enabledBadgeColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Badge set you apart from other sellers.', style: TextStyle(color: enabledBadgeColor)),
                  leading: Icon(
                    Boxicons.bx_badge,
                    color: enabledBadgeColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Website & Social media links", style: TextStyle(color: enabledLinksColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Add link to your website and social media pages.', style: TextStyle(color: enabledLinksColor)),
                  leading: Icon(
                    Boxicons.bx_link,
                    color: enabledLinksColor,
                  ),
                ),
                CustomButton(
                  color: plan.price == 0 ? Colors.white : mainColor,
                  onTap: plan.price == 0
                      ? () {}
                      : isIdle
                          ? () async {
                              final bool isLogged = await authMiddleware();
                              setState(() => isIdle = false);
                              // makePaymentBottomSheet(context, plan, 'title', 'reference');
                              Future.microtask(() async {
                                isLogged ? makePaymentBottomSheet(context, plan) : GoRouter.of(context).push('/login');
                              });
                              setState(() => isIdle = true);
                            }
                          : null,
                  text: isIdle
                      ? Text(
                          plan.price == 0 ? 'Active' : 'Get Started',
                          style: TextStyle(color: plan.price == 0 ? mainColor : Colors.white),
                        )
                      : CupertinoActivityIndicator(radius: 12.0, color: Theme.of(context).primaryColor),
                ),
                const Gap(15)
              ],
            ),
          ),
        );
      },
    );
  }
}

class SixMonthsWidget extends StatefulWidget {
  const SixMonthsWidget({required this.typeProvider, super.key});
  final List<Plan> typeProvider;

  @override
  State<SixMonthsWidget> createState() => _SixMonthsWidgetState();
}

class _SixMonthsWidgetState extends State<SixMonthsWidget> {
  bool isIdle = true;
  @override
  Widget build(BuildContext context) {
    final planData = widget.typeProvider.where((plan) => plan.duration == 6).toList();
    return ListView.builder(
      itemCount: planData.length,
      itemBuilder: (context, index) {
        Plan plan = planData[index];
        Color enabledColor = plan.properties.autoRenew != 0 ? Colors.black : Colors.black12;
        Color enabledSmsColor = plan.properties.sms ? Colors.black : Colors.black12;
        Color enabledBadgeColor = plan.properties.badge != null ? Colors.black : Colors.black12;
        Color enabledLinksColor = plan.properties.links ? Colors.black : Colors.black12;
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(50)),
                      child: plan.icon == "bx-cookie"
                          ? const Icon(Boxicons.bxs_cookie)
                          : plan.icon == "bx-trending-up"
                              ? const Icon(Boxicons.bx_trending_up)
                              : plan.icon == "bx-crown"
                                  ? const Icon(Boxicons.bx_crown)
                                  : plan.icon == "bx-trophy"
                                      ? const Icon(Boxicons.bx_trophy)
                                      : const Icon(Boxicons.bx_diamond),
                    ),
                    plan.tag != null
                        ? Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight), borderRadius: BorderRadius.circular(10)),
                            child: Text(plan.tag.toString()),
                          )
                        : const SizedBox(),
                  ],
                ),
                const Gap(15),
                Text(
                  plan.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Gap(10),
                Text(
                  plan.price == 0 ? "Free" : formatPriceToMoney(plan.price),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const Gap(20),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Up to ${plan.properties.count <= 1 ? '${plan.properties.count} ad' : '${plan.properties.count} ads'}",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                  subtitle: const Text('Easily post ads in category.', style: TextStyle(color: Colors.black)),
                  leading: const Icon(Boxicons.bxs_package, color: Colors.black),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Auto Renewal", style: TextStyle(color: enabledColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Auto renews every ${plan.properties.autoRenew} hours.', style: TextStyle(color: enabledColor)),
                  leading: Icon(
                    Boxicons.bx_refresh,
                    color: enabledColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("New message notification", style: TextStyle(color: enabledSmsColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Get an SMS when you get a message.', style: TextStyle(color: enabledSmsColor)),
                  leading: Icon(
                    Boxicons.bx_bell,
                    color: enabledSmsColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Ad Badge", style: TextStyle(color: enabledBadgeColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Badge set you apart from other sellers.', style: TextStyle(color: enabledBadgeColor)),
                  leading: Icon(
                    Boxicons.bx_badge,
                    color: enabledBadgeColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Website & Social media links", style: TextStyle(color: enabledLinksColor, fontWeight: FontWeight.w900)),
                  subtitle: Text('Add link to your website and social media pages.', style: TextStyle(color: enabledLinksColor)),
                  leading: Icon(
                    Boxicons.bx_link,
                    color: enabledLinksColor,
                  ),
                ),
                CustomButton(
                  color: plan.price == 0 ? Colors.white : mainColor,
                  onTap: plan.price == 0
                      ? () {}
                      : isIdle
                          ? () async {
                              final bool isLogged = await authMiddleware();
                              setState(() => isIdle = false);
                              // makePaymentBottomSheet(context, plan, 'title', 'reference');
                              Future.microtask(() async {
                                isLogged ? makePaymentBottomSheet(context, plan) : GoRouter.of(context).push('/login');
                              });
                              setState(() => isIdle = true);
                            }
                          : null,
                  text: isIdle
                      ? Text(
                          plan.price == 0 ? 'Active' : 'Get Started',
                          style: TextStyle(color: plan.price == 0 ? mainColor : Colors.white),
                        )
                      : CupertinoActivityIndicator(radius: 12.0, color: Theme.of(context).primaryColor),
                ),
                const Gap(15)
              ],
            ),
          ),
        );
      },
    );
  }
}
