import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //change password
  Future<void> changePassword(String newPassword, context) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the password
        await user.updatePassword(newPassword);
        passwordController.clear();
        showSnackBar(
            context: context,
            message: 'Password changed ',
            icon: Icon(Icons.check));
        print('Password changed successfully');
      } else {
        print('No user signed in');
        showSnackBar(
            context: context,
            message: 'No user signed in ',
            icon: Icon(Icons.warning));
      }
    } catch (e) {
      print('Error changing password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Change Password'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  labelText: 'New Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'imvalid input';
                    } else if (val.length < 6) {
                      return 'password must be 6 digits';
                    }
                    return null;
                  }),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await changePassword(passwordController.text, context);
                    }
                  },
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
