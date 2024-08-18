import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/FirebaseAuthCodes.dart';
import 'package:todo_c11/providers/AuthProvider.dart';
import 'package:todo_c11/ui/DialogUtils.dart';
import 'package:todo_c11/ui/ValiationUtils.dart';
import 'package:todo_c11/ui/common/TextFormField.dart';
import 'package:todo_c11/ui/home/HomeScreen.dart';
import 'package:todo_c11/ui/login/LoginScreen.dart';
import 'package:todo_c11/ui/utils.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController passwordConfirmation = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.routeMainColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                ),
                Image.asset(
                  getImagePath('route_logo.png'),
                  width: double.infinity,
                ),
                AppFormField(
                  title: "Full Name",
                  hint: 'please enter Full Name',
                  keyboardType: TextInputType.name,
                  validator: (text) {
                    if (text?.trim().isEmpty == true) {
                      return "Please enter full name";
                    }
                    if ((text?.length ?? 0) < 6) {
                      return "Full Name at least 6 chars";
                    }
                    return null;
                  },
                  controller: fullName,
                ),
                AppFormField(
                  title: "Email Address",
                  hint: 'please enter Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text?.trim().isEmpty == true) {
                      return "Please enter your email";
                    }
                    if (!isValidEmail(text!)) {
                      return "please enter valid email";
                    }

                    return null;
                  },
                  controller: email,
                ),
                AppFormField(
                  title: "Password",
                  hint: 'please enter Password',
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) {
                    if (text?.trim().isEmpty == true) {
                      return "Please enter your password";
                    }
                    if (!isValidPassword(text!)) {
                      return "password at least 6 chars";
                    }

                    return null;
                  },
                  controller: password,
                ),
                AppFormField(
                  title: "Password Confirmation",
                  hint: 'please enter Password Comfirmation',
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) {
                    if (text?.trim().isEmpty == true) {
                      return "Please enter your password";
                    }
                    // if passowrd confirmation is matching
                    //  password field
                    if (password.text != text) {
                      return "Password Doen't Match";
                    }
                    return null;
                  },
                  controller: passwordConfirmation,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.routeMainColor),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have account? ',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(
                          "Sign in",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    // validate form

    if (formKey.currentState?.validate() == false) {
      return;
    }
    createAccount();
  }

  void createAccount() async {
    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    try {
      showLoadingDialog(context, message: 'please wait...');
      final appUser = await authProvider.createUserWithEmailAndPassword(
          email.text, password.text, fullName.text);
      hideLoading(context);

      if (appUser == null) {
        showMessageDialog(context,
            message: "Something went wrong",
            posButtonTitle: 'try again', posButtonAction: () {
          createAccount();
        });
        return;
      }

      showMessageDialog(context,
          message: "User created successfully",
          posButtonTitle: 'ok', posButtonAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      String message = 'Something went Wrong';

      if (e.code == FirebaseAuthCodes.WEAK_PASSWORD) {
        message = 'The password provided is too weak.';
      } else if (e.code == FirebaseAuthCodes.EMAIL_IN_USE) {
        message = 'The account already exists for that email.';
      }
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: "ok");
    } catch (e) {
      String message = 'Something went Wrong';
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: "try again",
          posButtonAction: () {
        register();
      });
    }
  }
}
