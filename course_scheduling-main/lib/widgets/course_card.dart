import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  String courseName;
  String lecturer;
  // String room;
  String courseNumber;
  // String numberOfStudent;
  final MaterialColor color;
  CourseCard({
    super.key,
    required this.lecturer,
    required this.courseName,
    // required this.numberOfStudent,
    // required this.room,
    required this.courseNumber,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, 6),
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(children: [Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  gradient: LinearGradient(
                    colors: [
                      color.shade100,
                      color.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.menu_book, color: Colors.white),

              ), SizedBox(width: 8),Text(courseName, style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600
              ),),

              ]),

              SizedBox(height: 8),

              Text(courseNumber),

              SizedBox(height: 8),




              Row(
                children: [
                  Icon(Icons.person, color: color), SizedBox(width: 8),
                  Text( lecturer),
                ],
              ),
              SizedBox(height: 8),

              // Row(children: [Icon(Icons.place_outlined, color: color,), SizedBox(width: 8),Text( room)]),

              // SizedBox(height: 8),
              // Row(
                // children: [Icon(Icons.person_outline,
                // color:color), SizedBox(width: 8),Text( numberOfStudent)],
              // )

              SizedBox(height: 8),
              Row(children:[Icon(Icons.trending_up_outlined ,color: color,),
              SizedBox(width: 8),Text('Progress'),]),
              SizedBox(height: 8,),
              SizedBox(

                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              SizedBox(height : 18),
              Container(
                height: 2,
                color: Colors.grey.shade200,
              ),
              SizedBox(height: 12,),
              Text('3 credits')
            ],
          ),
        ),
      ),
    );
  }
}
