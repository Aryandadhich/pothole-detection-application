import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reporterName;
  final String mobileNo;
  final String pinCode;
  final String address;
  final String landMark;
  final String potholeImage;
  final String reportId;

  Report({
    required this.reporterName,
    required this.mobileNo,
    required this.pinCode,
    required this.address,
    required this.landMark,
    required this.potholeImage,
    required this.reportId,
  });

  Map<String, dynamic> toJson() => {
        'reporterName': reporterName,
        'mobileNo': mobileNo,
        'pinCode': pinCode,
        'address': address,
        'landMark': landMark,
        'potholeImage': potholeImage,
        'reportId':reportId
      };

  static Report fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Report(
        reporterName: snapshot['reporterName'],
        mobileNo: snapshot['mobileNo'],
        pinCode: snapshot['pinCode'],
        address: snapshot['address'],
        landMark: snapshot['landMark'],
        potholeImage: snapshot['potholeImage'],
        reportId: snapshot['reportId']);
  }
}
