import 'package:cyberpulse/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/submission.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({Key? key}) : super(key: key);

  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  late AppController _appController;

  @override
  void initState() {
    super.initState();
    context.read<AppController>().getAllLocalSubmission();
  }

  @override
  Widget build(BuildContext context) {
    final submissions = context.watch<AppController>().localSubmissions;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Submissions'),
            InkWell(
              onTap: () {
                context.read<AppController>().syncAll();
              },
              child: const Icon(Icons.sync),
            )
          ],
        ),
      ),
      body: submissions.isNotEmpty
          ? ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          final submission = submissions[index];
          return ExpansionTile(
            title: Text(submission.email),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Name: ${submission.name}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Birth Date: ${submission.birthDate}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.work, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Interested Area: ${submission.interestedArea}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.email, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Marketing Updates: ${submission.marketingUpdates}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.mail, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Correspondence: ${submission.correspondence}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Latitude: ${submission.latitude}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Longitude: ${submission.longitude}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Submitted Date: ${submission.submittedDate}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      )
          : const Center(
        child: Text('No submissions yet'),
      ),
    );
  }
}