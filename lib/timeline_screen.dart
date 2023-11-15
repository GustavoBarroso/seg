import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/report.dart';
import 'report_screen.dart';
import 'drawer.dart';

class TimelineScreen extends StatefulWidget {
  final User user;

  const TimelineScreen({Key? key, required this.user}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Color corPrincipal = Color(0xFF243D7E);
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Report> listReport = []; // Declaração da lista

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(user: widget.user),
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection("report").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            listReport = snapshot.data!.docs
                .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: listReport.length,
                itemBuilder: (context, index) {
                  Report model = listReport[index];
                  return ListTile(
                    title: Text(model.descricao),
                  );
                },
              ),
            );
          }
        },
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

  Future<void> refresh() async {
    List<Report> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firebaseFirestore.collection("report").get();

    for (var doc in snapshot.docs) {
      temp.add(Report.fromMap(doc.data() as Map<String, dynamic>));
    }

    setState(() {
      listReport = temp;
    });
  }
}
