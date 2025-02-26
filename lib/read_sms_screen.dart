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
        onBackgroundMessage: backgroundMessageHandler,
        listenInBackground: true,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS permissions not granted.')),
      );
    }
  }

  static Future<void> backgroundMessageHandler(SmsMessage message) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    final numbers = await dbHelper.getNumbers();
    final receivedNumber = message.address;

    if (receivedNumber != null && numbers.any((number) => number['phone_no'] == receivedNumber)) {
      await _broadcastMessage(message.body ?? '', receivedNumber);
    }
  }

  static Future<void> _broadcastMessage(String message, String sender) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    final numbers = await dbHelper.getNumbers();
    final Telephony telephony = Telephony.instance;

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

  Future<void> _deleteMessage(int index) async {
    setState(() {
      _messages.removeAt(index);
    });
  }

  Future<void> _deleteAllMessages() async {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Received Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _messages.isEmpty
                ? null
                : () async {
                    await _deleteAllMessages();
                  },
          ),
        ],
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
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _deleteMessage(index);
                            },
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
