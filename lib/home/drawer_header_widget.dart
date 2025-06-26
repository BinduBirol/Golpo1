import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast messages

class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  _DrawerHeaderWidgetState createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  String? _error;

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final googleSignIn = GoogleSignIn(
        clientId: '937469130987-f4lu896haufafc5nhb8v1abijhjeoijk.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled sign in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        user = FirebaseAuth.instance.currentUser;
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      print('Sign-in error: $e');
      print(stacktrace);

      setState(() {
        _isLoading = false;
        _error = 'Sign-in failed. Please try again. Error: ${e.toString()}';
      });

      Fluttertoast.showToast(
        msg: _error!,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  Future<void> signOut() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      setState(() {
        user = null;
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      print('Sign-in error: $e');
      print(stacktrace);

      // Show a simple message in toast (no long JSON)
      Fluttertoast.showToast(
        msg: 'Sign-in failed. Check console for details.',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );

      setState(() {
        _isLoading = false;
        // Save full error string for display or debugging if needed
        _error = 'Sign-in failed. Please try again.';
      });
    }

  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? u) {
      setState(() {
        user = u;
        if (u != null) _error = null; // Clear errors on success
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    if (_isLoading) {
      return DrawerHeader(
        decoration: BoxDecoration(color: appBarTheme.backgroundColor),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Processing...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    if (user != null) {
      return DrawerHeader(
        decoration: BoxDecoration(color: appBarTheme.backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  backgroundImage: user!.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user!.photoURL == null
                      ? Icon(Icons.person, color: Colors.white, size: 40)
                      : null,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.displayName ?? 'No Name',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'User ID: ${user!.uid}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: signOut,
            ),
          ],
        ),
      );
    }

    // Not signed in and no loading: show sign in button and error (if any)
    return DrawerHeader(
      decoration: BoxDecoration(color: appBarTheme.backgroundColor),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
            ],
            ElevatedButton.icon(
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
