import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:potholefinder/resources/firestore_methods.dart';
import 'package:potholefinder/utlis/colors.dart';
import 'package:potholefinder/utlis/global_variables.dart';

import '../utlis/utils.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _mobileNoController = TextEditingController();

  final TextEditingController _pincodeController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _landMarkController = TextEditingController();

  bool isLoading = false;

  //location supporting data
  Location location = new Location();

  late bool _serviceEnabled;

  late PermissionStatus _permissionGranted;

  late LocationData _locationData;

  Uint8List? _file;

  void submitReport() async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadReport(
          _nameController.text,
          _mobileNoController.text,
          _pincodeController.text,
          _addressController.text,
          _landMarkController.text,
          _file!);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar("Reported!", context);
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _mobileNoController.dispose();
    _addressController.dispose();
    _landMarkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryMainColor,
        title: const Text("Report Potholes"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //SVG image
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      "assets/pothole_img.svg",
                      height: 200,
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        icon: Icon(Icons.account_box),
                        iconColor: primaryMainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  // The validator receives the text that the user has entered.
                  TextFormField(
                    controller: _mobileNoController,
                    decoration: const InputDecoration(
                        labelText: "Mobile No.", icon: Icon(Icons.phone)),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          (!value.contains(RegExp(r'^[0-9]+$')))) {
                        return 'Please enter valid mobile no';
                      } else if (value.length != 10) {
                        return 'Please enter 10 digit mobile no';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: const InputDecoration(
                        labelText: "Area Pin code",
                        icon: Icon(Icons.landscape),
                        iconColor: primaryMainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Pin code';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        labelText: "Pothole address",
                        icon: Icon(Icons.home),
                        iconColor: primaryMainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _landMarkController,
                    decoration: const InputDecoration(
                        labelText: "Pothole Landmark",
                        icon: Icon(Icons.landscape),
                        iconColor: primaryMainColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryMainColor),
                                  onPressed: () async {
                                    _serviceEnabled =
                                        await location.serviceEnabled();
                                    if (!_serviceEnabled) {
                                      _serviceEnabled =
                                          await location.requestService();
                                      if (!_serviceEnabled) {
                                        return;
                                      }
                                    }

                                    _permissionGranted =
                                        await location.hasPermission();
                                    if (_permissionGranted ==
                                        PermissionStatus.denied) {
                                      _permissionGranted =
                                          await location.requestPermission();
                                      if (_permissionGranted !=
                                          PermissionStatus.granted) {
                                        return;
                                      }
                                    }

                                    //this is location data
                                    _locationData =
                                        await location.getLocation();
                                  },
                                  child: const Icon(Icons.gps_fixed)),
                            ),
                            const Text(
                              "Give Location access",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryMainColor),
                                  onPressed: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    //it has image data xfile
                                    Uint8List file =
                                        await pickImage(ImageSource.gallery);
                                    setState(
                                      () {
                                        _file = file;
                                      },
                                    );
                                  },
                                  child: Icon(Icons.image)),
                            ),
                            const Text(
                              "Selcet Pothole Image",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: primaryMainColor,
                    child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                      minWidth: MediaQuery.of(context).size.width / 2,
                      onPressed: () => submitReport(),
                      child: isLoading == true
                          ? const Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  )),
                            )
                          : const Text(
                              "Report Pothole",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
