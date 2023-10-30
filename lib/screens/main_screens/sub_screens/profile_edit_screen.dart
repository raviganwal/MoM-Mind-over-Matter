import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';
import 'package:mom/widgets/components/no_network_popup.dart';
import 'package:mom/widgets/loading_error_widgets/please_wait.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class ProfileEditScreen extends StatefulWidget {
  String firstName;
  String lastName;
  String country;
  String gender;
  DateTime dob;

  ProfileEditScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.gender,
    required this.dob,
  });
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  SigninController signinController = Get.put(SigninController());
  FirebaseController firebaseController = Get.put(FirebaseController());
  final hiveController = Get.put(HiveController());
  final _formKey = GlobalKey<FormState>();
  final int _stepCount = 4;
  int _currentStep = 0;
  String _gender = "";
  String _country = "";
  DateTime _dateOfBirth = DateTime.now();
  late User userData;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final List<String> _countries = [
    'Select Country',
    'India',
    'United States',
    'Canada',
    'Mexico',
    'Brazil',
    'Argentina',
    'United Kingdom',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'China',
    'Japan',
    'Australia',
    'New Zealand',
  ];

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (await checkConnectivity()) {
        //User object creatiom
        User userTemp = User(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: "",
            userId: "",
            gender: _gender,
            country: _country,
            dateOfBirth: _dateOfBirth.millisecondsSinceEpoch.toString(),
            proValidity: "",
            enrolledTopic: "",
            activeSprint: "");
        //Update firebase user data and Get back
        Get.dialog(const PleaseWait());
        await firebaseController.updateUserData(userTemp).then((value) async {
          await hiveController.getUserInfoHive();
          //return
          Get.back();
          Fluttertoast.showToast(msg: "User info updated successfully");
        });
        Get.back();
      } else {
        Get.dialog(const NoNetworkPopup());
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  initEditData() {
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
    _gender = widget.gender;
    _country = widget.country;
    _dateOfBirth = widget.dob;
  }

  @override
  void initState() {
    _country = _countries[0];
    initEditData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CustomHeader(title: "Edit"),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Stepper(
                    currentStep: _currentStep,
                    type: StepperType.vertical,
                    onStepContinue: () {
                      setState(() {
                        if (_currentStep < _stepCount - 1) {
                          if (_currentStep == 0) {
                            if (_formKey.currentState!.validate()) {
                              _currentStep++;
                            }
                          } else if (_currentStep == 1) {
                            if (_gender.isNotEmpty) {
                              _currentStep++;
                            } else {
                              Fluttertoast.showToast(msg: "Select your Gender");
                            }
                          } else if (_currentStep == 2) {
                            if (_country != "Select Country") {
                              _currentStep++;
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Select your Country");
                            }
                          }
                        } else {
                          if (_dateOfBirth.isBefore(DateTime.now()
                              .subtract(const Duration(days: 1)))) {
                            _submitForm();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Select your Date of Birth");
                          }
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentStep > 0) {
                          _currentStep--;
                        } else {
                          _currentStep = 0;
                        }
                      });
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _currentStep != 0
                              ? ButtonDesign(
                                  btnText: 'Back',
                                  btnFunction: details.onStepCancel!,
                                )
                              : const SizedBox(),
                          ButtonDesign(
                            btnText: _currentStep == 3 ? 'Submit' : 'Continue',
                            btnFunction: details.onStepContinue!,
                          ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Share some details about you!'),
                        content: Column(
                          children: [
                            MyTextField(
                              controller: _firstNameController,
                              hintText: "first name",
                              iconData: Iconsax.user_tag,
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: _lastNameController,
                              hintText: "last name",
                              iconData: Iconsax.profile_2user,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        isActive: _currentStep == 0,
                        state: _currentStep == 0
                            ? StepState.indexed
                            : StepState.complete,
                      ),
                      Step(
                        title: const Text('How do you identify yourself?'),
                        content: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _gender = 'Male';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: _gender == 'Male'
                                                ? Colors.blue
                                                : Colors.blue.shade100,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.mars,
                                            color: _gender == 'Male'
                                                ? Colors.white
                                                : Colors.blue,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Male',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _gender = 'Female';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: _gender == 'Female'
                                                ? Colors.purple
                                                : Colors.purple.shade100,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.venus,
                                            color: _gender == 'Female'
                                                ? Colors.white
                                                : Colors.purple,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Female',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _gender = 'Others';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: _gender == 'Others'
                                                ? Colors.deepOrange
                                                : Colors.deepOrange.shade100,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.transgender,
                                            color: _gender == 'Others'
                                                ? Colors.white
                                                : Colors.deepOrange,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Others',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        isActive: _currentStep == 1,
                        state: _currentStep <= 1
                            ? StepState.indexed
                            : StepState.complete,
                      ),
                      Step(
                        title: const Text('Where are you from?'),
                        content: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _country,
                                  hint: const Text('Select country'),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _country = newValue!;
                                    });
                                  },
                                  items: _countries
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep == 2,
                        state: _currentStep <= 2
                            ? StepState.indexed
                            : StepState.complete,
                      ),
                      Step(
                        title: const Text('When is your birthday?'),
                        content: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'DoB',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Text(
                                      formatter.format(_dateOfBirth),
                                      // _selectedDate == null
                                      //     ? 'Select your date of birth'
                                      //     : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep == 3,
                        state: _currentStep <= 3
                            ? StepState.indexed
                            : StepState.complete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment
                  .bottomRight, // Align the image to bottom right corner
              margin: const EdgeInsets.only(bottom: 16, right: 16),
              child: Image.asset(
                'assets/images/ui_components/stepper_read.png',
                width: 125,
                // height: 140,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
