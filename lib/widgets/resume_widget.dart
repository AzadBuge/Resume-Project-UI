import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/services/api_service.dart';
import 'package:resume_generator_project/widgets/resume_widget.dart';


class ResumeCard extends StatelessWidget {
  final Resume resume;

  const ResumeCard({required this.resume});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(resume.name),
        subtitle: Text(resume.email),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await ApiService().deleteResume(resume.id!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text("Refreshing...")))),
            );
          },
        ),
      ),
    );
  }
}