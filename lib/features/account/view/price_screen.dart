import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/subscription/repository/plan_repository.dart';
import 'package:ilolo/features/subscription/view/plan_detail_screen.dart';
import 'package:ilolo/widgets/app_bar/pricing_app_bar_widget.dart';
import 'package:provider/provider.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({super.key});

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  @override
  void initState() {
    super.initState();
    context.read<PlanRepository>().getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PricingAppBarWidget(),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(color: Colors.blue[50], border: Border.all(color: Theme.of(context).primaryColorLight, width: 2.0), borderRadius: BorderRadius.circular(12)),
            child: const Column(
              children: [
                Text(
                  "Simple, transparent pricing",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Text(
                  "Choose a suitable plan for your ad.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Gap(1),
                Text(
                  "No contracts, No hidden charges.",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PlanDetailScreen(title: 'Cars',)));
              },
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(Boxicons.bx_car, color: Theme.of(context).primaryColor),
              title: const Text("Cars"),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PlanDetailScreen(title: 'Land & Properties',)));
              },
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(Boxicons.bx_home, color: Theme.of(context).primaryColor),
              title: const Text("Land & Properties"),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PlanDetailScreen(title: 'Others',)));
              },
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(Boxicons.bxs_category, color: Theme.of(context).primaryColor),
              title: const Text("Others"),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
