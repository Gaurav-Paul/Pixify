import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:pixify/features/auth/components/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback togglePage;
  LoginPage({
    super.key,
    required this.togglePage,
  });

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Spacing
            const SizedBox(height: 50),

            // app logo
            SizedBox(
              height: 150,
              width: 150,
              child: Image.network(ConstantValues.appLogoURL,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress != null
                          ? Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!,
                              ),
                            )
                          : child),
            ),

            // Spacing
            const SizedBox(height: 50),

            // welcome text
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),

            // Spacing
            const SizedBox(height: 35),

            Form(
              key: formKey,
              child: Column(
                children: [
                  // Email field

                  AuthTextField(
                    obscureText: false,
                    labelText: "Email",
                    icon: Icons.email,
                    validatorFunction: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(' ') ||
                          !(value.contains('@'))) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password field

                  AuthTextField(
                    obscureText: true,
                    labelText: "Password",
                    icon: Icons.key,
                    validatorFunction: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(' ') ||
                          value.length < 6) {
                        return "Invalid Password";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // submit button

            Card(
              shape: const StadiumBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.amber,
              child: InkWell(
                onTap: () {},
                child: const SizedBox(
                  height: 75,
                  width: 500,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // not a member?
            const SizedBox(
              width: 500,
              child: Row(
                children: [
                  Expanded(child: Divider(endIndent: 15)),
                  Text(
                    "Not a member yet?",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Expanded(child: Divider(indent: 15)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // register now button

            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.amber),
              onPressed: togglePage,
              label: const Text("Register Now"),
              icon: const Icon(Icons.login),
            ),
          ],
        ),
      ),
    );
  }
}
