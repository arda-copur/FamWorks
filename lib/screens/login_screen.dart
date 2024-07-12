import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

 final Color bgColor = const Color(0xFF1C2341);
 final Color containerColor =  const Color(0xFF272D4A);
 final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(
                'Tekrar Hoşgeldiniz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: white),
              ),
               const SizedBox(height: 8),
              const Text('Giriş yapmak için tıklayın',style: TextStyle(color: Colors.white60),),
              const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration:  InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.purple.shade50,
                ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                  hintText: 'Şifre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.purple.shade50,
                ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text('Giriş',style: TextStyle(color: bgColor,fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                 const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text('Hesabınız\ yok mu? Kayıt olun',style: TextStyle(color: Colors.white60),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }
}
