import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ticketsystem/screens/admin/admin_dashboard.dart';
import 'package:ticketsystem/screens/employee/employee_dashboard.dart';
import 'signup_screen.dart'; // Import the signup screen (optional)
import 'package:cloud_firestore/cloud_firestore.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Email & Password Login
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate based on user type (Assuming you store role in Firestore)
      User? user = userCredential.user;
      if (user != null) {
        // Fetch user role (admin or employee)
        String role = await _getUserRole(user.uid);

        if (role == "admin") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else if (role == "employee") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EmployeeDashboard()));
        } else {
          setState(() {
            _errorMessage = "User role not found!";
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Sign-In (Optional)
  Future<void> _googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminDashboard())); // Adjust as needed
    } catch (e) {
      setState(() {
        _errorMessage = "Google Sign-In failed: $e";
      });
    }
  }

  // Fetch User Role from Firestore (Assuming role is stored in `users` collection)
  Future<String> _getUserRole(String userId) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc['role'] : 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text("Login"),
                ),
                ElevatedButton(
                  onPressed: _googleSignIn,
                  child: Text("Login with Google"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
