import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/order/assign_delivery.dart';
import '../common_widget/round_button.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;

  OrderDetailsPage({required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status'];
  }

  @override
  Widget build(BuildContext context) {
    double subtotal =
        widget.order['items'].fold(0, (sum, item) => sum + item['price']);
    double deliveryCost = 2.0; // example delivery cost
    double total = subtotal + deliveryCost;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: TColor.white),
        ),
        backgroundColor: TColor.primary,
        iconTheme: IconThemeData(color: TColor.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerDetails(),
              const SizedBox(height: 20),
              if (_currentStatus != 'delivered') _buildStatusSegmentedControl(),
              if (_currentStatus != 'delivered') const SizedBox(height: 20),
              Text(
                'Items:',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildOrderItems(),
              const SizedBox(height: 20),
              _buildOrderNotes(),
              const SizedBox(height: 15),
              _buildCostSummary(subtotal, deliveryCost, total),
              const SizedBox(height: 25),
              if ((_currentStatus == 'done') &&
                  widget.order['delivery'] == 'yes')
                _bulidAssignButton()
              else if ((_currentStatus == 'done') &&
                  widget.order['delivery'] == 'no')
                _bulidPickedUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulidAssignButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RoundButton(
            title: "Assign to Delivery",
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return const AssignDeliveryView();
                  });
            }));
  }

  Widget _bulidPickedUpButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RoundButton(
            title: "Picked Up",
            onPressed: () {
              //Convert the status of the order to done
            }));
  }

  Widget _buildCustomerDetails() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order['customerName'],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Location: ${widget.order['location']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order Time: ${widget.order['orderTime']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Contact Number: ${widget.order['ContactNumber']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Container(
      decoration: BoxDecoration(color: TColor.textfield),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.order['items'].length,
        separatorBuilder: (context, index) => Divider(
          indent: 25,
          endIndent: 25,
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
        itemBuilder: (context, index) {
          var item = widget.order['items'][index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item['name']} x${item['qty']}",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${item['price']}₪",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!item["item_notes"].toString().isEmpty)
                        Text(
                          "Notes: ${item["notes"]}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      const SizedBox(height: 5),
                      if (!item["item_notes"].toString().isEmpty)
                        Text(
                          "Sub-Quantity: ${item["sub_quantity"]}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Any Notes',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Notes',
          style: TextStyle(
            color: TColor.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
      ],
    );
  }

  Widget _buildCostSummary(double subtotal, double deliveryCost, double total) {
    return Column(
      children: [
        _buildCostRow('Sub Total', subtotal),
        const SizedBox(height: 8),
        _buildCostRow('Delivery Cost', deliveryCost),
        const SizedBox(height: 15),
        Divider(
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${total.toStringAsFixed(2)}₪",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${amount.toStringAsFixed(2)}₪",
          style: TextStyle(
            color: TColor.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSegmentedControl() {
    List<String> statusesOrder = ['pending', 'in progress', 'done'];

    // Find the index of the current status in the order
    int currentStatusIndex = statusesOrder.indexOf(_currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Order Status',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              children: <Widget>[
                _buildStatusButton(
                    'Pending', Colors.yellow, _currentStatus == 'pending'),
                _buildStatusButton('In Progress', Colors.orange,
                    _currentStatus == 'in progress'),
                _buildStatusButton(
                    'Done', Colors.green, _currentStatus == 'done'),
              ],
              isSelected: [
                _currentStatus == 'pending',
                _currentStatus == 'in progress',
                _currentStatus == 'done'
              ],
              onPressed: (int index) {
                int nextStatusIndex = currentStatusIndex + 1;

                if (index == nextStatusIndex &&
                    nextStatusIndex < statusesOrder.length) {
                  setState(() {
                    _currentStatus = statusesOrder[nextStatusIndex];
                    //If current status == 'done' and no delivery send noification to the user
                  });
                }
              },
              color: TColor.primaryText,
              selectedColor: TColor.white,
              fillColor: Colors.transparent,
              selectedBorderColor: TColor.white,
              //borderColor: TColor.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String text, Color color, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.7),
            color.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? TColor.white : TColor.primaryText,
        ),
      ),
    );
  }
}
