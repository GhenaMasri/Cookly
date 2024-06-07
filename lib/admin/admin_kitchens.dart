import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/common/color_extension.dart';

class AdminKitchensPage extends StatefulWidget {
  @override
  _AdminKitchensPageState createState() => _AdminKitchensPageState();
}

class _AdminKitchensPageState extends State<AdminKitchensPage> {
  String selectedCity = 'Nablus';
  final Map<String, List<Kitchen>> kitchens = {
    'Nablus': [
      Kitchen('Kitchen 1', 'Active', 4.5, '123-456-7890'),
      Kitchen('Kitchen 2', 'Expired', 3.8, '123-456-7891'),
    ],
    'Ramallah': [
      Kitchen('Kitchen 3', 'Active', 4.2, '123-456-7892'),
      Kitchen('Kitchen 4', 'Expired', 3.5, '123-456-7893'),
    ],
    'Jenin': [
      Kitchen('Kitchen 5', 'Active', 4.0, '123-456-7894'),
      Kitchen('Kitchen 6', 'Expired', 3.7, '123-456-7895'),
    ],
    'Tulkarm': [
      Kitchen('Kitchen 7', 'Active', 4.1, '123-456-7896'),
      Kitchen('Kitchen 8', 'Expired', 3.9, '123-456-7897'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kitchens',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a City',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              dropdownColor: TColor.white,
              value: selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
              items: <String>['Nablus', 'Ramallah', 'Jenin', 'Tulkarm']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: TColor.primary),
              underline: Container(
                height: 2,
                color: TColor.primary,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: kitchens[selectedCity]!.length,
                itemBuilder: (context, index) {
                  final kitchen = kitchens[selectedCity]![index];
                  return Card(
                    color: TColor.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.utensils,
                        color: Colors.teal,
                        size: 30,
                      ),
                      title: Text(
                        kitchen.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                kitchen.status == 'Active'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: kitchen.status == 'Active'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                kitchen.status,
                                style: TextStyle(
                                  color: kitchen.status == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '${kitchen.rate} / 5',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                kitchen.contact,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Kitchen {
  final String name;
  final String status;
  final double rate;
  final String contact;

  Kitchen(this.name, this.status, this.rate, this.contact);
}
