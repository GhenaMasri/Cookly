import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';

class AddDeliveryView extends StatefulWidget {
  const AddDeliveryView({super.key});

  @override
  State<AddDeliveryView> createState() => _AddDeliveryViewState();
}

class _AddDeliveryViewState extends State<AddDeliveryView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedLocation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_passwordController.text != value) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits long';
    }
    if (!value.startsWith('059') && !value.startsWith('056')) {
      return 'Phone number must start with 059 or 056';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Add Delivery Man',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  focusColor: TColor.primary,
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                 
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  focusColor: TColor.primary,
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: _validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  focusColor: TColor.primary,
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: _validatePhoneNumber,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  focusColor: TColor.primary,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: TColor.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: _validatePassword,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: TColor.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: TColor.white,
                decoration: InputDecoration(
                  fillColor: TColor.white,
                  focusColor: TColor.primary,
                  labelText: 'Location',
                  labelStyle: TextStyle(
                    color:Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColor.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                items: ['Nablus', 'Ramallah', 'Jenin', 'Tulkarm']
                    .map((location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                value: _selectedLocation,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              RoundButton(
                title: "Add",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the data
                    IconSnackBar.show(context,
                        snackBarType: SnackBarType.success,
                        label: 'Delivery Man Added Successfully',
                        snackBarStyle: SnackBarStyle(
                            backgroundColor: TColor.primary,
                            labelTextStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)));
                    // clear the form
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _phoneController.clear();
                    _emailController.clear();
                    _selectedLocation = null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
