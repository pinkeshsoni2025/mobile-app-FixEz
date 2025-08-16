import 'package:alpha_easy_fix/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:alpha_easy_fix/category_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CarouselExampleApp();
  }
}

class CarouselExampleApp extends StatelessWidget {
  const CarouselExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CarouselExample();
  }
}

class CarouselExample extends StatelessWidget {
  final CarouselController controller = CarouselController(initialItem: 1);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height / 5),
          child: CarouselView.weighted(
            controller: controller,
            itemSnapping: true,
            flexWeights: const <int>[1, 7, 1],
            children:
                ImageInfo.values.map((ImageInfo image) {
                  return HeroLayoutCard(imageInfo: image);
                }).toList(),
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 10.0, start: 0),
          child: ColoredBox(
            color: Color.fromRGBO(35, 132, 215, 1),
            child: Center(
              child: Text(
                'Our Services',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 7.0, start: 1.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height / 5.3),
            child: CategoryList(),
          ),
        ),
        SizedBox(height: 0),
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 5.0, start: 0),
          child: ColoredBox(
            color: Color.fromRGBO(35, 132, 215, 1),
            child: Center(
              child: Text(
                'Customers Feedback',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),

        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: CarouselView(
            itemExtent: 330,
            shrinkExtent: 290,
            children:
                CustomerFeedback.values.map((CustomerFeedback feedback) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(35, 132, 215, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: CustomersFeedback(
                      id: feedback.id,
                      userId: feedback.userId,
                      name: feedback.name,
                      message: feedback.message,
                      rating: feedback.rating,
                    ),
                  );
                }).toList(),
          ) 
        ),
        ColoredBox(
          color:Colors.green,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RatingWidget(rating: 5, size: 18, filledColor: Colors.white,),
                  Text(
                    "1.2k",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UtilityButton(icon: Icons.announcement_sharp, label: 'Call Us'),
                UtilityButton(icon: Icons.mail_outline_sharp, label: 'Mail'),
                UtilityButton(icon: Icons.location_on, label: 'Location'),
                UtilityButton(icon: Icons.analytics_outlined, label: 'Web'),
              ],
            ),

            const Text(
              "FixEz v1.0.2 • Made in India",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class HeroLayoutCard extends StatelessWidget {
  const HeroLayoutCard({super.key, required this.imageInfo});

  final ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        ClipRect(
          child: OverflowBox(
            maxWidth: width * 7 / 8,
            minWidth: width * 7 / 8,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/${imageInfo.url}'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                imageInfo.title,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                imageInfo.subtitle,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}

class _CustomersFeedback extends StatelessWidget {
  const _CustomersFeedback({
    required this.id,
    required this.userId,
    required this.name,
    required this.message,
    required this.rating,
  });

  final int id;
  final int userId;
  final String name;
  final String message;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),

        Text(
          message,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        Padding(padding: EdgeInsets.all(10)),
RatingWidget(rating: rating,size: 18,filledColor: Colors.green,),
       

        //  Text(id, style: const TextStyle(fontSize: 12.0, color: Colors.black87)),
      ],
    );
  }
}

class CustomersFeedback extends StatelessWidget {
  const CustomersFeedback({
    super.key,
    required this.id,
    required this.userId,
    required this.name,
    required this.message,
    required this.rating,
  });

  final int id;
  final int userId;
  final String name;
  final String message;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                child: _CustomersFeedback(
                  id: id,
                  userId: userId,
                  name: name,
                  message: message,
                  rating: rating,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ImageInfo {
  image0('FixEz', 'FixEz | Electronic', 'banner_1.jpg'),
  image1('FixEz', 'FixEz | Plumber', 'banner_2.jpg'),
  image2('FixEz', 'FixEz | Feedback', 'banner_3.jpg'),
  image3('FixEz', 'FixEz | Painter', 'banner_4.jpg'),
  image4('FixEz', 'FixEz | Construction', 'banner_5.jpg'),
  image5('FixEz', 'FixEz | Assemble', 'banner_6.jpg');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}

enum CustomerFeedback {
  feedback1(
    id: 4,
    userId: 5,
    name: "Somyanth",
    message:
        "Your promptness in addressing concerns is commendable. It shows that you care about the team’s well-being and the quality of our work.",
    rating: 5,
  ),
  feedback2(
    id: 4,
    userId: 7,
    name: "Kelly",
    message:
        "I appreciate your transparency when it comes to company decisions. It helps us understand the bigger picture and how our work contributes to overall goals",
    rating: 5,
  ),
  feedback3(
    id: 4,
    userId: 7,
    name: "Tristarn",
    message:
        "It helps us understand the bigger picture and how our work contributes to overall goals",
    rating: 4,
  );

  const CustomerFeedback({
    required this.id,
    required this.userId,
    required this.name,
    required this.message,
    required this.rating,
  });

  final int id;
  final int userId;
  final String name;
  final String message;
  final int rating;
}

class UtilityButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const UtilityButton({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          // Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
