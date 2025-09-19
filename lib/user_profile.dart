class UserProfile {
  String name;
  String email;
  String password;
  String gender;
  DateTime? dateOfBirth;
  String occupation;
  String education;
  String city;
  String bio;
  String? profilePicturePath;

  // Religious and other details
  String religion;
  String caste;
  String subCaste;
  bool willingToMarryOutsideCaste; // New field for the checkbox
  String income;
  String familyType;
  String maritalStatus;
  String height;
  String complexion;

  UserProfile({
    this.name = '',
    this.email = '',
    this.password = '',
    this.gender = 'Male',
    this.dateOfBirth,
    this.occupation = '',
    this.education = '',
    this.city = '',
    this.bio = '',
    this.profilePicturePath,
    this.religion = '',
    this.caste = '',
    this.subCaste = '',
    this.willingToMarryOutsideCaste = false,
    this.income = 'Up to ₹2 Lakh',
    this.familyType = 'Joint Family',
    this.maritalStatus = 'Never Married',
    this.height = '',
    this.complexion = '',
  });

  // Method to convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'occupation': occupation,
      'education': education,
      'city': city,
      'bio': bio,
      'profile_picture_path': profilePicturePath,
      'religion': religion,
      'caste': caste,
      'sub_caste': subCaste,
      'willing_to_marry_outside_caste': willingToMarryOutsideCaste,
      'income': income,
      'family_type': familyType,
      'marital_status': maritalStatus,
      'height': height,
      'complexion': complexion,
    };
  }
}