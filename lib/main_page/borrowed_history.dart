import 'package:flutter/material.dart';
import '../assets.dart';

class BorrowedHistory extends StatelessWidget{
  const BorrowedHistory({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: const Text(
          "Borrowed History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        // const SizedBox(height: 16),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Today, Tommorrow",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                )
              ),  
            ),
            Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12), 
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(children: [
                          Text(
                          "SAMPLE",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),

                        ),
                        ],),
                        SizedBox(height: 4),
                        Text(
                          "Title: ",
                          // style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Author: ",
                         ),
                        const SizedBox(height: 2),
                        Text(
                          "Location: ",
                         ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: const Text(
                            "DATE HERE!",
                            style: TextStyle(
                              fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: AppColors.primaryGreen
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
        ),
      ),
    );
  }
}