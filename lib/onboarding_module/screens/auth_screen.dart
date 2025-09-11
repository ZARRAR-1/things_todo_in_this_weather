import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:things_todo_in_this_weather/onboarding_module/custom_widgets_onboarding/custom_text_field.dart';
import 'package:things_todo_in_this_weather/onboarding_module/screens/dashboard.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  _UserAuthPageState createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final Color primaryColor = Colors.white;
  final Color primaryTextColor = Colors.black;
  late double deviceWidth;
  late double deviceHeight;

  final myTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceWidth = MediaQuery.sizeOf(context).width;
    deviceHeight = MediaQuery.sizeOf(context).height;
  }

  Future<void> signIn(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (context.mounted) {
        if (usernameController.text.isEmpty ||
            passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in both username and password.'),
              backgroundColor: Colors.orangeAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (usernameController.text == 'test' &&
            passwordController.text == '1234') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid username or password.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (error) {
      log(error.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $error'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                  'Log in to your account',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: deviceWidth * 0.84, height: deviceHeight * 0.05),
              CustomTextField(
                hintText: 'Username',
                prefixIcon: Icons.perm_identity,
                controller: usernameController,
              ),
              CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                controller: passwordController,
              ),

              SizedBox(width: deviceWidth * 0.84, height: deviceHeight * 0.1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Contact Support@Logicera.com to Register!",
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromRGBO(7, 94, 85, 1),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    onPressed: () => signIn(context),
                    child: Text('LOGIN', style: myTextStyle),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Divider(color: Colors.grey, height: 0),
              ),
              // SizedBox(
              //   width: deviceWidth * 0.84,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[Image.asset('assets/Logo.png')],
              //   ),
              // ),
            ],
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.grey)),
        ],
      ),
    );
  }
}
