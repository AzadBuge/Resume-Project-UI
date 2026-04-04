class Resume {
  int? id;
  String name;
  String email;
  String phone;
  String skills;
  String education;
  String experience;

  Resume({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.skills,
    required this.education,
    required this.experience,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "skills": skills,
      "education": education,
      "experience": experience,
    };
  }

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      skills: json['skills'],
      education: json['education'],
      experience: json['experience'],
    );
  }
}