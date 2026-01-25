import 'package:course_scheduling/models/class.dart';
import 'package:flutter/material.dart';

class WeeklyCalendar extends StatelessWidget {
  final List<ClassItem> classes;

  const WeeklyCalendar({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    final startHour = 2;
    final endHour = 12;
    final hourHeight = 60.0; // height per hour row
    final dayWidth = 120.0; // width per day column
    final hourLabelWidth = 70.0; // width of the hour labels

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:Container(
        width: hourLabelWidth + days.length * dayWidth,
        height: hourHeight * (endHour - startHour + 1),
        child: Stack(
          children: [
            // Top-left corner: "Time"
            Container(
              width: hourLabelWidth,
              height: hourHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                "Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Hour labels (left column, starting second row)
            Positioned(
              left: 0,
              top: hourHeight,
              child: Column(
                children: List.generate(endHour - startHour, (i) {
                  final hour = startHour + i;
                  return Container(
                    width: hourLabelWidth,
                    height: hourHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text("$hour:00", style: TextStyle(fontSize: 12)),
                  );
                }),
              ),
            ),

            // Day labels (top row, starting second column)
            Positioned(
              left: hourLabelWidth,
              top: 0,
              child: Row(
                children: days.map((day) {
                  return Container(
                    width: dayWidth,
                    height: hourHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),

            // Grid background
            Positioned(
              left: hourLabelWidth,
              top: hourHeight,
              child: Column(
                children: List.generate(endHour - startHour, (i) {
                  return Container(
                    height: hourHeight,
                    child: Row(
                      children: List.generate(days.length, (j) {
                        return Container(
                          width: dayWidth,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey.shade300),
                              top: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),

            // Class boxes
            ...classes.map((c) {
              int dayIndex = days.indexOf(c.day);
              return Positioned(
                left: hourLabelWidth + dayIndex * dayWidth,
                top: hourHeight + (c.startHour - startHour) * hourHeight,
                width: dayWidth,
                height: (c.endHour - c.startHour) * hourHeight,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: c.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          c.code, // class code
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          c.title, // class name
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          "${c.startHour}:00 - ${c.endHour}:00", // start-end time
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        Text(
                          c.room, // room number
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          c.lecturer, // lecturer name
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),)
      ),
    );
  }
}
