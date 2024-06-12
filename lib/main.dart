import 'package:dio/dio.dart';
import 'package:exsammm/login.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<SharedPreferences>(sharedPreferences);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: NameRegistrationPage(),
    );
  }
}

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Future<List<Comments>>? _futureComments;

  @override
  void initState() {
    super.initState();
    _futureComments = getQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 46, 78),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Expanded(
              child: FutureBuilder<List<Comments>>(
                future: _futureComments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data found'));
                  }

                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Container(
                              width: 310,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  child: Text(
                                    "All Projects",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 206, 189),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        );
                      } else {
                        final comment = comments[index - 1];
                        return ProjectCard(
                          name: comment.user!.fullName!,
                          date: 'Likes: ${comment.likes}',
                          body: comment.body!,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String name;
  final String date;
  final String body;

  ProjectCard({required this.name, required this.date, required this.body});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Stack(
          children: [
            Positioned(
              left: -44,
              top: -38,
              child: Transform.rotate(
                angle: -0.7,
                origin: Offset(0, 0),
                child: Container(
                  width: 140,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 43, 206, 189),
                    border: Border.all(
                      color: Color.fromARGB(255, 2, 6, 41),
                      width: 2.0,
                    ),
                  ),
                  child: Transform.rotate(
                    angle: 0.7,
                    origin: Offset(0, 0),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: 45,
                            child: Text(
                              date,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project name: $name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Color.fromARGB(255, 6, 15, 94),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Comment: $body',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color.fromARGB(255, 6, 15, 94),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Autogenerated {
  List<Comments>? comments;
  int? total;
  int? skip;
  int? limit;

  Autogenerated({this.comments, this.total, this.skip, this.limit});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }
}

class Comments {
  int? id;
  String? body;
  int? postId;
  int? likes;
  User? user;

  Comments({this.id, this.body, this.postId, this.likes, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    postId = json['postId'];
    likes = json['likes'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['body'] = body;
    data['postId'] = postId;
    data['likes'] = likes;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? fullName;

  User({this.id, this.username, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    return data;
  }
}

Future<List<Comments>> getQuiz() async {
  Dio req = Dio();
  Response response = await req.get("https://dummyjson.com/comments");
  List<Comments> comments = List.generate(
    response.data['comments'].length,
    (index) => Comments.fromJson(response.data['comments'][index]),
  );
  return comments;
}
