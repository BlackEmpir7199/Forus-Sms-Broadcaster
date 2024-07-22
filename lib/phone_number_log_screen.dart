import 'package:flutter/material.dart';
import 'database_helper.dart';

class PhoneNumberLogScreen extends StatelessWidget {
  final Map<String, dynamic> number;

  const PhoneNumberLogScreen({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs for ${number['name']}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getMessagesForNumber(number['phone_no']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No logs available.'));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(log['status'] == 'received' ? 'Received' : 'Sent'),
                    subtitle: Text(
                      'Time: ${log['timestamp']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
