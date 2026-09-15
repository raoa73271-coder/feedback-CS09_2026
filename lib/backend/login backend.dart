import 'package:firebase_auth/firebase_auth.dart';

class Login{
  final FirebaseAuth auth=FirebaseAuth.instance;
Future<void> login({required String email,required String password})async{
await auth.signInWithEmailAndPassword(email: email, password: password);
}
Future<void>logout()async{
  await auth.signOut(
  );
}
Future<void>signUp({required String email,required String password})async{
  await auth.createUserWithEmailAndPassword(email: email, password: password);
}}