import 'dart:convert';
import 'package:alpha_easy_fix/models/help_model.dart';
import 'package:alpha_easy_fix/services/help_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HelpList extends StatelessWidget {
  const HelpList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: FutureBuilder<List<Help>>(
        future: loadHelpData(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final helpList = snapshot.data!;
          return ListView.builder(
            itemCount: helpList.length,
            itemBuilder: (context, index) {
              final category = helpList[index];
              return ExpansionTile(
                title: Text(category.category),
             tilePadding:EdgeInsets.only(top: 10,right: 10,bottom: 10,left: 15),
             collapsedBackgroundColor: Color.fromRGBO(35, 132, 215, 1),
             collapsedTextColor: Colors.white,
             collapsedIconColor: Colors.white,
            // textColor: Color.fromRGBO(35, 132, 215, 1),
             initiallyExpanded:true,
             iconColor: Color.fromRGBO(35, 132, 215, 1),
                children: category.faqs.map((faq) {
                  return ListTile(
                    title: Text(faq.question, style: const TextStyle(color: Color.fromRGBO(35, 132, 215, 1))),
                      subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(faq.answer),
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
