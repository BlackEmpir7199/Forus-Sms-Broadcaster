import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'phone_number_log_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final List<Map<String, dynamic>> _phoneNumbers = [];

  @override
  void initState() {
    super.initState();
    _loadPhoneNumbers();
  }

  Future<void> _loadPhoneNumbers() async {
    final numbers = await dbHelper.getNumbers();
    setState(() {
      _phoneNumbers.clear();
      _phoneNumbers.addAll(numbers);
    });
  }

  Future<void> _showAddPhoneNumberDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final locationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number')),
              TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final phoneNo = '+91${phoneController.text}';
                _addPhoneNumber(nameController.text, phoneNo, locationController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addPhoneNumber(String name, String phoneNo, String location) async {
    final number = {
      'name': name,
      'phone_no': phoneNo,
      'location': location,
    };
    await dbHelper.insertNumber(number);
    _loadPhoneNumbers();
  }

  void _deletePhoneNumber(int id) async {
    await dbHelper.deleteNumber(id);
    _loadPhoneNumbers();
  }

  Future<void> _clearAllNumbers() async {
    await dbHelper.deleteAllNumbers();
    _loadPhoneNumbers();
  }

  void _showPhoneNumberLog(Map<String, dynamic> number) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhoneNumberLogScreen(number: number),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _clearAllNumbers,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _phoneNumbers.length,
              itemBuilder: (context, index) {
                final number = _phoneNumbers[index];
                return GestureDetector(
                  onTap: () => _showPhoneNumberLog(number),
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(number['name'], style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(
                        'Phone: ${number['phone_no']}\nLocation: ${number['location']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePhoneNumber(number['id']),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPhoneNumberDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
