import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:toko_buku_online/screen/login_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _addrController;
  TextEditingController? _genderController;

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _addrController =
              TextEditingController(text: data['addr']),
        ),
        TextFormField(
          controller: _addrController =
              TextEditingController(text: data['gender']),
        ),
        ElevatedButton(
            onPressed: () => updateData(), child: Text("Perbarui Data")),
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "addr": _addrController!.text,
      "gender": _genderController!.text,
    }).then((value) => print("Data Selesai Diperbarui"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                'images/profile.png',
                width: 200,
              ),
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users-form-data")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return setDataToTextField(data);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
