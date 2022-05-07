import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potholefinder/models/report.dart';
import 'package:potholefinder/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Upload Report
  Future<String> uploadReport(
    String reporterName,
    String mobileNo,
    String pinCode,
    String address,
    String landMark,
    Uint8List file,
  ) async {
    String res = 'some error occurred';
    try {
      String potholeImageUrl =
          await StorageMethods().uploadImageToStorage('potholeImage', file);

      String reportId = const Uuid().v1();

      Report report = Report(
          reporterName: reporterName,
          mobileNo: mobileNo,
          pinCode: pinCode,
          address: address,
          landMark: landMark,
          potholeImage: potholeImageUrl,
          reportId: reportId
          );
    _firestore.collection("posts").doc(reportId).set(report.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
