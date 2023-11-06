import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mom/core/viewmodel/stripe_view_model.dart';
import 'package:mom/screens/auth_screens/splashscreen.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/ui_widgets/close_button.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  _PaywallScreenState createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int selectedPlanIndex = 0;
  Razorpay razorpay = Razorpay();

  void selectPlan(int index) {
    setState(() {
      selectedPlanIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic
    updateFirebaseOnPaymentSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment error logic
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
  }

  void openCheckout(
      {required String amount,
      required String title,
      required String description}) {
    var options = {
      'key': 'rzp_test_BU3lSHwF7eZaYa',
      'amount': amount, // amount in paise (e.g., 10000 for ₹100)
      'name': title,
      'description': description,
      'prefill': {'contact': '7010863403', 'email': 'mom.soundarya@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateFirebaseOnPaymentSuccess(PaymentSuccessResponse response) {
    final selectedPlan = Plan.getPlans()[selectedPlanIndex];
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime proValidity = DateTime.now();
      if (selectedPlan.name == 'Quarterly') {
        proValidity = proValidity.add(const Duration(days: 90));
      } else if (selectedPlan.name == 'Annual') {
        proValidity = proValidity.add(const Duration(days: 365));
      } else {
        proValidity = proValidity.add(const Duration(days: 30));
      }
      final proValidityInMillis = proValidity.millisecondsSinceEpoch.toString();

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'proValidity': proValidityInMillis}).then((_) {
        showToast('Payment successful');
        Get.to(() => SplashScreen());
      }).catchError((error) {
        showToast('Failed to update user details');
      });
    } else {
      showToast('User not logged in');
    }
    Get.back();
  }

  void showToast(String message) {
    // Show toast message here
    Fluttertoast.showToast(msg: message);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlan = Plan.getPlans()[selectedPlanIndex];
    final stripeViewModel = context.watch<StripeViewModel>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomHeader(title: "Premium"),
                    MyCloseButton(),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Premium Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FeatureList(selectedPlan: selectedPlan),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Choose a Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PlanList(
                    plans: Plan.getPlans(),
                    selectedIndex: selectedPlanIndex,
                    onSelect: selectPlan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        constraints: const BoxConstraints(maxHeight: 80),
        child: ButtonDesign(
          btnText: "SUBSCRIBE",
          btnFunction: () async {
            final selecPlan = Plan.getPlans()[selectedPlanIndex];
            bool success = await stripeViewModel.initPaymentSheet(
                context: context, priceId: selecPlan.priceId);
            // if (widget.title != null && success) {
            //   Navigator.pop(context);
            // } else {
            //   locator<AppRouter>().push(const FollowingTeacherRoute());
            // }
            // openCheckout(
            //     amount: (selecPlan.price * 100).toString(),
            //     title: selecPlan.name,
            //     description: selecPlan.name);
          },
          marginHorizontal: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class FeatureList extends StatelessWidget {
  final Plan selectedPlan;

  const FeatureList({Key? key, required this.selectedPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: selectedPlan.features.map((feature) {
        return ListTile(
          leading: const Icon(Icons.check),
          title: Text(feature),
        );
      }).toList(),
    );
  }
}

class PlanList extends StatelessWidget {
  final List<Plan> plans;
  final int selectedIndex;
  final Function(int) onSelect;

  const PlanList({
    Key? key,
    required this.plans,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlanCard(
            plan: plan,
            isSelected: index == selectedIndex,
            onSelect: () => onSelect(index),
          ),
        );
      },
    );
  }
}

class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const PlanCard({
    Key? key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: Colors.white,
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 32,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${plan.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Plan {
  final String name;
  final int price;
  final String priceId;
  final List<String> features;

  Plan(
      {required this.name,
      required this.price,
      required this.features,
      required this.priceId});

  static List<Plan> getPlans() {
    return [
      Plan(
        name: 'Monthly',
        price: 499,
        features: [
          'One month access to all our CBT and mindfulness program',
          'Access to all podcasts, blogs, videos, and 5-minute exercises',
          'Sign up with a therapist on extra payment',
          'Submit your story to our podcast community',
        ],
        priceId: 'price_1O8j0NSBDQQZAdQFUdY2EpFf',
      ),
      Plan(
        name: 'Quarterly',
        price: 2599,
        features: [
          'Quarterly access to all our CBT and mindfulness program',
          'Access to all podcasts, blogs, videos, and 5-minute exercises',
          'Sign up with a therapist - 1st session free',
          'Submit your story to our podcast community',
        ],
        priceId: 'price_1O8j0NSBDQQZAdQFvTf1WYQA',
      ),
      Plan(
        name: 'Annual',
        price: 4599,
        features: [
          'One year access to all our CBT and mindfulness program',
          'Access to all podcasts, blogs, videos, and 5-minute exercises',
          'Sign up with a therapist 1st session FREE',
          'Submit your story to our podcast community',
          'Have a free mental wellness session at your place every quarter',
        ],
        priceId: 'price_1O9U1vSBDQQZAdQFvv3gUeWM',
      ),
    ];
  }
}
