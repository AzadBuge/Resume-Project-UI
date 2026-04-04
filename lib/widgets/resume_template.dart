import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';

import 'package:http/http.dart' as http;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> downloadResumePDF(Resume resume) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    resume.name ?? "No Name",
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    "Email: ${resume.email ?? ""}   |   Phone: ${resume.phone ?? ""}",
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            pw.Divider(height: 20, thickness: 1),

            sectionPDFTitle("Skills"),
            pw.Bullet(text: (resume.skills ?? "")),
            pw.SizedBox(height: 12),

            sectionPDFTitle("Education"),
            pw.Text(
              resume.education ?? "Not provided",
              style: pw.TextStyle(fontSize: 12),
            ),

            pw.SizedBox(height: 12),

            sectionPDFTitle("Experience"),
            pw.Text(
              resume.experience ?? "Not provided",
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: "${resume.name}_resume.pdf",
  );
}

pw.Widget sectionPDFTitle(String title) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

class ResumeTemplate extends StatelessWidget {
  final Resume resume;

  ResumeTemplate({required this.resume});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  resume.name ?? "No Name",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),

                SizedBox(height: 10),

                sectionTitle("Contact"),
                Text("Email: ${resume.email ?? ""}"),
                SizedBox(height: 5),
                Text("Phone: ${resume.phone ?? ""}"),

                SizedBox(height: 15),

                sectionTitle("Skills"),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (resume.skills ?? "")
                      .split(',')
                      .map((skill) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skill.trim(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  
                  sectionTitle("Education"),
                  Text(
                    resume.education ?? "Not provided",
                    style: TextStyle(fontSize: 14),
                  ),

                  SizedBox(height: 15),

                  sectionTitle("Experience"),
                  Text(
                    resume.experience ?? "Not provided",
                    style: TextStyle(fontSize: 14),
                  ),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        downloadResumePDF(resume);
                      },
                      icon: Icon(Icons.download),
                      label: Text("Download PDF"),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                    ),
                  ),
                  SizedBox(width: 10),
                    Align(
                    alignment: Alignment.centerLeft,
                    child:
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
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

                      if (confirm) {
                        final response = await http.delete(
                          Uri.parse("http://localhost:8080/api/resume/${resume.id}"),
                        );

                        if (response.statusCode == 200 || response.statusCode == 204) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Resume deleted successfully")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to delete resume")),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}