class User {
  static String id = " ";
  static String employeeId = " ";
  static String firstName = " ";
  static String lastName = " ";
  static String birthDate = " ";
  static String address = " ";
  static String profilePicLink = " ";
  static double lat = 0;
  static double long = 0;
  static bool canEdit = true;
  static String checkIn = "--/--";
  static String checkOut = "--/--";
  static String WorkType=" ";
  static const String nameKey = "user_name";
  static const String arrayKey = "user_array";

  String ? name;
  List? array;
  User({this.name, this.array});
  factory User.fromJson(Map<dynamic, dynamic> json) => User(
    name: json[nameKey],
    array: json[arrayKey],
  );

  Map<String, dynamic> toJson() => {
    nameKey: firstName,
    arrayKey: array,
  };
}