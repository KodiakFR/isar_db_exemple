import 'package:flutter/material.dart';
import 'package:isar_db_exemple/student_modal.dart';

import 'course_detail_page.dart';
import 'entities/course.dart';
import 'course_modal.dart';
import 'services/isar_service.dart';
import 'teacher_modal.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teacher Database',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar DB Tutorial'), actions: [
        IconButton(
          onPressed: () => service.cleanDb(),
          icon: const Icon(Icons.delete),
        )
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: FutureBuilder<List<Course>>(
                  future: service.getAllCourses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      final List<Course> courses = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                                itemCount: courses.length,
                                itemBuilder:  (context, index) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: ElevatedButton(
                                          child: Text(courses[index].title),
                                          onPressed: (){
                                            CourseDetailPage.navigate(
                                            context, courses[index], service);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
              // StreamBuilder<List<Course>>(
              //   stream: service.listenToCourses(),
              //   builder: (context, snapshot) => GridView.count(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 8,
              //     mainAxisSpacing: 8,
              //     scrollDirection: Axis.horizontal,
              //     children: snapshot.hasData
              //         ? snapshot.data!.map((course) {
              //             return ElevatedButton(
              //               onPressed: () {
              //                 CourseDetailPage.navigate(
              //                     context, course, service);
              //               },
              //               child: Text(course.title),
              //             );
              //           }).toList()
              //         : [],
              //   ),
              // ),

              ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CourseModal(service);
                  });
            },
            child: const Text("Add Course"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StudentModal(service);
                  });
            },
            child: const Text("Add Student"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return TeacherModal(service);
                  });
            },
            child: const Text("Add Teacher"),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
