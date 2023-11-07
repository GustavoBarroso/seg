import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/report.dart';
import 'report_screen.dart';
import 'drawer.dart';

class TimelineScreen extends StatefulWidget {
  final User user;

  const TimelineScreen({super.key, required this.user});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Color corPrincipal = Color(0xFF243D7E);
  List<Report> listReport = [];
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    //refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(user: widget.user), // Use o drawer personalizado
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        //child: SingleChildScrollView(
          child: ListView(
            children: List.generate(listReport.length, (index) {
              Report model = listReport[index];
              return ListTile(
                title: Text(model.descricao),

              );
            })

          ),
        //),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReport()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: corPrincipal,
      ),
    );
  }

  Future<List<Report>> refresh() async {
    List<Report> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore.collection("report").get();

    for (var doc in snapshot.docs) {
      temp.add(Report.fromMap(doc.data()));
    }

    return temp;
  }

}
