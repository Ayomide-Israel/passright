// login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 80,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Welcome Back!👋',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 45),

                      // Email
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.5),
                          ),
                          hintText: 'Username',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Password
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.5),
                          ),
                          hintText: 'Password',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [Text('Remember Me')]),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // login Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            ref.read(navigationProvider.notifier).state =
                                AppScreen.dashboard;
                          },
                          child: Text('Log In', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.black),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Or With",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.grey),
                              padding: EdgeInsets.all(12),
                            ),
                            child: Image.asset(
                              'assets/images/google_icon.png',
                              scale: 25,
                            ),
                          ),
                          SizedBox(width: 1),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.grey),
                              padding: EdgeInsets.all(12),
                            ),
                            child: Image.asset(
                              'assets/images/facebook_blue.png',
                              scale: 33,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 147, 146, 146),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Use navigation provider instead of callback
                                ref.read(navigationProvider.notifier).state =
                                    AppScreen.createAccount;
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 191, 166, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
