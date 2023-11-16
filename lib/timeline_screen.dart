import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/report.dart';
import 'report_screen.dart';
import 'drawer.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimelineScreen extends StatefulWidget {
  final User user;

  const TimelineScreen({Key? key, required this.user}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Color corPrincipal = Color(0xFF243D7E);
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Report> listReport = [];

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
        title: Text("SEG"),
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
            // Converta a lista de documentos para uma lista de Report
            List<Report> reports = snapshot.data!.docs
                .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            // Ordenar a lista de mais novo para mais antigo
            reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  Report model = reports[index];

                  // Calcula o tempo decorrido desde a publicação
                  String timeAgo = timeago.format(model.timestamp.toDate(), locale: 'pt_BR');

                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            title: Text(
                              model.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                                color: corPrincipal,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timeAgo, // Exibe o tempo decorrido desde a publicação
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    model.descricao,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (model.urlPhoto != null && model.urlPhoto!.isNotEmpty)
                            Image.network(
                              model.urlPhoto!,
                              fit: BoxFit.cover,
                            ),
                        ],
                      ),
                    ),
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

    // Ordenar a lista de mais novo para mais antigo
    temp.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      listReport = temp;
    });
  }
}
