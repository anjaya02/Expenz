import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // Method to store the UserName and UserEmail in shared preferences
  static Future<void> storeUserDetails({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      if (password != confirmPassword) {
        // Show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password and Confirm Password do not match"),
          ),
        );
        return;
      }

      // Create a shared preference instance
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store the userName and email as key-value pairs
      await prefs.setString("userName", userName);
      await prefs.setString("email", email);

      // Show a message to the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User name and Email are stored successfully"),
          ),
        );
      }
    } catch (err) {
      // Handle the error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occurred: ${err.toString()}"),
          ),
        );
      }
    }
  }
  // method to check whether the username is saved in shared preferences

  static Future<bool> checkUserName() async {
    // create an instance for shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // going to pref to check if the username is saved

    String? userName = prefs.getString('userName');
    return userName != null;
  }

// get the userName and the email
  static Future<Map<String, String>> getUserData() async {
    // create an instance for shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userName = pref.getString('userName');
    String? email = pref.getString('email');
    return {'username': userName!, 'email': email!};
  }

  //remove the username and email from shared preferences
  static Future<void> clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
  }
}
