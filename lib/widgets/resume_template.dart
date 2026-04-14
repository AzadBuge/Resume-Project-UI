import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:http/http.dart' as http;

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:docx_template/docx_template.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> generateSummary(Resume resume) async {
  const apiKey = "AIzaSyDwrR4Wa_w0qa2wrse7O6iw85PLMO-ISjk";

  final prompt =
      """
Create a 4-line ATS-friendly resume summary.

Rules:
- 4 short lines only
- professional tone
- highlight skills, experience, projects
- no repetition

DATA:
Name: ${resume.name}
Skills: ${resume.skills.join(", ")}
Projects: ${resume.projects.map((p) => p.title).join(", ")}
Experience: ${resume.experience.map((e) => "${e.role} at ${e.company}").join(", ")}
""";

  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data["candidates"][0]["content"]["parts"][0]["text"]
        .toString()
        .trim();
  }
  if (response.statusCode != 200) {
    print("OPENAI ERROR CODE: ${response.statusCode}");
    print("OPENAI RESPONSE: ${response.body}");
  }

  String skills = resume.skills.take(5).join(", ");
  String projects = resume.projects.isNotEmpty
      ? resume.projects.take(2).map((p) => p.title).join(" and ")
      : "various projects";
  String roles = resume.experience.isNotEmpty
      ? resume.experience.map((e) => e.role).toSet().join(", ")
      : "software development";
  String experienceLine = resume.experience.isNotEmpty
      ? "with hands-on experience as $roles"
      : "with strong academic and project experience";
  return "Enthusiastic and detail-oriented professional $experienceLine, "
      "skilled in $skills etc. \n"
      "Experienced in building projects such as $projects and more, showcasing problem-solving and development abilities. \n"
      "Strong understanding of modern technologies with a focus on writing clean, efficient, and scalable code. \n"
      "Passionate about continuous learning, innovation, and contributing effectively to team success.";
}

/// ================= PDF GENERATION =================
Future<void> downloadResumePDF(Resume resume) async {
  final pdf = pw.Document();
  final summary = await generateSummary(resume);

  /// 🔥 AI GENERATED SUMMARY (MAX 3 LINES

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.all(24),
      build: (context) {
        return pw.Container(
          height: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              // 🔥 PAGE BORDER
              color: PdfColors.grey600,
              width: 1,
            ),
          ),
          padding: pw.EdgeInsets.all(16),

          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// 🔝 HEADER
              pw.Text(
                resume.name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                "${resume.email} | ${resume.phone}",
                style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
              ),

              pw.SizedBox(height: 6),
              dividerLine(),

              /// 🔥 EXPAND EVERYTHING BELOW (KEY FIX)
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    /// 🔥 SUMMARY
                    sectionBlock(
                      "SUMMARY",
                      pw.Text(summary, style: pw.TextStyle(fontSize: 11)),
                    ),

                    /// 🔥 SKILLS
                    sectionBlock(
                      "SKILLS",
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: _chunkList(resume.skills, 3).map((row) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: row.map((skill) {
                                return pw.Container(
                                  margin: const pw.EdgeInsets.only(right: 6),
                                  padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey400,
                                    ),
                                    borderRadius: pw.BorderRadius.circular(4),
                                  ),
                                  child: pw.Text(
                                    skill,
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// 🔥 EDUCATION
                    sectionBlock(
                      "EDUCATION",
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: resume.education.map((edu) {
                          return pw.Padding(
                            padding: pw.EdgeInsets.only(bottom: 2),
                            child: pw.Text(
                              "${edu.degree} \n\t\t-> ${edu.college} (${edu.year})",
                              style: pw.TextStyle(fontSize: 11),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// 🔥 PROJECTS
                    sectionBlock(
                      "PROJECTS",
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: resume.projects.map((proj) {
                          return pw.Padding(
                            padding: pw.EdgeInsets.only(bottom: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  proj.title,
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 1),
                                pw.Text(
                                  proj.description,
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 1),
                                pw.Text(
                                  "Tech: ${proj.techStack}",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontStyle: pw.FontStyle.italic,
                                    color: PdfColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// 🔥 EXPERIENCE
                    sectionBlock(
                      "EXPERIENCE",
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: resume.experience.map((exp) {
                          return pw.Padding(
                            padding: pw.EdgeInsets.only(bottom: 3),
                            child: pw.Text(
                              "${exp.role} at ${exp.company} (${exp.duration})",
                              style: pw.TextStyle(fontSize: 11),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: "${resume.name}_resume.pdf",
  );
}

List<List<T>> _chunkList<T>(List<T> list, int size) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += size) {
    chunks.add(
      list.sublist(i, i + size > list.length ? list.length : i + size),
    );
  }
  return chunks;
}

pw.Widget dividerLine() {
  return pw.Container(
    margin: pw.EdgeInsets.symmetric(vertical: 6),
    height: 1,
    color: PdfColors.grey300,
  );
}

pw.Widget richTitle(String title) {
  return pw.Container(
    margin: pw.EdgeInsets.only(top: 6, bottom: 4),
    padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: pw.BoxDecoration(
      color: PdfColors.blueGrey100,
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        letterSpacing: 1.2,
        color: PdfColors.blueGrey900,
      ),
    ),
  );
}

pw.Widget sectionBlock(String title, pw.Widget content) {
  return pw.Expanded(
    flex: 1,
    child: pw.Container(
      margin: pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          richTitle(title),

          /// 🔥 ADD THIS LINE (divider under heading)
          pw.Container(
            margin: pw.EdgeInsets.symmetric(vertical: 3),
            height: 0.8,
            color: PdfColors.grey400,
          ),

          content,
        ],
      ),
    ),
  );
}

pw.Widget pdfSectionTitle(String title) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 6, top: 10),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  );
}

/// PDF Section Title
pw.Widget sectionTitle(String title) {
  return pw.Text(
    title,
    style: pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey800,
    ),
  );
}

/// ================= UI TEMPLATE =================
class ResumeTemplate extends StatelessWidget {
  final Resume resume;

  const ResumeTemplate({required this.resume});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          /// LEFT SIDE PANEL
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
                /// NAME
                Text(
                  resume.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),

                SizedBox(height: 10),

                /// CONTACT
                sectionTitle("Contact"),
                Text("Email: ${resume.email}"),
                SizedBox(height: 5),
                Text("Phone: ${resume.phone}"),

                SizedBox(height: 15),

                /// SKILLS
                sectionTitle("Skills"),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: resume.skills.map((skill) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(skill, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE CONTENT
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// EDUCATION
                  sectionTitle("Education"),
                  ...resume.education.map(
                    (edu) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "${edu.degree} - ${edu.college} (${edu.year})",
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  /// EXPERIENCE
                  sectionTitle("Experience"),
                  ...resume.experience.map(
                    (exp) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "${exp.role} at ${exp.company} (${exp.duration})",
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  /// 🔥 PROJECTS (ADDED)
                  sectionTitle("Projects"),
                  ...resume.projects.map(
                    (proj) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(proj.description),
                          Text(
                            "Tech: ${proj.techStack}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// DOWNLOAD BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// 📄 PDF
                        ElevatedButton.icon(
                          onPressed: () => downloadResumePDF(resume),
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text("PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),

                        SizedBox(width: 10),

                        /// 📄 DOCX
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Coming Soon 🚀"),
                                  content: Text(
                                    "DOCX download feature is currently under development.\nPlease use PDF for now.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.description),
                          label: Text("DOCX (Coming Soon)"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
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

  /// SECTION TITLE
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
