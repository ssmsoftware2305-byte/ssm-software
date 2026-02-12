import 'package:flutter/material.dart';
import 'sales_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String companyName;

  DashboardScreen({required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(companyName)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Create Sales Invoice"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesScreen()),
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
