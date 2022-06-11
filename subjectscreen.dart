import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latesttutorapp/models/config.dart';
import 'package:latesttutorapp/models/subject.dart';
import 'package:http/http.dart' as http;

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
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
      body: subjectList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Subjects available",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: MyConfig.server +
                                      "/mynewtutor/assets/courses/" +
                                      subjectList[index].subjectId.toString() +
                                      '.PNG',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 30),
                                        Text(
                                            subjectList[index]
                                                .subjectName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Text(
                                            "RM" +
                                                double.parse(subjectList[index]
                                                        .subjectPrice
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 5),
                                        Text(
                                            subjectList[index]
                                                    .subjectSessions
                                                    .toString() +
                                                " sessions",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  subjectList[index]
                                                      .subjectRating
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              IconButton(
                                                icon: const Icon(Icons.star),
                                                color: Colors.red,
                                                onPressed: () {},
                                              ),
                                            ]),
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
                          onPressed: () => {_loadSubjects(index + 1)},
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

  _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/load_subjects.php"),
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

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          setState(() {});
        }
      }
    });
  }
}
