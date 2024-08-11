import 'package:employee_mobile/components/my_elevated_button.dart';
import 'package:employee_mobile/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopify_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 24),
              Text(
                'Employee Mobile',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_open),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<LoginViewModel>(
                builder: (context, loginViewModel, child) {
                  return loginViewModel.isLoading
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: MyElevatedButton(
                              onPressed: () async {
                                final username =
                                    _usernameController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                if (username.isEmpty && password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter your Username and Password.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                } else if (username.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter your Username.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                } else if (password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter your Password.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final success = await loginViewModel.login(
                                  username,
                                  password,
                                );

                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Login failed.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Login'),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
