import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pure_skin_ai/auth/register_page.dart';
import 'package:pure_skin_ai/auth/screens/Home/home_page.dart';
import 'package:pure_skin_ai/auth/screens/products/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد المكتبة مباشرة هنا


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool scure = true;
  GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (loginKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true); 
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductPage()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMsg = "Login failed";
        if (e.code == 'user-not-found') {
          errorMsg = "This email is not registered.";
        } else if (e.code == 'wrong-password') {
          errorMsg = "Wrong password.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }

  
  Future<void> signInAsGuest(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      
      if (!mounted) return;
      Navigator.pop(context); 

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while logging in as a guest: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bac1.jpeg'), 
              fit: BoxFit.cover
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login here',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF5F8063)),
                ),
                const SizedBox(height: 20),
                const Text('Welcome back!', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 50),
              
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: password,
                          obscureText: scure,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(onPressed: () => setState(() => scure = !scure), icon: Icon(scure ? Icons.visibility_off : Icons.visibility)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F8063),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    onPressed: () => signInAsGuest(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFF5F8063)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Sign in as Guest', style: TextStyle(color: Color(0xFF5F8063))),
                  ),
                ),

                const SizedBox(height: 20),
                
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Register())),
                  child: const Text('Create new account', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}