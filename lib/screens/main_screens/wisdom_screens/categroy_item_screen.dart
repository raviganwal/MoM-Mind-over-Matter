import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/screens/main_screens/wisdom_screens/components/category_list_item.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/wisdom.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:mom/widgets/ui_widgets/wisdom_tile.dart';

class CategoryItemsScreen extends StatefulWidget {
  final List<Wisdom> categoryList;
  final String category;

  CategoryItemsScreen({
    required this.categoryList,
    required this.category,
  });

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  late Future<bool> _proValidity;

  @override
  void initState() {
    super.initState();

    _proValidity = checkProValidity();
  }

  Future<bool> checkProValidity() async {
    // Implement the logic to check the user's pro validity using the Firebase database
    // Return true if the user is a pro user, false otherwise
    return await FirebaseController().checkProValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomHeader(title: widget.category),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton.filledTonal(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
            )),
      ),
      body: ListView.builder(
        itemCount: widget.categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          Wisdom wisdom = widget.categoryList[index];
          return FutureBuilder<bool>(
            future: _proValidity,
            builder: (BuildContext context, AsyncSnapshot<bool> proSnapshot) {
              final bool isProUser =
                  proSnapshot.hasData && proSnapshot.data == true;
              bool isLocked = !isProUser &&
                  index >
                      0; // Lock all tiles except the first for non-pro users
              return CategoryListItem(
                wisdom: wisdom,
                isLocked: isLocked,
              );
            },
          );
        },
      ),
    );
  }
}
