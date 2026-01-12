import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Connects to your Firebase project
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blue),
    home: JmPrimeHome(),
  ));
}

class JmPrimeHome extends StatefulWidget {
  @override
  _JmPrimeHomeState createState() => _JmPrimeHomeState();
}

class _JmPrimeHomeState extends State<JmPrimeHome> {
  User? user = FirebaseAuth.instance.currentUser;

  // --- 1. THE LOGIN POP-UP (MODAL) ---
  void _showLoginPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Login to JM PRIME", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(labelText: "Email")),
            TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { /* Add Firebase Auth logic here */ },
              child: Text("Sign In"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // --- 2. THE SCAFFOLD (THE SKELETON) ---
      appBar: AppBar(
        title: Text("JM PRIME"),
        // This ensures the 3-line menu icon is always visible and functional
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      
      // --- 3. THE 3-LINE MENU (DRAWER) ---
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              accountName: Text(user != null ? "Pro User" : "Guest"),
              accountEmail: Text(user?.email ?? "Sign in to sync old data"),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text("Scan History"),
              onTap: () {
                Navigator.pop(context); // Close menu
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart, color: Colors.green),
              title: Text("Export to Excel"),
              onTap: () => print("Excel Logic"),
            ),
            Divider(),
            if (user == null) 
              ListTile(leading: Icon(Icons.login), title: Text("Login"), onTap: () => _showLoginPopup(context))
            else
              ListTile(leading: Icon(Icons.logout), title: Text("Logout"), onTap: () => FirebaseAuth.instance.signOut()),
          ],
        ),
      ),
      body: Center(child: Text("Camera Interface Lives Here")),
    );
  }
}

// --- 4. THE HISTORY PAGE (FOR OLD DATA) ---
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Old Data")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('scans').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) => ListTile(
              leading: Icon(Icons.description),
              title: Text(doc['title'] ?? 'Untitled Scan'),
              subtitle: Text(doc['date'] ?? 'No date'),
              onTap: () => print("Opening old scan: ${doc.id}"),
            )).toList(),
          );
        },
      ),
    );
  }
}
