import 'package:flutter/material.dart';
import 'package:resume_generator_project/models/resume_model.dart';
import 'package:resume_generator_project/services/api_service.dart';

class ResumeForm extends StatefulWidget {
  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final skillsController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Resume"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [

                Text(
                  "Fill Your Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),

                SizedBox(height: 20),

                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        _buildTextField(nameController, "Full Name", Icons.person),
                        _buildTextField(emailController, "Email", Icons.email),
                        _buildTextField(phoneController, "Phone", Icons.phone),
                        _buildTextField(skillsController, "Skills", Icons.build),
                        _buildTextField(educationController, "Education", Icons.school),
                        _buildTextField(experienceController, "Experience", Icons.work, maxLines: 3),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25),

                /// 🚀 SUBMIT BUTTON
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Save Resume",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    Resume resume = Resume(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      skills: skillsController.text,
      education: educationController.text,
      experience: experienceController.text,
    );

    try {
      await ApiService().createResume(resume);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resume Created Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    skillsController.dispose();
    educationController.dispose();
    experienceController.dispose();
    super.dispose();
  }
}