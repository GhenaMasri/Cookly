import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import '../common_widget/round_button.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    double subtotal = order['items'].fold(0, (sum, item) => sum + item['price']);
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
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
                order['customerName'],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Location: ${order['location']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order Time: ${order['orderTime']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Contact Number: ${order['ContactNumber']}',
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
        itemCount: order['items'].length,
        separatorBuilder: (context, index) => Divider(
          indent: 25,
          endIndent: 25,
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
        itemBuilder: (context, index) {
          var item = order['items'][index];
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
                    "\$${item['price']}",
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
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item["notes"] != null)
                        Text(
                          "Notes: ${item["notes"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (item["sub_quantity"] != null)
                        Text(
                          "Sub-Quantity: ${item["sub_quantity"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
              "\$${total.toStringAsFixed(2)}",
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
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: TColor.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        RoundButton(
          title: 'Accept',
          onPressed: () {
            // Implement accept functionality
          },
        ),
        const SizedBox(height: 10),
        RoundButton(
          title: 'Decline',
          type: RoundButtonType.textPrimary,
          onPressed: () {
            // Implement decline functionality
          },
        ),
      ],
    );
  }
}
