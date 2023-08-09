import 'package:flutter/material.dart';

class SessionManagementScreen extends StatefulWidget {
  @override
  _SessionManagementScreenState createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  List<Map<String, String>> _users = [];

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Map<String, String>? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
  }

  void _initializeUsers() {
    // Initialize some dummy user data (email and password pairs)
    _users = [
      {'email': 'user1@example.com', 'password': 'password1'},
      {'email': 'user2@example.com', 'password': 'password2'},
      // Add more users as needed
    ];
  }

  void _createAccount() {
    String email = _emailController.text;
    String password = _passwordController.text;

    _users.add({'email': email, 'password': password});

    _emailController.clear();
    _passwordController.clear();

    _signIn(email, password);
  }

  void _signIn(String email, String password) {
    for (var user in _users) {
      if (user['email'] == email && user['password'] == password) {
        setState(() {
          _currentUser = user;
        });
        break;
      }
    }
  }

  void _signOut() {
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Management Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentUser == null)
              Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _createAccount,
                    child: Text('Create Account'),
                  ),
                  ElevatedButton(
                    onPressed: () => _signIn(
                        _emailController.text, _passwordController.text),
                    child: Text('Sign In'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text('You are logged in as ${_currentUser!['email']}!'),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: SessionManagementScreen()));
