import 'package:feedback/backend/login%20backend.dart';
import 'package:feedback/screen/home%20screen.dart';
import 'package:feedback/screen/review%20screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:Text('Login Screen'),),
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(mainAxisAlignment:MainAxisAlignment.center,
      children: [
        TextFormField(
          controller:emailController ,
          decoration: InputDecoration(hintText:'Enter Email',prefixIcon: Icon(Icons.email),
            labelText:'email',
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(20),
            ),
          ),
        ),

        SizedBox(height: 20,),
        TextFormField(obscureText:true,
          controller:passwordController,
          decoration: InputDecoration(
            hintText:'Enter Password',prefixIcon:Icon(Icons.password),
            labelText:'password',
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(20),
            ),
          ),
        ),
      SizedBox(height: 20,),
      ElevatedButton(onPressed:()async{
        try{
       await Login().login(email: emailController.text, password: passwordController.text);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Login Successful')));
        Navigator.push(context,MaterialPageRoute(builder:(context)=>ReviewScreen()));
        }on FirebaseAuthException catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message ??'Login failed')));
        }
      }, child:Text('Login')),
      ],
    ),),),);
  }
}
