import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({Key? key}) : super(key: key);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> _selectedInvitees = [];
  final User _user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _familyMembers = [];

  final Color bgColor = const Color(0xFF1C2341);
  final Color containerColor = const Color(0xFF272D4A);
  final Color white = const Color.fromARGB(255, 232, 218, 218);

  @override
  void initState() {
    super.initState();
    _fetchFamilyMembers();
  }

  Future<void> _fetchFamilyMembers() async {
    try {
      // Get all users with the same homeCode except the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('homeCode', isEqualTo: _user.uid) // Assuming homeCode is stored under 'uid' in users collection
          .get();

      setState(() {
        _familyMembers =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching family members: $e');
      // Show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Yeni Aktivite Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Konum (isteğe bağlı)',
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Tarih Seçin'),
                subtitle: Text('${DateFormat('dd-MM-yyyy').format(_selectedDate)}'),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Saat Seçin'),
                subtitle: Text('${_selectedTime.format(context)}'),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _selectInvitees,
                child: Text('Davetli Seçin (${_selectedInvitees.length})'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createActivity,
                child: Text('Aktiviteyi Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectInvitees() async {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Davetli Seçin'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _familyMembers.map((member) {
                    bool isSelected = _selectedInvitees.contains(member['uid']);
                    return CheckboxListTile(
                      title: Text(member['displayName'] ?? ''), // Replace with user display name
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedInvitees.add(member['uid']);
                          } else {
                            _selectedInvitees.remove(member['uid']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error fetching family members: $e');
      // Show error message to user
    }
  }

  Future<void> _createActivity() async {
    try {
      String title = _titleController.text.trim();
      String? location = _locationController.text.isNotEmpty ? _locationController.text.trim() : null;
      DateTime combinedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      List<String> invitees = _selectedInvitees;
      String createdBy = _user.uid;
      List<String> participants = [_user.uid]; // Include creator in participants initially

      // Save activity to Firestore
      await _firestore.collection('activities').add({
        'title': title,
        'location': location,
        'dateTime': Timestamp.fromDate(combinedDateTime),
        'invitees': invitees,
        'createdBy': createdBy,
        'participants': participants,
      });

      // Navigate back or show success message
      Navigator.pop(context);
    } catch (e) {
      print('Error creating activity: $e');
      // Show error message to user
    }
  }
}
