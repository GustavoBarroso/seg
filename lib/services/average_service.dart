import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AverageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> calculateAverage(User user) async {
    CollectionReference ratings = _firestore.collection('avaliacoes');

    QuerySnapshot querySnapshot =
    await ratings.where('useruid', isEqualTo: user.uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      double sumOfRatings = 0;
      int numberOfDocuments = querySnapshot.docs.length;

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        sumOfRatings += document['nota'];
      }

      double average = sumOfRatings / numberOfDocuments;
      return double.parse(average.toStringAsFixed(1));
    } else {
      return 5.0;
    }
  }
}
