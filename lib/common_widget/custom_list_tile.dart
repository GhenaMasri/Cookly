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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: ClipOval(
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset(
                      mObj["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    mObj["name"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    mObj["type"],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: TColor.primary),
                        SizedBox(width: 4),
                        Text(
                          mObj["rate"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${mObj["rating"]} ratings',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
