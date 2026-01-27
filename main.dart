import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(home: JmPrimeHome()));
}

class JmPrimeHome extends StatefulWidget {
  const JmPrimeHome({super.key});
  @override
  State<JmPrimeHome> createState() => _JmPrimeHomeState();
}

class _JmPrimeHomeState extends State<JmPrimeHome> {
  User? user = FirebaseAuth.instance.currentUser;

  // --- LOGIN POP-UP (MODAL) ---
  void _showLoginPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Login to JM PRIME", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue[700]),
              onPressed: () { 
                // Logic: FirebaseAuth.instance.signInWithEmailAndPassword(...)
                setState(() => user = FirebaseAuth.instance.currentUser);
                Navigator.pop(context); 
              },
              child: const Text("Sign In", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- APPBAR WITH 3-LINE MENU ICON ---
      appBar: AppBar(
        title: const Text("JM PRIME", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      // --- 3-LINE MENU (DRAWER) ---
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[700]),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.blue)),
              accountName: Text(user != null ? "Pro User" : "Guest Mode"),
              accountEmail: Text(user?.email ?? "Sign in for History sync"),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text("Scan History"),
              subtitle: const Text("Access old documents"),
              onTap: () {
                Navigator.pop(context); // Close Drawer
                if (user != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
                } else {
                  _showLoginPopup();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text("Export to Excel"),
              onTap: () => print("Excel Logic Triggered"),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: Icon(user == null ? Icons.login : Icons.logout, color: Colors.red),
              title: Text(user == null ? "Login" : "Logout"),
              onTap: () {
                if (user == null) {
                  _showLoginPopup();
                } else {
                  FirebaseAuth.instance.signOut();
                  setState(() => user = null);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text("Ready to scan your first document"),
          ],
        ),
      ),
    );
  }
}

// --- HISTORY PAGE (ACCESSING OLD DATA) ---
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Old Data")),
      body: StreamBuilder<QuerySnapshot>(
        // Connects to your "scans" collection in Firebase
        stream: FirebaseFirestore.instance.collection('scans').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No history found."));

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: Text(doc['title'] ?? 'Untitled Scan'),
                  subtitle: Text(doc['date'] ?? 'Jan 20, 2026'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => print("Fetching old text: ${doc['text']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
