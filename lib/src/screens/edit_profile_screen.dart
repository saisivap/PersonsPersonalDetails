import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codium_assignment/main.dart';
import 'package:codium_assignment/src/models/person_model.dart';
import 'package:codium_assignment/src/screens/person_screen.dart';
import 'package:codium_assignment/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  var personKey;

  EditProfileScreen({Key? key, this.personKey: null}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  var _imageFile;
  var _imageFilePath;
  Uint8List? imageByteArray;
  late Box<Person> personBox;
  final ImagePicker _imagePicker = ImagePicker();
  void takePhoto() async {
    PickedFile? pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile!;
      _imageFilePath = File(pickedFile.path);

      imageByteArray = _imageFilePath.readAsBytesSync();
      print(
        "------------------------------------------------------${imageByteArray}",
      );
    });
  }

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    personBox = Hive.box(personModelName);
    if (widget.personKey != null) {
      final person = personBox.get(widget.personKey);
      nameController.text = person!.name;
      emailController.text = person.email;
      dobController.text = person.dob;
      addressController.text = person.address;
      imageByteArray = person.file;
    }
  }

  checkValidation() {
    if (imageByteArray == null || _imageFile == null) {
      Get.snackbar("Waring", "Must Add Image");
    }
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      if (widget.personKey == null) {
        Person person = Person(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          dob: dobController.text.trim(),
          address: addressController.text.trim(),
          file: imageByteArray!,
        );
        personBox.add(person);
      } else {
        Person? person = personBox.get(widget.personKey);
        person!.name = nameController.text.trim();
        person.email = emailController.text.trim();
        person.dob = dobController.text.trim();
        person.address = addressController.text.trim();
        person.file = imageByteArray!;
        personBox.put(widget.personKey, person);
      }

      Get.to(PersonScreen());

      print("validated");
    } else {
      print("Invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            print("Back");
            Get.to(PersonScreen());
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blueGrey,
          ),
        ),
        title: appbarText(
          "Edit Profile",
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  checkValidation();
                },
                child: textCustom("Save"),
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  takePhoto();
                },
                child: _imageFile == null && widget.personKey == null
                    ? CircleAvatar(
                        radius: height * 0.06,
                        backgroundImage: AssetImage("assets/images/camera.png"))
                    : widget.personKey != null && _imageFile != null
                        ? CircleAvatar(
                            radius: height * 0.06,
                            backgroundImage: FileImage(_imageFilePath),
                          )
                        : widget.personKey == null
                            ? CircleAvatar(
                                radius: height * 0.06,
                                backgroundImage: FileImage(_imageFilePath),
                              )
                            : CircleAvatar(
                                radius: height * 0.06,
                                backgroundImage: MemoryImage(
                                  personBox.get(widget.personKey)!.file,
                                ),
                              ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appbarText("Name"),
                    customTextField(
                      nameController,
                      (value) {
                        if (value!.isEmpty || value == null) {
                          return "Enter your Name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    appbarText("E-Mail"),
                    customTextField(
                      emailController,
                      (value) {
                        if (value!.isEmpty || value == null) {
                          return "Enter your Email";
                        } else {
                          if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return null;
                          } else {
                            return "Please enter valid Email";
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    appbarText("Birth Date"),
                    customTextField(
                      dobController,
                      (value) {
                        if (value!.isEmpty || value == null) {
                          return "Enter Your BirthDate";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    appbarText("Address"),
                    customTextField(addressController, (value) {
                      if (value!.isEmpty || value == null) {
                        return "Enter your Address ";
                      } else {
                        return null;
                      }
                    }, isaddress: true),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding customTextField(
      TextEditingController controller, String? Function(String?)? callback,
      {bool isaddress: false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onChanged: (value) {
          print(value);
        },
        validator: callback,
        controller: controller,
        maxLines: isaddress ? 5 : 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
