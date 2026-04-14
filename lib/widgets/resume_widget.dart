import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/services/api_service.dart';

class ResumeCard extends StatelessWidget {
  final Resume resume;
  final VoidCallback onDelete; // 🔥 callback for refresh

  const ResumeCard({
    required this.resume,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),

        title: Text(
          resume.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(resume.email),

        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),

          onPressed: () async {
            /// 🔥 CONFIRMATION DIALOG
            bool confirm = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Delete Resume"),
                content: Text("Are you sure you want to delete this resume?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Delete"),
                  ),
                ],
              ),
            );

            if (confirm != true) return;

            try {
              await ApiService().deleteResume(resume.id!);

              /// ✅ SUCCESS FEEDBACK
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Resume deleted successfully")),
              );

              /// 🔄 REFRESH LIST
              onDelete();

            } catch (e) {
              /// ❌ ERROR FEEDBACK
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error deleting resume")),
              );
            }
          },
        ),
      ),
    );
  }
}