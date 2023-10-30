import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mom/screens/auth_screens/signup_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/widgets/components/appbar_design.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  SigninController signinController = Get.put(SigninController());
  FirebaseController firebaseController = Get.put(FirebaseController());
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
    'Singapore',
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
      Get.to(() => SignUpScreen(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            gender: _gender,
            country: _country,
            dateOfBirth: _dateOfBirth.millisecondsSinceEpoch.toString(),
          ));
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

  @override
  void initState() {
    _country = _countries[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CustomHeader(
                title: "Get Started",
                fontSize: 18,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: const Color(0xFF4B3A5A),
                            background: const Color(0xFF4B3A5A),
                            secondary: const Color(0xFF4B3A5A),
                          ),
                    ),
                    child: Stepper(
                      currentStep: _currentStep,
                      type: StepperType.vertical,
                      physics: const NeverScrollableScrollPhysics(),
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
                                Fluttertoast.showToast(
                                    msg: "Select your gender");
                              }
                            } else if (_currentStep == 2) {
                              if (_country != "Select Country") {
                                _currentStep++;
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Select your country");
                              }
                            }
                          } else {
                            if (_dateOfBirth.isBefore(DateTime.now()
                                .subtract(const Duration(days: 4380)))) {
                              _submitForm();
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Select a valid date of birth, above 12 years");
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
                            if (_currentStep != 0) ...[
                              SizedBox(
                                width: 90,
                                child: ButtonDesign(
                                  btnText: 'Back',
                                  paddingValue: 12,
                                  fontSize: 14,
                                  btnFunction: details.onStepCancel!,
                                ),
                              )
                            ],
                            SizedBox(
                              width: 90,
                              child: ButtonDesign(
                                btnText: _currentStep == 3 ? 'Submit' : 'Next',
                                paddingValue: 12,
                                fontSize: 14,
                                btnFunction: details.onStepContinue!,
                              ),
                            ),
                          ],
                        );
                      },
                      steps: [
                        Step(
                          title: Text(
                            'Share some details about you!',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          content: Column(
                            children: [
                              MyTextField(
                                controller: _firstNameController,
                                hintText: "first name",
                                padding: 0,
                                // iconData: Iconsax.user_tag,
                              ),
                              const SizedBox(height: 10),
                              MyTextField(
                                controller: _lastNameController,
                                hintText: "last name",
                                padding: 0,
                                // iconData: Iconsax.profile_2user,
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
                          title: Text(
                            'How do you identify yourself?',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
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
                                                  ? const Color(0xFFBFE7EE)
                                                  : Colors.grey.shade100,
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.mars,
                                              color: _gender == 'Male'
                                                  ? const Color(0xFF33AEFF)
                                                  : Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Male',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: _gender == 'Male'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
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
                                              backgroundColor:
                                                  _gender == 'Female'
                                                      ? const Color(0xFFFFCBD1)
                                                      : Colors.grey.shade100,
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.venus,
                                              color: _gender == 'Female'
                                                  ? const Color(0xFFFF4D80)
                                                  : Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Female',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: _gender == 'Female'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
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
                                              backgroundColor:
                                                  _gender == 'Others'
                                                      ? const Color(0xFFDCF3F2)
                                                      : Colors.grey.shade100,
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.transgender,
                                              color: _gender == 'Others'
                                                  ? const Color(0xFFFF914D)
                                                  : Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Others',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: _gender == 'Others'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
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
                          title: Text(
                            'Where are you from?',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
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
                          title: Text(
                            'When is your birthday?',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
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
                                        //     ? 'Select date of birth'
                                        //     : formatter.format(_selectedDate!),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
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
      ),
      // floatingActionButton: Container(
      //   alignment:
      //       Alignment.bottomRight, // Align the image to bottom right corner
      //   margin: const EdgeInsets.only(bottom: 16, right: 16),
      //   child: Image.asset(
      //     'assets/images/ui_components/stepper_read.png',
      //     width: 130,
      //     height: 140,
      //   ),
      // ),
    );
  }
}
