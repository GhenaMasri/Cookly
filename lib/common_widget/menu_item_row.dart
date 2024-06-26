import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/MenuItem.dart';

import '../common/color_extension.dart';

class MenuItemRow extends StatelessWidget {
  final MenuItem mObj;
  final VoidCallback onTap;
  const MenuItemRow({super.key, required this.mObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CachedNetworkImage(
              imageUrl: mObj.image.toString(),
              width: double.maxFinite,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                color: TColor.primary,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: double.maxFinite,
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mObj.name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* Image.asset(
                            "assets/img/rate.png",
                            width: 10,
                            height: 10,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 4,
                          ), */
                          /* Text(
                            mObj["rate"],
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: TColor.primary, fontSize: 11),
                          ),
                          const SizedBox(
                            width: 8,
                          ), */
                          Text(
                            mObj.cName!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.white, fontSize: 15),
                          ),
                          Text(
                            " . ",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: TColor.primary, fontSize: 15),
                          ),
                          Text(
                            mObj.price.toString() +
                                "₪ / " +
                                mObj.qName.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
