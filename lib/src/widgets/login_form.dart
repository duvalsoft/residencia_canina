
// lib/src/widgets/login_form.dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;
  final bool isLoading;

  const LoginForm({Key? key, required this.onSubmit, this.isLoading = false}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController(text: 'http://192.168.1.80:10019');
  final _dbController = TextEditingController(text: 'odoo2');
  final _userController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'admin');

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _serverUrlController.text,
        _dbController.text,
        _userController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _serverUrlController,
            decoration: const InputDecoration(labelText: 'Server URL'),
            validator: (value) => value!.isEmpty ? 'Please enter a server URL' : null,
          ),
          TextFormField(
            controller: _dbController,
            decoration: const InputDecoration(labelText: 'Database'),
            validator: (value) => value!.isEmpty ? 'Please enter a database' : null,
          ),
          TextFormField(
            controller: _userController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
          ),
          const SizedBox(height: 20),
          widget.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Login'),
                ),
        ],
      ),
    );
  }
}
