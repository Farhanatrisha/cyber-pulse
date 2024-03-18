import 'package:cyberpulse/controller/app_controller.dart';
import 'package:cyberpulse/model/submission.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'admin_screen.dart';

final dateFormat = DateFormat('dd MMMM, yyyy');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _interestedArea;
  bool _receiveMarketingUpdates = false;
  bool _welshCorrespondence = false;
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    context.read<AppController>().getAllLocalSubject();
    super.initState();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_dateOfBirth == null ||
          DateTime.now().difference(_dateOfBirth!).inDays / 365 < 16) {
        // Show an error message if the date of birth is null or the user is younger than 16 years old
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be at least 16 years old to submit.'),
          ),
        );
        return;
      }

      if (_interestedArea == null) {
        // Show an error message if the interested area is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an interested area.'),
          ),
        );
        return;
      }
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      Submission form = Submission(
          name: _nameController.text,
          email: _emailController.text,
          birthDate: formatter.format(_dateOfBirth!),
          interestedArea: _interestedArea!,
          marketingUpdates: _receiveMarketingUpdates ? "yes" : "no",
          correspondence: _welshCorrespondence ? "yes" : "no",
          latitude: 0.0,
          longitude: 0.0,
          submittedDate: formatter.format(DateTime.now()));
      await context.read<AppController>().saveFormToLocal(form);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  Future<bool> _checkNetworkConnectivity() async {
    return true; // Assuming network connectivity for now
  }

  Future<void> _uploadDataToServer(Map<String, dynamic> record) async {}

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _dateOfBirth = null;
      _interestedArea = null;
      _receiveMarketingUpdates = false;
      _welshCorrespondence = false;
    });
  }

  void _showAdminScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminScreen(),
      ),
    );
  }

  Future<void> _syncWithServer() async {
    // Implement logic to sync local records with the server
    // For example, iterate through _records and upload each record
    // to the server using _uploadDataToServer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf2f2f2),
        title:Image.asset(
          'assets/site-logo.png', // Replace with your logo's file path
          width: 200,
          fit: BoxFit.fill,// Adjust the height as needed
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: portraitForm(context),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: landscapeForm(context),
                  ),
                );
        },
      ),
    );
  }

  Widget portraitForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name*',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Add email validation logic here
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Date of Birth'),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf2f2f2), // Off-white color
              foregroundColor: Colors.black, // Text color (black)
            ),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  _dateOfBirth = selectedDate;
                });
              }
            },
            child: Text(_dateOfBirth == null
                ? 'Select Date'
                : dateFormat.format(_dateOfBirth!)),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: _interestedArea,
            decoration: const InputDecoration(
              labelText: 'Interested Area*',
            ),
            onChanged: (value) {
              setState(() {
                _interestedArea = value;
              });
            },
            items: context
                .watch<AppController>()
                .localSubjects
                .map<DropdownMenuItem<String>>((subject) {
              return DropdownMenuItem<String>(
                value: subject.subjectName,
                child: Text(subject.subjectName),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 22,
          ),
          SwitchListTile(
            title: const Text('Receive Marketing Updates'),
            value: _receiveMarketingUpdates,
            onChanged: (value) {
              setState(() {
                _receiveMarketingUpdates = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Welsh Correspondence'),
            value: _welshCorrespondence,
            onChanged: (value) {
              setState(() {
                _welshCorrespondence = value;
              });
            },
          ),
          const SizedBox(height: 70.0),
          Center(
            child: Container(
              width: 200,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  // Set the background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Set the border radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16), // Set the padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set the text color
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    context.watch<AppController>().addFormLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.drive_folder_upload,
                            color: Colors.white,
                          )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          Center(
            child: InkWell(
              onTap: _showAdminScreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.blue,
                  ),
                  const Text("Admin Section"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget landscapeForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add email validation logic here
                          return null;
                        }),
                    const SizedBox(height: 16.0),
                    Text('Date of Birth'),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf2f2f2),
                        // Off-white color
                        foregroundColor: Colors.black, // Text color (black)
                      ),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _dateOfBirth = selectedDate;
                          });
                        }
                      },
                      child: Text(_dateOfBirth == null
                          ? 'Select Date'
                          : dateFormat.format(_dateOfBirth!)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _interestedArea,
                      decoration: const InputDecoration(
                        labelText: 'Interested Area*',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _interestedArea = value;
                        });
                      },
                      items: context
                          .watch<AppController>()
                          .localSubjects
                          .map<DropdownMenuItem<String>>((subject) {
                        return DropdownMenuItem<String>(
                          value: subject.subjectName,
                          child: Text(subject.subjectName),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30.0),
                    SwitchListTile(
                      title: const Text('Receive Marketing Updates'),
                      value: _receiveMarketingUpdates,
                      onChanged: (value) {
                        setState(() {
                          _receiveMarketingUpdates = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Welsh Correspondence'),
                      value: _welshCorrespondence,
                      onChanged: (value) {
                        setState(() {
                          _welshCorrespondence = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      // Set the background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Set the border radius
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16), // Set the padding
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set the text color
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        context.watch<AppController>().addFormLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.drive_folder_upload,
                                color: Colors.white,
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40.0),
          Center(
            child: InkWell(
              onTap: _showAdminScreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.blue,
                  ),
                  const Text("Admin Section"),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
