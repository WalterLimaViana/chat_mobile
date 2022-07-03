import 'package:chat_mobile/firebase_options.dart';
import 'package:chat_mobile/pages/login_page.dart';
import 'package:chat_mobile/pages/splash_page.dart';
import 'package:chat_mobile/provider/auth_provider.dart';
import 'package:chat_mobile/provider/chat_provider.dart';
import 'package:chat_mobile/provider/home_provider.dart';
import 'package:chat_mobile/provider/profile_provider.dart';
import 'package:chat_mobile/utilities/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
              firebaseFirestore: firebaseFirestore,
              prefs: prefs,
              googleSignIn: GoogleSignIn(),
              firebaseAuth: FirebaseAuth.instance),
        ),
        Provider<ProfileProvider>(
          create: (_) => ProfileProvider(
            prefs: prefs,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        Provider<HomeProvider>(
            create: (_) => HomeProvider(firebaseFirestore: firebaseFirestore)),
        Provider<ChatProvider>(
            create: (_) => ChatProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Mobile',
        theme: appTheme,
        home: SplashPage(),
      ),
    );
  }
}
