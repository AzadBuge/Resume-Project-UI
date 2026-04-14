class Education {
  String degree;
  String college;
  String year;

  Education({required this.degree, required this.college, required this.year});

  Map<String, dynamic> toJson() => {
    "degree": degree,
    "college": college,
    "year": year,
  };

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      college: json['college'],
      year: json['year'],
    );
  }
}

class Experience {
  String company;
  String role;
  String duration;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
    "company": company,
    "role": role,
    "duration": duration,
  };

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'],
      role: json['role'],
      duration: json['duration'],
    );
  }
}

class Resume {
  int? id;
  String name;
  String email;
  String phone;
  List<String> skills;
  List<Education> education;
  List<Project> projects;
  List<Experience> experience;

  Resume({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.skills,
    required this.education,
    required this.projects,
    required this.experience,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "skills": skills,
    "education": education.map((e) => e.toJson()).toList(),
    "projects" : projects.map((e)=>e.toJson()).toList(),
    "experience": experience.map((e) => e.toJson()).toList(),
  };

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      skills: List<String>.from(json['skills']),
      education: (json['education'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
      projects: (json['projects'] as List)
          .map((e) => Project.fromJson(e))
          .toList(),
      experience: (json['experience'] as List)
          .map((e) => Experience.fromJson(e))
          .toList(),
    );
  }
}

class Project {
  String title;
  String description;
  String techStack;

  Project({
    required this.title,
    required this.description,
    required this.techStack,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "techStack": techStack,
  };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      techStack: json['techStack'],
    );
  }
}
