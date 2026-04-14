import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/screens/resume_form.dart';
import 'package:resume_generator_project/services/api_service.dart';
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
    fetchResumes();
  }

  void fetchResumes() {
    resumes = ApiService().getResumes();
  }

  Future<void> refreshData() async {
    setState(() {
      fetchResumes();
    });
  }

  /// 🔥 DELETE FUNCTION
  Future<void> deleteResume(int id) async {
    try {
      await ApiService().deleteResume(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Resume deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      refreshData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting resume"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 🔥 CONFIRM DELETE
  Future<bool> confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Delete Resume"),
            content: Text("Are you sure you want to delete this resume?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔥 PREMIUM APPBAR
      appBar: AppBar(
        title: Text("Your Resumes"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
            ),
          ),
        ),
      ),

      /// 🔥 BACKGROUND
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: RefreshIndicator(
          onRefresh: refreshData,

          child: FutureBuilder<List<Resume>>(
            future: resumes,
            builder: (context, snapshot) {

              /// ⏳ LOADING
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              /// ❌ ERROR
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              /// 📭 EMPTY
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "No Resumes Found",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              final data = snapshot.data!;

              return ListView.builder(
                itemCount: data.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final resume = data[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),

                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [

                          /// 🔥 RESUME TEMPLATE
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: ResumeTemplate(resume: resume),
                          ),

                          /// 🔥 ACTION BAR
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [

                                /// ✏️ EDIT
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    bool? updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ResumeForm(resume: resume),
                                      ),
                                    );

                                    if (updated == true) {
                                      refreshData();
                                    }
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text("Edit"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                /// ❌ DELETE
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    bool confirm = await confirmDelete();
                                    if (confirm) {
                                      deleteResume(resume.id!);
                                    }
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}