import 'package:flutter/material.dart';
import 'package:attendanceapp/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendanceapp/services/location_service.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendanceapp/face_recognition/camera_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final firstNameTextEditController = new TextEditingController();
  final addressController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();
  late SharedPreferences sharedPreferences;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  String location=" ";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        User.long = value!;
      });
      LocationService().getLatitude().then((value) {
        setState(() {
          User.lat = value!;
        });
      }).then((_) => _getLocation());
    });
    // _getLocation();
  }
  void _getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long);

    setState(() {
      location = "${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    });
    addressController.text=location;
  }
  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 36.0, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '$_errorMessage',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                      controller: emailTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_firstNameFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name.';
                        }
                        return null;
                      },
                      controller: firstNameTextEditController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      focusNode: _firstNameFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_lastNameFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please check if this is your office address';
                        }
                        return null;
                      },
                      controller: addressController,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      focusNode: _lastNameFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Address',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be longer than 8 characters.';
                        }
                        return null;
                      },
                      autofocus: false,
                      obscureText: true,
                      controller: passwordTextEditController,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: confirmPasswordTextEditController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (passwordTextEditController.text.length > 8 &&
                            passwordTextEditController.text != value) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen, // background (button) color
                        foregroundColor: Colors.white, // foreground (text) color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _firebaseAuth
                              .createUserWithEmailAndPassword(
                              email: emailTextEditController.text,
                              password: passwordTextEditController.text)
                              .then((onValue) {
                            FirebaseFirestore.instance
                                .collection('Employee')
                                .doc(onValue.user!.uid)
                                .set({
                              'id':emailTextEditController.text,
                              'password': passwordTextEditController.text,
                              'firstName': firstNameTextEditController.text,
                              'lastName':"",
                              'WorkType':"in-office",
                              'address': location,
                              'lat': User.lat,
                              'lon': User.long
                            }).then((userInfoValue) async{
                              sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString('employeeId', emailTextEditController.text).then((_) {
                                User.employeeId=emailTextEditController.text;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FaceScanScreen()
                                    )
                                );
                              });
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(builder: (context) => LoginScreen())
                              // );
                              // Navigator.of(context).pushNamed(LoginScreen);
                            });
                          }).catchError((onError) {
                            processError(onError);
                          });
                        }
                      },
                      child: Text('Sign Up'.toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black54),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                ],
              ))),
    );
  }
}