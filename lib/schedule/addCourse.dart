import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Information"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: new TextEditingController(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed:(){Navigator.pushNamed(context, '/addCourse');},
                child: Text("Add course")),
            Text("My Courses"),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, pos) {
                  return Card(
                    child: ListTile(
                      title: Text("CourseCode $pos"),
                      subtitle: Text("CourseName $pos"),
                      trailing: Icon(Icons.edit_outlined),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}
