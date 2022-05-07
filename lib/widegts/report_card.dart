import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:potholefinder/utlis/colors.dart';

class ReportCard extends StatefulWidget {
  final snap;
  const ReportCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool isLoading = false;

  @override
  void setState(VoidCallback fn) async {
    super.setState(fn);
    await Future.delayed(const Duration(seconds: 3));
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: ExpansionTile(
              backgroundColor: primaryColor,
              leading: Builder(builder: (context) {
                return const CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/profile_pic.jpg'),
                );
              }),
              title: Text("Reported by : ${widget.snap['reporterName']}"),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Mobile No. : ${widget.snap['mobileNo']}"),
                ],
              ),
              children: [
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pin code : ${widget.snap['pinCode']}"),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text("Address : ${widget.snap['address']}"),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text("Landmark : ${widget.snap['landMark']}"),
                          const SizedBox(
                            height: 5.0,
                          ),
                          // Text(
                          //     "Landmark :${querySnapshot.documents[i].data['position']['geopoint'].latitude.runtimeType}"),
                        ],
                      )),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Pothole Image",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['potholeImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.navigate_before),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Navigate me'),
                        ],
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.open_in_browser),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('See Pothole !'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
