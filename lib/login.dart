import 'package:exsammm/main.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameRegistrationPage extends StatelessWidget {
  const NameRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool _forgotPassword = false;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 288,
                        height: 450,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xffD9D9D9),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 70), 
                            _buildNameForm(emailController, passwordController, _forgotPassword),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -70,
                        left: (288 / 2) - 70, 
                        child: Container(
                          width: 140,
                          height: 140,
                          child: Image.asset("images/oo.png"),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70.0),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildNameButton(context, emailController, passwordController),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xff1B2F6C),
    );
  }

  Widget _buildNameForm(TextEditingController emailController, TextEditingController passwordController, bool forgotPassword) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Email", style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
          _buildTextField(emailController, Icons.email, "Example@gmail.com", false),
          SizedBox(height: 40),
          Padding(
              padding: const EdgeInsets.only(left: 10.0),
            child: Text("Password", style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
          _buildTextField(passwordController, Icons.lock, "Enter your password", true),
           SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                child: Checkbox(
                  value: forgotPassword,
                  onChanged: (value) {
                    forgotPassword = value!;
                  },
                ),
              ),
             
              Text("Remember me"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hintText, bool obscureText) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xff1B2F6C),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xff1B2F6C),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Color(0xff1B2F6C),
              width: 2.0,
            ),
          ),
          fillColor: Color(0xff77C1C1),
          filled: true, 
        ),
      ),
    );
  }

  Widget _buildNameButton(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return SizedBox(
      height: 90,
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            String email = emailController.text;
            String password = passwordController.text;
      
           
            await GetIt.I<SharedPreferences>().setString('email', email);
      
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login successful'),
                backgroundColor: Colors.green,
              ),
            );
      
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 120,
            ),
          ),
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff1B2F6C),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final prefs = snapshot.data!;
            final email = prefs.getString('email') ?? 'No email found';

            return Scaffold(
              backgroundColor: Color(0xff1B2F6C),
              appBar: AppBar(
                title: Text('Welcome'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, $email',
                      style: TextStyle(fontSize: 24,color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProjectsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 50,
                        ),
                      ),
                      child: Text(
                        "Go to Projects",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff1B2F6C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Error loading email'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
