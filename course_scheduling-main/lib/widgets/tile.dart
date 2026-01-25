import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const Tile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon
    });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6)

          )
        ]
      ),
      // width: 100,
      // height: 50,

      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

            Row(
            children: [
              Icon(icon, color: Colors.blue.shade400, size: 24,),
              SizedBox(width:12),
              Text(

                title,
                style: TextStyle(
                  fontSize:  13,
                  color: Colors.grey.shade600,
                  ),
                )
            ]
          ,),
          SizedBox(height: 8,),
          Text(
            subTitle,
            style: TextStyle(
              fontSize:  16,
                  fontWeight: FontWeight.w600

              ),


          )





        ],
      ),

    );
  }
}
