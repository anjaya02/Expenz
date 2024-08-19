import 'package:expenz/constants/colors.dart';
import 'package:expenz/constants/constants.dart';
import 'package:expenz/screens/main_screen.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserdataScreen extends StatefulWidget {
  const UserdataScreen({super.key});

  @override
  State<UserdataScreen> createState() => _UserdataScreenState();
}

class _UserdataScreenState extends State<UserdataScreen> {
  // for the checkbox
  bool _rememberMe = false;

  // form key for the form validations

  final _formKey = GlobalKey<FormState>();
  // controller for the text form fields

  // for store data?

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your \npersonal details",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Field for the userName
                      TextFormField(
                        controller: _userNameController,

                        // validator actives when a key is assigned to formKey
                        validator: (value) {
                          // check whether the user entered a valid userName
                          if (value!.isEmpty) {
                            return "Please enter your Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: const EdgeInsets.all(20)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Form Field for the userName
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your Email";
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: const EdgeInsets.all(20)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Form Field for the password

                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a valid Password";
                          }
                          return null;
                        },
                        controller: _passwordController,

                        // obsecure hides the password

                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: const EdgeInsets.all(20)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please confirm your Password";
                          }
                          return null;
                        },
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Confirm Passowrd",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: const EdgeInsets.all(20)),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      // remember me for the next time
                      Row(
                        children: [
                          const Text(
                            "Remember me for the next time",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: kGrey),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: kMainColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _rememberMe = value!;
                                  },
                                );
                              },
                            ),
                          ),
                          // submit button
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            String userName = _userNameController.text;
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            String confirmPassword =
                                _confirmPasswordController.text;

                            // below line

                            if (password == confirmPassword) {
                              // Save the userName and email in device storage
                              await UserServices.storeUserDetails(
                                userName: userName,
                                email: email,
                                password: password,
                                confirmPassword: confirmPassword,
                                context: context,
                              );

                              // Navigate to the main screen
                              //here below
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MainScreen();
                                    },
                                  ),
                                );
                              }
                              //here above
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Password and Confirm Password do not match"),
                                ),
                              );
                            }
                          }
                        },
                        child: const CustomButton(
                            buttonName: "Next", buttonColor: kMainColor),
                      ),
                    ],
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
