import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('About Us',
        style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: TColor.primary,
                radius: 50,
                child: Text(
                  'C',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Cookly!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: TColor.primary),
            ),
            SizedBox(height: 10),
            Text(
              'Your ultimate companion in the world of home cooking. Our app is designed to simplify the way you plan, order, and enjoy meals from local chefs. We connect food enthusiasts with talented home cooks, offering a platform where convenience, quality, and community come together seamlessly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              'At Cookly, we believe in the power of home cooking to bring people together. Our features include personalized menus, direct chef interactions, and a rewards system that makes each order a delightful experience. Join us and explore the joy of discovering homemade dishes, all from the comfort of your home. Cookly—where great food meets great community.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: TColor.primary),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(Icons.email, color: TColor.primary, size: 30),
                title: Text('contact@cookly.com', style: TextStyle(fontSize: 18)),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(Icons.phone, color: TColor.primary, size: 30),
                title: Text('+970 597 280 457', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}