import 'package:elibrary/navigation_menu.dart';
import 'package:elibrary/pages/authentication/login_user.dart';
import 'package:elibrary/pages/authentication/register_page.dart';
import 'package:elibrary/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../auth/auth.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop;
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/E-Lib.png',
                  scale: 24,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('eLibrary'),
                ),
              ],
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text('Sign in to continue'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Username',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    obscureText: _isObscure,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // onPressed: () {
                    //   Navigator.pushReplacementNamed(context, NavigationMenu.routeName);
                    // },
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      if (username.isNotEmpty || password.isNotEmpty) {
                        final response = await request
                            .login("${baseUrl}authentication/mobile-login/", {
                          'username': username,
                          'password': password,
                        });

                        if (request.loggedIn) {
                          String message = response['message'];
                          String uname = response['username'];
                          int userId = response['user_id'];
                          bool isAdmin = response['is_admin'];
                          CurrUserData.userId = userId;
                          CurrUserData.username = username;
                          CurrUserData.isAdmin = isAdmin;
                          // print(isAdmin);
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                                context, NavigationMenu.routeName);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("$message Welcome, $uname.")));
                          }
                        } else {
                          if (mounted) {
                            _passwordController.clear();
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFFFFDCE0),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Incorrect username or password!",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFFFFDCE0),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "Username or password can't be empty!",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                      }
                    },
                    child: const Text('Sign in'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPage.routeName);
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
