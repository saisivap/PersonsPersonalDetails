import 'dart:convert';
import 'dart:ffi';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:codium_assignment/main.dart';
import 'package:codium_assignment/src/models/person_model.dart';
import 'package:codium_assignment/src/screens/edit_profile_screen.dart';
import 'package:codium_assignment/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  late Box<Person> personBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    personBox = Hive.box(personModelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: appbarText("Persons"),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Get.to(EditProfileScreen());
                },
                child: Icon(
                  Icons.add,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: ValueListenableBuilder(
            valueListenable: personBox.listenable(),
            builder: (context, Box<Person> persons, _) {
              List<int> keys = persons.keys.cast<int>().toList();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final key = keys[index];
                      final Person? person = personBox.get(key);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.02),
                        child: GestureDetector(
                          onLongPress: () {
                            persons.delete(key);
                          },
                          onTap: () {
                            Get.to(EditProfileScreen(
                              personKey: key,
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.01,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 0.5, color: Colors.blueGrey),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(-1, 4),
                                      color: Colors.blueGrey,
                                      spreadRadius: 1,
                                      blurRadius: 5),
                                  BoxShadow(
                                      offset: Offset(-4, -4),
                                      color: Colors.white,
                                      spreadRadius: 2,
                                      blurRadius: 10)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userAvatar(person!),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                personDetail(person),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
      ),
    );
  }

  Widget personDetail(Person person) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appbarText(person.name),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.6,
                  child: Text(
                    person.email,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      // fontSize: 18,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                smalltextCustom(person.address)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userAvatar(Person person) {
    return Container(
      // width: width * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(
                    person.file,
                  ),
                ),
                shape: BoxShape.circle,
                color: Colors.grey,
                border: Border.all(color: Colors.blueGrey, width: 2)),
            child: Center(),
          ),
        ],
      ),
    );
  }
}
