import 'package:alpha_easy_fix/login_app.dart';
import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context, heading, message) {
  return showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 170,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(35, 132, 215, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        //IconData(0xe760, fontFamily: 'MaterialIcons'),
                        Icons.emoji_emotions_outlined,
                        size: 40,
                        color: Color.fromRGBO(35, 132, 215, 1),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Text(
                          //'Congratulations!',
                          heading,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Text(
                          //'You have successfully registered.',
                          message,
                          maxLines: 2,
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                        //  Navigator.pop(context);
                          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginApp(),
          ),
        );
                        },

                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
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
  );
}

class RatingWidget extends StatelessWidget {
  final int rating;
  final Color filledColor;
  final Color unfilledColor;
  final double size;
  final int maxStars;

  const RatingWidget({
    Key? key,
    required this.rating,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
    this.size = 18.0,
    this.maxStars = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        return Icon(
          Icons.star,
          color: index < rating ? filledColor : unfilledColor,
          size: size,
        );
      }),
    );
  }
}
