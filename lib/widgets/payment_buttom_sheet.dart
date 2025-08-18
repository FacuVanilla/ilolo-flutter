import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/subscription/model/plan_model.dart';
import 'package:ilolo/services/paystack_service.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:provider/provider.dart';

makePaymentBottomSheet<T>(BuildContext context, Plan plan) {
  return showModalBottomSheet<T>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15.0),
        topLeft: Radius.circular(15.0),
      ),
    ),
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    barrierColor: Colors.black54,
    isDismissible: false,

    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Plan Details",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))
              ],
            ),
            const Divider(),
            ListTile(
              title: Text(plan.title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15)),
              subtitle: Text("Plan".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              trailing: Column(
                children: [
                  const Gap(10),
                  Text(
                    "${plan.duration.toString()} Month",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                  ),
                  Text('Duration'.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              // contentPadding: EdgeInsets.zero,
              title: Text("${plan.properties.autoRenew.toString()} Hours", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15)),
              subtitle: Text("Auto Renewal".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              trailing: Column(
                children: [
                  const Gap(10),
                  Text(
                    formatPriceToMoney(plan.price),
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                  ),
                  Text('Amount'.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            const Gap(20),
            CustomButton(
              color: mainColor,
              onTap: () async {
                PaystackService(ctx: context, email:context.read<ProfileRepository>().profileData!.email.toString(), amount: plan.price, planId: plan.id).chargeCardAndMakePayment();
              },
              text: Text(
                'Proceed to Pay',
                style: TextStyle(color: plan.price == 0 ? mainColor : Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
