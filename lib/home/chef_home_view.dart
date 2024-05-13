import 'package:flutter/material.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/menu/manage_menu_item.dart';
import 'package:untitled/menu/menu_item.dart';

class ChefHomeView extends StatefulWidget {
  const ChefHomeView({Key? key}) : super(key: key);

  @override
  State<ChefHomeView> createState() => _ChefHomeViewState();
}

class _ChefHomeViewState extends State<ChefHomeView> {
  String? selectedLocation;
  TextEditingController txtSearch = TextEditingController();

  List<MenuItem> menuArr = List.generate(
    8,
    (index) => MenuItem(
      kitchenId: 1,
      itemId: index,
      image:
          "https://firebasestorage.googleapis.com/v0/b/cookly-495b4.appspot.com/o/images%2Fmenu_1.png?alt=media&token=e50f35aa-5224-4c69-ba9c-054861ba4610",
      name: "Food",
      notes: "This section will contain the ingredients",
      category: 1,
      quantity: 1,
      price: 20.0,
      time: "00:01:00",
    ),
  );
  void addItemToList(MenuItem item) {
    setState(() {
      menuArr.add(item);
      //Also Add to DB
    });
  }

  void RemoveItemFromList(MenuItem item) {
    setState(() {
      menuArr.remove(item);
      //Also remove from DB
    });
  }

  void updateMenuItem(MenuItem updatedItem) {
    setState(() {
      final index =
          menuArr.indexWhere((item) => item.itemId == updatedItem.itemId);
      if (index != -1) {
        menuArr[index] = updatedItem;
        //Also update in DB
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Notifications()));*/
                    },
                    icon: Image.asset(
                      "assets/img/notification.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundTextfield(
                hintText: "Search Food",
                controller: txtSearch,
                left: Container(
                  alignment: Alignment.center,
                  width: 30,
                  child: Image.asset(
                    "assets/img/search.png",
                    width: 20,
                    height: 20,
                    color: TColor.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (menuArr.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Text(
                    "Start Adding Your Menu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                itemCount: menuArr.length,
                itemBuilder: ((context, index) {
                  var menuItem = menuArr[index];
                  return GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuItemsView(
                          menuItem: menuItem,
                        ),
                      ),
                    );*/
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 3),
                            ClipOval(
                              child: Image.network(
                                menuItem.image!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    menuItem.name!,
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ingredients: ${menuItem.notes}",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageMenuItemView(
                                      RemoveItemFromList: RemoveItemFromList,
                                      updateMenuItem: updateMenuItem,
                                      item: menuItem,
                                    ),
                                  ),
                                );
                              },
                              icon: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(17.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/img/btn_next.png",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MenuItemView(menu: menuArr, addItemToList: addItemToList),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}