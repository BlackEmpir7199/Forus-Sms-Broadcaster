import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'database_helper.dart';

class ReadSmsScreen extends StatefulWidget {
  const ReadSmsScreen({Key? key}) : super(key: key);

  @override
  State<ReadSmsScreen> createState() => _ReadSmsScreenState();
}

class _ReadSmsScreenState extends State<ReadSmsScreen> {
  final Telephony telephony = Telephony.instance;
  final DatabaseHelper dbHelper = DatabaseHelper();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Future<void> _startListening() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) async {
          final numbers = await dbHelper.getNumbers();
          final receivedNumber = message.address;

          if (receivedNumber != null && numbers.any((number) => number['phone_no'] == receivedNumber)) {
            setState(() {
              _messages.add({
                'phone_no': receivedNumber,
                'body': message.body,
                'timestamp': DateTime.now().toIso8601String(),
              });
            });

            await _broadcastMessage(message.body ?? '', receivedNumber);
          }
        },
        listenInBackground: false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS permissions not granted.')),
      );
    }
  }

  Future<void> _broadcastMessage(String message, String sender) async {
    final numbers = await dbHelper.getNumbers();
    for (var number in numbers) {
      if (number['phone_no'] != sender) {
        try {
          await telephony.sendSms(to: number['phone_no'], message: message);
        } catch (e) {
          print('Error sending SMS to ${number['phone_no']}: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Received Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('No messages received.'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            'Message from ${message['phone_no']}',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            'Message: ${message['body']}\n'
                            'Timestamp: ${message['timestamp']}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
