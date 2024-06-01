import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class CustomListTile extends StatelessWidget {
  final Map mObj;
  final VoidCallback onTap;

  const CustomListTile({
    Key? key,
    required this.mObj,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TColor
                              .primary, 
                          width: 2, 
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35, 
                        backgroundColor: Colors
                            .transparent, 
                        backgroundImage: CachedNetworkImageProvider(
                          mObj["logo"],
                        ),
                      ),
                    )),
              ],
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    mObj["kitchen_name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Order: " +
                        (mObj["order_system"] == 0 ? "Day before" : "Same day"),
                    style: TextStyle(
                      fontSize: 14,
                      color: TColor.secondaryText,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: TColor.primary),
                      SizedBox(width: 6),
                      Text(
                        mObj["rate"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: TColor.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Container(
                   /*  padding: EdgeInsets.symmetric(
                        horizontal: 8.0),  */// Adjust horizontal padding as needed
                    child: SizedBox(
                      width: double
                          .infinity, // Ensure the container takes the available width
                      child: Container(
                        decoration: BoxDecoration(
                          color: mObj["status"] == "open"
                              ? Colors.green
                              : Color.fromARGB(255, 222, 0, 56),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Center(
                          child: Text(
                            mObj["status"] == "open" ? "Open" : "Closed",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
