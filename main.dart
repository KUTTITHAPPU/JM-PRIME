import 'package:flutter/material.dart';

// THE MAIN SCANNER PAGE
class JmPrimeHome extends StatefulWidget {
  @override
  _JmPrimeHomeState createState() => _JmPrimeHomeState();
}

class _JmPrimeHomeState extends State<JmPrimeHome> {
  bool isLoggedIn = false; 

  // Function to show the Login Pop-up
  void _showLoginModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Login to JM PRIME", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { setState(() => isLoggedIn = true); Navigator.pop(context); },
              child: Text("Sign In"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("JM PRIME"), backgroundColor: Colors.blue[600]),
      
      // THE 3-LINE MENU (DRAWER)
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(isLoggedIn ? "JM PRIME User" : "Guest"),
              accountEmail: Text(isLoggedIn ? "user@example.com" : "Sign in to save data"),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text("History & Old Data"),
              onTap: () {
                if (isLoggedIn) {
                  // This is how you navigate to the SEPARATE History page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
                } else {
                  _showLoginModal(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("Export to Word"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(child: Icon(Icons.camera_alt, size: 100, color: Colors.grey)),
    );
  }
}
