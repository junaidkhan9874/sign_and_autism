class Users {
  String? age;
  String? firstName;
  String? lastName;
  String? gender;
  String? guardianName;
  String? phoneNumber;
  String? relationWith;

  Users({this.age, this.firstName, this.lastName, this.gender, this.guardianName, this.phoneNumber, this.relationWith});

  Users.fromJson(Map<String,dynamic> json){
    age = json["age"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    gender = json["gender"];
    guardianName = json["guardianName"];
    phoneNumber = json["phoneNumber"];
    relationWith = json["relationWith"];
  }
}
