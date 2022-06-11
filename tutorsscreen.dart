import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latesttutorapp/models/config.dart';
import 'package:latesttutorapp/models/tutor.dart';
import 'package:http/http.dart' as http;

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      body: tutorList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Tutors available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 1),
                      children: List.generate(tutorList.length, (index) {
                        return InkWell(
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: MyConfig.server +
                                      "/mynewtutor/assets/tutors/" +
                                      tutorList[index].tutorId.toString() +
                                      '.jpg', //change path
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Text(
                                            tutorList[index]
                                                .tutorName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            tutorList[index]
                                                .tutorPhone
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            tutorList[index]
                                                .tutorEmail
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                                SizedBox(height:10),
                                        Text(
                                            tutorList[index]
                                                .tutorDescription
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadTutors(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
          setState(() {});
        }
      }
    });
  }
}
