import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController partyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final dbService = DatabaseService();

  @override
  void dispose() {
    partyController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> saveInvoice() async {
    if (partyController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    double? subtotal = double.tryParse(amountController.text);
    if (subtotal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid amount")),
      );
      return;
    }

    final db = await dbService.database;

    double gst = subtotal * 0.05;
    double total = subtotal + gst;

    String invoiceNo =
        "INV-${DateTime.now().millisecondsSinceEpoch}";

    await db.insert("sales", {
      "invoiceNo": invoiceNo,
      "date": DateTime.now().toIso8601String(),
      "party": partyController.text.trim(),
      "subtotal": subtotal,
      "gst": gst,
      "total": total
    });

    await db.insert("ledger", {
      "date": DateTime.now().toIso8601String(),
      "voucher": invoiceNo,
      "debit": total,
      "credit": 0
    });

    partyController.clear();
    amountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invoice Saved Successfully")),
    );
  }

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
              decoration: InputDecoration(
                labelText: "Party Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveInvoice,
              child: Text("Save Invoice"),
            ),
          ],
        ),
      ),
    );
  }
}
