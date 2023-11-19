import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  Color corIncidente = Colors.black.withOpacity(0.7);
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
            List<Report> reports = snapshot.data!.docs
                .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  Report model = reports[index];

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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: corPrincipal,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timeAgo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Incidente: ${model.incidente}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: corIncidente,
                                    ),
                                  ),
                                  Text(
                                    'Descrição: ${model.descricao}',
                                    style: TextStyle(
                                      fontSize: 16,
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
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Localização: ${model.formatarLocalizacaoSimplificada()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 34,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: corPrincipal,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // logica pra jogar a nota no firestore
                                  },
                                ),
                              ],
                            ),
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

    temp.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      listReport = temp;
    });
  }
}
