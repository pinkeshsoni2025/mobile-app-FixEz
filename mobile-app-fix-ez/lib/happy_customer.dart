import 'package:alpha_easy_fix/dialog_builder.dart';
import 'package:alpha_easy_fix/models/feedback_model.dart';
import 'package:alpha_easy_fix/services/feedback_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HappyCustomerList extends StatelessWidget {
  const HappyCustomerList({super.key});

  @override
  Widget build(BuildContext context) {
    var IconList = {
      "Electronic": Icons.blender_outlined,
      "Plumber": Icons.plumbing_outlined,
      "Elevation": Icons.window_outlined,
      "Construction": Icons.construction_outlined,
      "Furniture": Icons.bed_outlined,
      "Painting": Icons.brush_outlined,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Happy Customer')),
      body: FutureBuilder<List<HappyCustomer>>(
        future: loadFeedbackData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final feedbackList = snapshot.data!;

          return ListView.builder(
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final feedback = feedbackList[index];
              final totalCustomer = feedback.totalCustomer;
              final totalRating = feedback.totalRaiting;
              final int averageRating = (totalRating / totalCustomer).floor();
              var numberFormat = NumberFormat.compact(
                locale: "en_US",
                explicitSign: false,
              );
              var totalCustomerShort = numberFormat.format(totalCustomer);
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(35, 132, 215, 1),

                          child: Icon(
                            //IconData(0xe760, fontFamily: 'MaterialIcons'),
                            IconList[feedback.category],
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          feedback.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20.0,
                            // color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingWidget(rating: averageRating, size: 15),
                        Text(
                          "[$averageRating/$totalCustomerShort]",
                          style: TextStyle(color:Colors.grey, fontSize: 12)
                        ),
                      ],
                    ),
                  ],
                ),
                //Text(feedback.category),
                tilePadding: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  bottom: 10,
                  left: 15,
                ),
                collapsedBackgroundColor: Color.fromRGBO(35, 132, 215, 1),
                collapsedTextColor: Colors.white,
                collapsedIconColor: Colors.white,
                // textColor: Color.fromRGBO(35, 132, 215, 1),
                initiallyExpanded: true,
                iconColor: Color.fromRGBO(35, 132, 215, 1),
                children:
                    feedback.feedbacks.map((feedback) {
                      DateTime dateTime = DateTime.parse(feedback.createdAt);
String createdAtFormat = DateFormat("dd/MMM/yy hh:mmA").format(dateTime);
                      return Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (feedback.name).toUpperCase(),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(35, 132, 215, 1),
                                    ),
                                  ),
                                  RatingWidget(rating: feedback.rating, size: 15,),
                                ],
                              ),

                              Text(createdAtFormat, style: TextStyle(color:Colors.grey, fontSize: 12)),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              feedback.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
