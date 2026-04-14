import 'package:flutter/material.dart';
import 'package:resume_generator_project/screens/resume_form.dart';
import 'package:resume_generator_project/screens/resume_view.dart';
import 'package:resume_generator_project/widgets/sparkle_animation.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  /// 🔥 APP BAR (CUSTOM)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.description, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Resume Generator",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔥 HERO SECTION
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),

                      child: Column(
                        children: [
                          SizedBox(height: 20),

                          /// 🎯 HERO CARD
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade700,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: width < 400 ? 40 : 60,
                                    color: Colors.white,
                                  ),

                                  SizedBox(height: 10),

                                  Text(
                                    "Build Stunning Resumes",
                                    style: TextStyle(
                                      fontSize: width < 400 ? 18 : 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    "Create, customize and download professional resumes in seconds.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white70),
                                  ),

                                  SizedBox(height: 20),

                                  /// 🚀 CREATE BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ResumeForm(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text("Create Resume"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 📊 STATS / FEATURES ROW
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniCard(Icons.edit, "Easy Edit"),
                                _buildMiniCard(Icons.download, "Download"),
                                _buildMiniCard(Icons.star, "Professional"),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 📄 HEADER
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Your Resumes",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.list, color: Colors.grey),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          /// 👁 VIEW BUTTON
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResumeView(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.visibility),
                              label: Text("View All Resumes"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 💡 TIP CARD
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Create resume within 2 minutes..!",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Build Impressive resume with only adding the Skills..!",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Download the Resume For Free..!",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "DOCX feature Comming Soon..!",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),

                          /// 🔥 fills remaining space
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 160,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                    child: SparkleAnimation(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 MINI FEATURE CARD
  Widget _buildMiniCard(IconData icon, String text) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(height: 6),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
