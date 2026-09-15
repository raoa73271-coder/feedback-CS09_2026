import 'package:feedback/backend/login%20backend.dart';
import 'package:feedback/screen/review%20screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login screen.dart' show LoginScreen;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('SignUp',style:TextStyle(fontWeight:FontWeight.w400),),),
      body:SingleChildScrollView(
        child: Center(
          child:Column(mainAxisAlignment:MainAxisAlignment.center,
            children: [
              TextFormField(
                controller:emailController ,
                decoration: InputDecoration(hintText:'Enter Email',
                  prefixIcon: Icon(Icons.email),labelText:'email',
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(obscureText:true,
                controller:passwordController,
                decoration: InputDecoration(
                  hintText:'Enter Password',prefixIcon:Icon(Icons.password),labelText:'password',
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed:()async {
                try {
                  await Login().signUp(email: emailController.text,
                      password: passwordController.text);
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>ReviewScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully SignUp')));
        
              }on FirebaseAuthException catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ??'SignUp failed')));}
              },
                  child:Text('SignUp')),
              SizedBox(height: 20,),
              TextButton(onPressed:(){
                Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginScreen()));
              }, child:Text('Already SignIn?',style:TextStyle(
                fontStyle:FontStyle.italic
              ),)),
            ],
          ),
        ),
      ),
    );
  }
}
