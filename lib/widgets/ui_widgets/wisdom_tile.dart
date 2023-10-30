import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/screens/feature_screens/paywall_screen.dart';
import 'package:mom/screens/main_screens/wisdom_screens/wisdom_detail_screen.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/services/models/wisdom.dart';
import 'package:mom/widgets/components/no_network_popup.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class WisdomTile extends StatelessWidget {
  const WisdomTile({
    Key? key,
    required this.wisdom,
    required this.isLocked,
  }) : super(key: key);

  final Wisdom wisdom;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool networkState = await checkConnectivity();
        if (networkState) {
          if (isLocked) {
            Get.to(() => const PaywallScreen());
          } else {
            Get.to(() => WisdomDetailScreen(wisdom: wisdom));
          }
        } else {
          Get.dialog(const NoNetworkPopup());
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
                height: 175,
                width: 175,
                paddingHorizontal: 5,
                paddingVertical: 5,
                backgroundColor: const Color(0xFF66C4BC),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 165,
                      width: 165,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          wisdom.imgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    isLocked
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 18,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox()
                  ],
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                wisdom.title,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
