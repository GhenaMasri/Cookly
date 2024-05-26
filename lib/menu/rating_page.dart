import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart'; // Import RatingBar widget

class RateItemView extends StatefulWidget {
  const RateItemView({Key? key}) : super(key: key);

  @override
  State<RateItemView> createState() => _RateItemViewState();
}

class _RateItemViewState extends State<RateItemView> {
  double _rating = 3; // Variable to store the rating value

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: media.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rate Kitchen",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 25,
                ),
              )
            ],
          ),
          Divider(
            color: Colors.grey.withOpacity(0.4),
            height: 1,
          ),
          const SizedBox(height: 15),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                Icon(Icons.star, color: TColor.primary),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 15),
          RoundButton(
            title: 'Done',
            onPressed: () {
              print("Rating: $_rating");
              Navigator.pop(context); // Close the rating dialog
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
