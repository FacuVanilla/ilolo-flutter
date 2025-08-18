import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:ilolo/features/subscription/repository/subscription_repository.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
// import 'package:ilolo/services/paystack_core/common/paystack.dart';
// import 'package:ilolo/services/paystack_core/models/card.dart';
// import 'package:ilolo/services/paystack_core/models/charge.dart';
// import 'package:ilolo/services/paystack_core/models/checkout_response.dart';

// class PaystackService {
//   final PayWithPayStack payStackInit = PayWithPayStack();
//   final String payStackSecretKey = 'sk_live_d05516397df17e680fa1f3773303e0b9af663913';
//   // final String payStackSecretKey = 'sk_test_0d3e42ebafad3ca9a0d445e478047c3f8962a1f1';

//   Future<void> initializePayment(context, email, amount, referenceKey) async {
//     String cost = (int.parse(amount) * 100).toString();
//     payStackInit.now(
//       context: context,
//       secretKey: payStackSecretKey,
//       customerEmail: email,
//       reference: referenceKey,
//       callbackUrl: "https://ilolo.ng/payment/callback",
//       currency: "NGN",
//       amount: cost,
//       transactionCompleted: () {
//         // print("Transaction Successful");
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessPaymentScreen()));
//       },
//       transactionNotCompleted: () {
//         // print("Transaction Not Successful!");
//         // Navigator.pop(context);
//       },
//     );
//   }
// }

class PaystackService {
  PaystackService(
      {required this.ctx,
      required this.email,
      required this.planId,
      required this.amount});
  BuildContext ctx;
  String email;
  int planId;
  int amount;

  // CardController cardController = Get.put(CardController());
  PaystackPlugin paystack = PaystackPlugin();

  // card payment UI
  PaymentCard _getCardUi() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  // payment reference
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

//   final String payStackSecretKey = 'sk_live_d05516397df17e680fa1f3773303e0b9af663913';
//   // final String payStackSecretKey = 'sk_test_0d3e42ebafad3ca9a0d445e478047c3f8962a1f1';
  Future initializePlugin() async {
    await paystack.initialize(
        publicKey: "pk_live_bd39ab143f5035b92ace5cd2ee711495b4c6ff48");
  }

  // method to charge the card
  chargeCardAndMakePayment() async {
    initializePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = amount * 100
        ..email = email
        ..reference = _getReference()
        ..card = _getCardUi();

      CheckoutResponse response = await paystack.checkout(
        ctx,
        charge: charge,
        method: CheckoutMethod.card,
        // logo: iloloSvg(assetName: "assets/images/ilolo-logo-icon.svg", height: 40),
        logo: Image.asset('assets/icons/iloloicon.png', height: 40),
      );

      // update our server when payment success is true
      if (response.status == true) {
        ctx.loaderOverlay.show();
        await ctx
            .read<SubscriptionRepository>()
            .makeSubscription(ctx, planId, response.reference);
        ctx.loaderOverlay.hide();
      } else {}
    });
  }
}
