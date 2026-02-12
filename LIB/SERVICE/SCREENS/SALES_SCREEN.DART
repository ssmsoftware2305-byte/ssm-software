import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SalesScreen extends StatelessWidget {
  final TextEditingController partyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales Invoice")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: partyController,
              decoration: InputDecoration(labelText: "Party Name"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Save Invoice"),
              onPressed: () async {
                final db = await dbService.database;

                double subtotal = double.parse(amountController.text);
                double gst = subtotal * 0.05;
                double total = subtotal + gst;

                await db.insert("sales", {
                  "invoiceNo": DateTime.now().millisecondsSinceEpoch.toString(),
                  "date": DateTime.now().toString(),
                  "party": partyController.text,
                  "subtotal": subtotal,
                  "gst": gst,
                  "total": total
                });

                await db.insert("ledger", {
                  "date": DateTime.now().toString(),
                  "voucher": "Sales",
                  "debit": total,
                  "credit": 0
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invoice Saved")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
