import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/services/api_service.dart';
import 'package:resume_generator_project/widgets/resume_widget.dart';
import 'package:resume_generator_project/widgets/resume_template.dart';
class ResumeView extends StatefulWidget {
  @override
  _ResumeViewState createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  late Future<List<Resume>> resumes;

  @override
  void initState() {
    super.initState();
    resumes = ApiService().getResumes();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Resume Template")),
    body: FutureBuilder<List<Resume>>(
      future: resumes,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No Data Found"));
        }

        var data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final resume = data[index];

            return ResumeTemplate(resume: resume);
          },
        );
      },
    ),
  );
}
}