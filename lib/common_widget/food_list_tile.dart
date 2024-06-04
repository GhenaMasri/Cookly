import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class FoodItemTile extends StatelessWidget {
  final String imageUrl;
  final String foodName;
  final int quantity;
  final double price;
  final VoidCallback onRemove;

  const FoodItemTile({
    Key? key,
    required this.imageUrl,
    required this.foodName,
    required this.quantity,
    required this.price,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(alignment: Alignment.centerLeft, children: [
      Container(
        width: media.width * 0.25,
        height: 112,
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
        ),
      ),
      Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          width: MediaQuery.of(context).size.width * 0.9, // Increased width
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipOval(
              
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(color: TColor.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(foodName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 5.0),
                    Text('Quantity: $quantity',
                        style: TextStyle(color: TColor.secondaryText)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${price.toStringAsFixed(2)}₪',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: TColor.primary),
                    onPressed: onRemove,
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
