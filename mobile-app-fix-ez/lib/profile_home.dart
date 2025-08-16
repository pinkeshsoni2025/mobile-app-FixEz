import 'package:alpha_easy_fix/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:alpha_easy_fix/category_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProfileHomeApp();
  }
}

class ProfileHomeApp extends StatelessWidget {
  const ProfileHomeApp({super.key});
  static const appTitle = 'FixEz';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: appTitle, home: Dashboard());
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  int _selectedIndex = 0;
  final storage = FlutterSecureStorage();
  bool isLoading = false;
  String nameStorage = '';
  String emailStorage = '';
  String locationStorage = '';
  String roleStorage = '';
  String roleImage = 'customer';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await storage.read(key: 'name');
    //final username = await storage.read(key: 'username');
    final email = await storage.read(key: 'email');
    final location = await storage.read(key: 'location');
    final roles = (await storage.read(key: 'roles'));

    setState(() {
      nameStorage = name ?? '';
      locationStorage = location ?? '';
      emailStorage = email ?? '';
      roleStorage = roles ?? '';
      isLoading = false;
    });
  }

  final CarouselController controller = CarouselController(initialItem: 1);
  @override
  Widget build(BuildContext context) {
    print(roleStorage.contains("ROLE_W"));
    if (roleStorage.contains("ROLE_W")) {
      roleImage = 'worker';
    }
    final double height = MediaQuery.sizeOf(context).height;

    return ListView(
      children: <Widget>[
        
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              /** Card Widget **/
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(35, 132, 215, 1),
                        ),
                      ),
                      Card(
                        surfaceTintColor: Color.fromRGBO(35, 132, 215, 1),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Image(
                            image: AssetImage("assets/images/${roleImage}.png"),
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                      Text(
                        'Hi, ' + nameStorage,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Email:' + emailStorage),
                      SizedBox(height: 16),
                      Text('Location:' + locationStorage),
                      SizedBox(height: 16),
                      Text('Role:' + roleStorage),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ), //Card
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
