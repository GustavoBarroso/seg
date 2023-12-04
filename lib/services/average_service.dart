import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seg/component/report.dart';

class AverageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> calculateAverage(List<Avaliacao>? avaliacoes) async {
    if (avaliacoes == null || avaliacoes.isEmpty) {
      return 0.0;
    }

    double sumOfRatings = avaliacoes.fold(0, (acc, avaliacao) => acc + avaliacao.nota);
    double average = sumOfRatings / avaliacoes.length;
    return double.parse(average.toStringAsFixed(1));
  }
}
