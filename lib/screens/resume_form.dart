import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/services/api_service.dart';

class ResumeForm extends StatefulWidget {
  final Resume? resume;

  ResumeForm({this.resume});

  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final skillsController = TextEditingController();

  bool isLoading = false;

  List<Map<String, TextEditingController>> educationControllers = [];
  List<Map<String, TextEditingController>> experienceControllers = [];
  List<Map<String, TextEditingController>> projectControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.resume != null) {
      nameController.text = widget.resume!.name;
      emailController.text = widget.resume!.email;
      phoneController.text = widget.resume!.phone;
      skillsController.text = widget.resume!.skills.join(", ");

      for (var edu in widget.resume!.education) {
        educationControllers.add({
          "degree": TextEditingController(text: edu.degree),
          "college": TextEditingController(text: edu.college),
          "year": TextEditingController(text: edu.year),
        });
      }

      for (var exp in widget.resume!.experience) {
        experienceControllers.add({
          "company": TextEditingController(text: exp.company),
          "role": TextEditingController(text: exp.role),
          "duration": TextEditingController(text: exp.duration),
        });
      }

      for (var proj in widget.resume!.projects) {
        projectControllers.add({
          "title": TextEditingController(text: proj.title),
          "description": TextEditingController(text: proj.description),
          "tech": TextEditingController(text: proj.techStack),
        });
      }
    } else {
      addEducation();
      addExperience();
      addProject();
    }
  }

  /// ================= ADD METHODS =================
  void addEducation() {
    setState(() {
      educationControllers.add({
        "degree": TextEditingController(),
        "college": TextEditingController(),
        "year": TextEditingController(),
      });
    });
  }

  void addExperience() {
    setState(() {
      experienceControllers.add({
        "company": TextEditingController(),
        "role": TextEditingController(),
        "duration": TextEditingController(),
      });
    });
  }

  void addProject() {
    setState(() {
      projectControllers.add({
        "title": TextEditingController(),
        "description": TextEditingController(),
        "tech": TextEditingController(),
      });
    });
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resume == null ? "Create Resume" : "Update Resume"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
            ),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),

        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [

              /// 🔥 TOP WARNING BANNER
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Fill all required fields. Resume will NOT be created if any field is empty.",
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// 🔥 BASIC DETAILS
              _buildCard(
                "Basic Details",
                Icons.person,
                [
                  _buildTextField(nameController, "Full Name"),
                  _buildTextField(emailController, "Email"),
                  _buildTextField(phoneController, "Phone"),
                  _buildTextField(
                      skillsController, "Skills (comma separated)"),
                ],
              ),

              /// 🔥 EDUCATION
              _buildDynamicSection(
                title: "Education",
                icon: Icons.school,
                controllers: educationControllers,
                fields: ["degree", "college", "year"],
                labels: ["Degree", "College", "Year"],
                addFunction: addEducation,
              ),

              /// 🔥 EXPERIENCE
              _buildDynamicSection(
                title: "Experience",
                icon: Icons.work,
                controllers: experienceControllers,
                fields: ["company", "role", "duration"],
                labels: ["Company", "Role", "Duration"],
                addFunction: addExperience,
              ),

              /// 🔥 PROJECTS
              _buildDynamicSection(
                title: "Projects",
                icon: Icons.code,
                controllers: projectControllers,
                fields: ["title", "description", "tech"],
                labels: ["Project Title", "Description", "Tech Stack"],
                addFunction: addProject,
              ),

              SizedBox(height: 30),

              /// 🔥 SUBMIT BUTTON
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.resume == null
                            ? "Create Resume"
                            : "Update Resume",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 CARD UI
  Widget _buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 🔥 DYNAMIC SECTION
  Widget _buildDynamicSection({
    required String title,
    required IconData icon,
    required List<Map<String, TextEditingController>> controllers,
    required List<String> fields,
    required List<String> labels,
    required VoidCallback addFunction,
  }) {
    return Column(
      children: [
        _buildCard(
          title,
          icon,
          controllers.map((map) {
            return Column(
              children: List.generate(fields.length, (i) {
                return _buildTextField(map[fields[i]]!, labels[i]);
              }),
            );
          }).toList(),
        ),

        ElevatedButton.icon(
          onPressed: addFunction,
          icon: Icon(Icons.add),
          label: Text("Add $title"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  /// 🔥 TEXT FIELD
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  /// 🔥 SUBMIT
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    List<String> skillsList =
        skillsController.text.split(',').map((e) => e.trim()).toList();

    List<Education> educationList = educationControllers.map((edu) {
      return Education(
        degree: edu["degree"]!.text,
        college: edu["college"]!.text,
        year: edu["year"]!.text,
      );
    }).toList();

    List<Experience> expList = experienceControllers.map((exp) {
      return Experience(
        company: exp["company"]!.text,
        role: exp["role"]!.text,
        duration: exp["duration"]!.text,
      );
    }).toList();

    List<Project> projectList = projectControllers.map((proj) {
      return Project(
        title: proj["title"]!.text,
        description: proj["description"]!.text,
        techStack: proj["tech"]!.text,
      );
    }).toList();

    Resume resume = Resume(
      id: widget.resume?.id,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      skills: skillsList,
      education: educationList,
      projects: projectList,
      experience: expList,
    );

    try {
      if (widget.resume == null) {
        await ApiService().createResume(resume);
      } else {
        await ApiService().updateResume(resume.id!, resume);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved Successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }
}