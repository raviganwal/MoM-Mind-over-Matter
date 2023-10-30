import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mom/screens/auth_screens/welcome_screen.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';

class ProfileInfoScreen extends StatefulWidget {
  // String email;
  // String password;

  // ProfileInfoScreen({
  //   // required this.email,
  //   // required this.password,
  // });
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  SigninController signinController = Get.put(SigninController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  int _selectedGender = 0;

  String _selectedCountry = "India";

  final List<String> _countries = [
    'India',
    'USA',
    'UK',
    'Germany',
    'France',
    'Canada',
    'China',
  ];

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String getGender(int genderIndex) {
    switch (genderIndex) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Scaffold(
      backgroundColor: const Color(0xFF8E93CD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Personal information',
                  style: TextStyle(fontSize: 26.0, fontFamily: 'Source Sans Pro', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 15.0),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTextField(
                        controller: _firstNameController,
                        hintText: "first name",
                        iconData: Iconsax.user_tag,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: _lastNameController,
                        hintText: "last name",
                        iconData: Iconsax.profile_2user,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
                GenderButton(
                  label: 'Male',
                  color: Colors.blue,
                  selected: _selectedGender == 0,
                  onTap: () {
                    setState(() {
                      _selectedGender = 0;
                    });
                  },
                ),
                const SizedBox(height: 10),
                GenderButton(
                  label: 'Female',
                  color: Colors.pink,
                  selected: _selectedGender == 1,
                  onTap: () {
                    setState(() {
                      _selectedGender = 1;
                    });
                  },
                ),
                const SizedBox(height: 10),
                GenderButton(
                  label: 'Others',
                  color: Colors.green,
                  selected: _selectedGender == 2,
                  onTap: () {
                    setState(() {
                      _selectedGender = 2;
                    });
                  },
                ),

                const SizedBox(height: 15.0),
                const Text(
                  'Country',
                  style: TextStyle(fontSize: 25.0, fontFamily: 'Source Sans Pro'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountry,
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
                          _selectedCountry = newValue!;
                        });
                      },
                      items: _countries.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25.0,
                ),
                const Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 25.0, fontFamily: 'Source Sans Pro'),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          formatter.format(_selectedDate),
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
                const SizedBox(height: 30),
                ButtonDesign(
                  btnText: "Let's Start",
                  bgColor: const Color(0xFFFEB150),
                  txtColor: Colors.black,
                  btnFunction: () async {
                    if (_formKey.currentState!.validate()) {
                      final userData = User(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          email: firebaseAuth.currentUser!.email!,
                          userId: firebaseAuth.currentUser!.uid,
                          gender: getGender(_selectedGender),
                          country: _selectedCountry,
                          dateOfBirth: _selectedDate.millisecondsSinceEpoch.toString(),
                          proValidity: "",
                          enrolledTopic: "1",
                          activeSprint: "1");
                      Get.to(() => WelcomeScreen());
                    }
                    //Navigate to welcome screen
                  },
                ),
                const SizedBox(height: 30)
                // ElevatedButton(
                //   onPressed: () {
                //     // onProceedPressed();
                //     //if (_formKey.currentState!.validate()) {}
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFFFFAF21),
                //     padding: const EdgeInsets.fromLTRB(90, 15, 90, 15),
                //     side: const BorderSide(width: 5.0, color: Colors.black),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                //   ),
                //   child: const Text(
                //     'Lets Start',
                //     style: TextStyle(
                //       fontSize: 25.0,
                //       fontFamily: "Pacifico",
                //       //fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final Function onTap;

  GenderButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
