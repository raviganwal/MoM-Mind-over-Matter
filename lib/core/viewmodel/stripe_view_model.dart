import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mom/app_locator.dart';
import 'package:mom/core/config.dart';
import 'package:mom/core/service/customer_firestore_data.dart';
import 'package:mom/core/viewmodel/base_view_model.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/user.dart' as userModel;
import 'package:provider/provider.dart';

class StripeViewModel extends BaseViewModel {
  CustomerFirestoreData firestoreData = CustomerFirestoreData();
  // final User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> _createSubscriptionPaymentSheet(
      {required priceId}) async {
    userModel.User? user = await FirebaseController.fetchUserDataFromFirebase();
    final url = Uri.parse(locator<Config>().getUrl('createSubscription'));
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': user?.email,
        'name': "${user?.firstName} ${user?.lastName}",
        'uid': user?.userId,
        'priceId': priceId,
      }),
    );
    final body = json.decode(response.body);
    if (body['error'] != null) {
      print(body['error']);
      throw Exception(body['error']);
    }
    return body;
  }

  Future<bool> initPaymentSheet(
      {required BuildContext context, String? priceId}) async {
    try {
      final Map<String, dynamic> data;
      data = await _createSubscriptionPaymentSheet(priceId: priceId);
      // print("customer: ${customer?.id}");
      // 1. create payment intent on the server
      // final data = await _createOneTimePaymentSheet(customerId: customer?.id ?? '');
      print("data: $data");
      print("data: ${data['clientSecret']}");
      print("data: ${data['customer']}");
      print("data: ${data['ephemeralKey']}");
      // create some billingdetails
      final billingDetails = const BillingDetails(
        name: 'Flutter Stripe',
        email: 'email@stripe.com',
      ); // mocked data for tests
      print("billingDetails: ${billingDetails}");
      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['clientSecret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // Customer params
          customerId: data['customerId'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          // Extra params
          primaryButtonLabel: 'Pay now',
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              // background: Colors.lightBlue,
              primary: Color(0xff007084),
              componentBorder: Color(0xff007084),
            ),
            shapes: PaymentSheetShape(
              borderWidth: 1,
              shadow: PaymentSheetShadowParams(color: Color(0xff007084)),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xff007084),
                  // text: Color.fromARGB(255, 235, 92, 30),
                  border: Color(0xff007084),
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      if (context.mounted) {
        bool success = await confirmPayment();
        if (context.mounted && success) {
          Navigator.of(context).pop();
        }
        return success;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Error: ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
      // rethrow;
      return false;
    }
    return false;
  }

  Future<bool> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(
          msg: "Payment succesfully completed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        print("${e.toString()}");
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print("${e.toString()}");
        Fluttertoast.showToast(
            msg: 'Unforeseen error: ${e}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return false;
    }
  }
}
