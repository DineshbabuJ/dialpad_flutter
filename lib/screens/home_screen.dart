import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_appp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  late DocumentSnapshot userData;

  getData() async {
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(userData.data());
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
          actions: [
            authProvider.loggingOut
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      authProvider.logout(context);
                    },
                    child: Text('logout'),
                  ),
          ],
        ),
        // body: Center(
        //   child: loading
        //       ? CircularProgressIndicator()
        //       : Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             Text(
        //               'Welcome ${(userData.data() as Map<String, dynamic>)['name']}',
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Text(
        //               'your uID is ${authProvider.credential!.user!.uid}',
        //             ),
        //           ],
        //         ),
        // ),
        // body: FutureBuilder<DocumentSnapshot>(
        //     future: FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(FirebaseAuth.instance.currentUser!.uid)
        //         .get(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData)
        //         return Center(child: CircularProgressIndicator());
        //
        //       return Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             Text(
        //               'Welcome ${(snapshot.data!.data() as Map<String, dynamic>)['name']}',
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Text(
        //               'your uID is ${authProvider.user!.uid}',
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome ${(snapshot.data!.data() as Map<String, dynamic>)['name']}',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'your uID is ${authProvider.user!.uid}',
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }
}
