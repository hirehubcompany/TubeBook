import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tubebook/pages/homepage/mypurchases/mypurchases.dart';

class MyDrawer extends StatelessWidget {


  const MyDrawer({super.key, });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text("Username"),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black87),
            ),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
            ),
          ),

          // Home
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),

          // My Purchases
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Purchases'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Mypurchases();
              }));
            },
          ),

          // Profile
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),

          Divider(),

          // Admin options





          // Logout
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
