import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'component/report.dart';
import 'report_screen.dart';
import 'drawer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'services/LocationService.dart';
import 'package:geolocator/geolocator.dart';

class TimelineScreen extends StatefulWidget {
  final User user;

  const TimelineScreen({Key? key, required this.user}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Color corPrincipal = Color(0xFF243D7E);
  Color corIncidente = Colors.black.withOpacity(0.7);
  double _latitude = 0.0;
  double _longitude = 0.0;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Report> listReport = [];
  LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
    refresh(useruid: widget.user.uid);
  }

  Future<void> _obterLocalizacaoAtual() async {
    try {
      Position position = await _locationService.getLocalizacaoAtual();
      setState(() {
        _latitude = position.latitude ?? 0.0;
        _longitude = position.longitude ?? 0.0;
      });
      await refresh(useruid: widget.user.uid);
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
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
                .map(
                  (doc) => Report.fromMap(doc.data() as Map<String, dynamic>),
            )
                .toList();
            reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            return RefreshIndicator(
              onRefresh: () async {
                await refresh(useruid: widget.user.uid);
              },
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  Report model = reports[index];
                  String timeAgo = timeago.format(
                    model.timestamp.toDate(),
                    locale: 'pt_BR',
                  );

                  Avaliacao? avaliacaoUsuario = model.avaliacoes?.firstWhere(
                        (avaliacao) => avaliacao.useruid == widget.user.uid,
                    orElse: () => Avaliacao(nota: 0.0, useruid: ""),
                  );

                  if (avaliacaoUsuario != null &&
                      avaliacaoUsuario.reportId == model.id) {
                    return buildReportCardWithRating(model, timeAgo, avaliacaoUsuario);
                  } else {
                    return buildReportCardWithoutRating(model, timeAgo);
                  }
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

  Widget buildReportCardWithRating(
      Report model, String timeAgo, Avaliacao avaliacaoUsuario) {
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
                model.username ?? "",
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
                      'Incidente: ${model.incidente ?? ""}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corIncidente,
                      ),
                    ),
                    Text(
                      '${model.descricao ?? ""}',
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
                    '${model.formatarLocalizacaoSimplificada()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: avaliacaoUsuario.nota,
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
                      storeRating(
                        rating,
                        model.useruid,
                        reportId: model.id,
                      );
                    },
                  ),
                ],
              ),
            ),
            Text(
              'Sua Avaliação: ${avaliacaoUsuario.nota}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: corPrincipal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportCardWithoutRating(Report model, String timeAgo) {
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
                model.username ?? "",
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
                      'Incidente: ${model.incidente ?? ""}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corIncidente,
                      ),
                    ),
                    Text(
                      '${model.descricao ?? ""}',
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
                    '${model.formatarLocalizacaoSimplificada()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refresh({required String useruid}) async {
    List<Report> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firebaseFirestore.collection("report").get();

    for (var doc in snapshot.docs) {
      Report report = Report.fromMap(doc.data() as Map<String, dynamic>);

      List<Avaliacao> avaliacoes = await FirestoreService()
          .getAvaliacoesDoUsuario(report.id ?? "");
      temp.add(report.copyWith(avaliacoes: avaliacoes));
    }

    setState(() {
      listReport = temp;
    });
  }

  void storeRating(double rating, String? useruid, {required String reportId}) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ratings = firestore.collection('avaliacoes');
    ratings.add({
      'nota': rating,
      'data': DateTime.now(),
      'useruid': useruid,
      'reportId': reportId,
    });
  }
}
