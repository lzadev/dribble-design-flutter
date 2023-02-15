import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/providers/auth_provider.dart';
import 'package:login_app/validations/auth_validation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(
                height: 50,
              ),
              _LoginImageContainer(),
              SizedBox(
                height: 40,
              ),
              Text(
                'Welcome to Saitfy!',
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color.fromRGBO(59, 60, 78, 1),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Keep your data safe!',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(114, 120, 138, 1),
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 50,
              ),
              _LoginForm(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Forgot password?',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromRGBO(133, 39, 243, 1),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 130,
              ),
              Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  children: [
                    TextSpan(
                      text: 'Register!',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(133, 39, 243, 1),
                      ),
                    )
                  ],
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromRGBO(133, 139, 155, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final platform = Theme.of(context).platform;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: authProvider.loginFormKey,
        child: Column(
          children: [
            TextFormField(
              //controller: email,
              onChanged: (value) => authProvider.email = value,
              validator: (value) {
                return AuthValidation.emailValidator(value ?? '')
                    ? null
                    : 'The email is not valid';
              },
              cursorColor: Colors.grey,
              maxLines: 1,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  _inputDecoration('Email', 'example@example.com', false),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              //controller: password,
              onChanged: (value) => authProvider.password = value,
              validator: (value) =>
                  AuthValidation.passwordValidator(value ?? ''),
              cursorColor: Colors.grey,
              maxLines: 1,
              obscureText: true,
              decoration: _inputDecoration('Password', '**********', true),
            ),
            const SizedBox(
              height: 30.0,
            ),
            MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color.fromRGBO(110, 1, 239, 1),
              onPressed: () async {
                if (!authProvider.isValidForm()) return;
                try {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(110, 1, 239, 1),
                        ),
                      );
                    },
                  );
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: authProvider.email,
                    password: authProvider.password,
                  );
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  Navigator.pop(context);

                  if (e.code == "invalid-email") {
                    platform == TargetPlatform.iOS
                        ? _iosDialog(context, 'Invalid email', e.message!)
                        : _androidDialog(context, 'Invalid email', e.message!);
                  } else if (e.code == "user-disabled") {
                    platform == TargetPlatform.iOS
                        ? _iosDialog(context, 'User diabled', e.message!)
                        : _androidDialog(context, 'User diabled', e.message!);
                  } else if (e.code == 'user-not-found') {
                    platform == TargetPlatform.iOS
                        ? _iosDialog(context, 'User not found', e.message!)
                        : _androidDialog(context, 'User not found', e.message!);
                  } else if (e.code == 'wrong-password') {
                    platform == TargetPlatform.iOS
                        ? _iosDialog(context, 'Incorrect password', e.message!)
                        : _androidDialog(
                            context, 'Incorrect password', e.message!);
                  } else if (e.code == "too-many-requests") {
                    platform == TargetPlatform.iOS
                        ? _iosDialog(context, 'User disabled', e.message!)
                        : _androidDialog(context, 'User disabled', e.message!);
                  }
                }
              },
              child: const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _androidDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Color.fromRGBO(110, 1, 239, 1),
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: Color.fromRGBO(110, 1, 239, 1),
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          // content: ,
        );
      },
    );
  }

  Future<dynamic> _iosDialog(
      BuildContext context, String title, String message) {
    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(110, 1, 239, 1),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: Color.fromRGBO(110, 1, 239, 1),
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(
          String labelText, String hintText, bool isForPasswrod) =>
      InputDecoration(
        suffixIcon: isForPasswrod
            ? const Icon(
                Icons.remove_red_eye_rounded,
                color: Color.fromRGBO(115, 45, 201, 1),
              )
            : null,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        fillColor: const Color.fromARGB(255, 241, 241, 241),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ),
      );
}

class _LoginImageContainer extends StatelessWidget {
  const _LoginImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150.0,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Positioned(
                  top: 100,
                  left: 0,
                  child: _Rounded(
                    height: 20,
                    width: 20,
                    radius: 20,
                    color: Color.fromRGBO(237, 223, 254, 1),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _Rounded(
                    height: 15,
                    width: 15,
                    radius: 15,
                    color: Color.fromRGBO(237, 223, 254, 1),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 120,
                  child: _Rounded(
                    height: 30,
                    width: 30,
                    radius: 30,
                    color: Color.fromRGBO(237, 223, 254, 1),
                  ),
                ),
                Icon(
                  Icons.security,
                  color: Color.fromRGBO(115, 45, 201, 1),
                  size: 150.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Rounded extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Color color;
  const _Rounded(
      {Key? key,
      required this.height,
      required this.width,
      required this.radius,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
