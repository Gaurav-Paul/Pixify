import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:pixify/features/auth/components/auth_text_field.dart';
import 'package:pixify/features/auth/user_info_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback togglePage;
  const RegisterPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  goToUserInfoPage() async {
    if (!(formKey.currentState!.validate()) ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        passwordController.text != confirmPasswordController.text) {
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserInfoPage(
            email: emailController.text, password: passwordController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                "Become a Member Today!",
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
                      controller: emailController,
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
                      controller: passwordController,
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

                    const SizedBox(height: 15),

                    // Confirm Password field

                    AuthTextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      labelText: "Confirm Password",
                      icon: Icons.password,
                      validatorFunction: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.contains(' ') ||
                            value.length < 6) {
                          return "Invalid Password";
                        }
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          return "Passwords don't match";
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
                  splashColor: Colors.white38,
                  onTap: goToUserInfoPage,
                  child: const SizedBox(
                    height: 75,
                    width: 500,
                    child: Center(
                      child: Text(
                        "Continue",
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
                      "Already a member?",
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
                onPressed: widget.togglePage,
                label: const Text("Login Now"),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
