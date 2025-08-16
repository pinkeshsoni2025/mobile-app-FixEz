class User {
  final String refreshToken;
  final String username;
  final String email;
  final String roles;
  final String location;
  final String name;
  final String accessToken;
  final String tokenType;
  final int isActive;

  const User({
    required this.refreshToken,
    required this.username,
    required this.email,
    required this.roles,
    required this.location,
    required this.name,
    required this.accessToken,
    required this.tokenType,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'refreshToken': String refreshToken,
        'username': String username,
        'email': String email,
        'roles': String roles,
        'location': String location,
        'name': String name,
        'accessToken': String accessToken,
        'tokenType': String tokenType,
        'isActive': int isActive,
      } =>
        User(
          refreshToken: refreshToken,
          username: username,
          email: email,
          roles: roles,
          location: location,
          name: name,
          accessToken: accessToken,
          tokenType: tokenType,
          isActive: isActive,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}


/* itemBuilder: (context, index) {
        var info = categories[index].icon;
        return ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              key: ValueKey(categories[index].id),
              margin: const EdgeInsets.all(10),
              color:
                  (index % 2 == 0)
                      ? Color.fromARGB(255, 244, 226, 218)
                      : Color.fromARGB(255, 236, 221, 238),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 1,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          IconData(
                            int.parse(info!),
                            fontFamily: 'MaterialIcons',
                          ),
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        categories[index].name,
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          categories[index].sub_category.join(", "),
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      //Text(int.parse(info) as String),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },*/

      /*IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'User account',
            onPressed: () {
              if (usernameStorage != null && usernameStorage.isNotEmpty) {
                // User already logged in
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              } else {
                // No login data found, go to Login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginApp()),
                );
              }
            },
          ),*/

          /* @override
  Widget build(BuildContext context) {
    return CarouselView(
      itemExtent: 330,
      shrinkExtent: 200,
      children:
          CategoryInfo.values.map((CategoryInfo info) {
            var sizedBox = SizedBox(
              child: Center(
                child: Text(
                  info.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
            );
            return ColoredBox(
              color: info.backgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(info.icon, color: info.color, size: 32.0),
                    sizedBox,
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }*/

   /* ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height / 8),
          child: CarouselView.weighted(
            controller: controller,
            itemSnapping: true,
            flexWeights: const <int>[1, 7, 1],
            children: <Widget>[CurrentTime()],
          ),
        ),*/

        /* const Padding(
          padding: EdgeInsetsDirectional.only(top: 8.0, start: 8.0),
          child: Text('Multi-browse layout'),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 50),
          child: CarouselView.weighted(
            flexWeights: const <int>[1, 2, 3, 2, 1],
            consumeMaxWeight: false,
            children: List<Widget>.generate(20, (int index) {
              return ColoredBox(
                color: Colors.primaries[index % Colors.primaries.length]
                    .withOpacity(0.8),
                child: const SizedBox.expand(),
              );
            }),
          ),
        ),*/

     /*   enum CategoryInfo {
  electronic(
    'Electronic',
    Icons.iron_outlined,
    Color.fromARGB(255, 32, 89, 223),
    Color.fromARGB(255, 235, 236, 239),
  ),
  plumber(
    'Plumber',
    Icons.plumbing_outlined,
    Color.fromARGB(255, 252, 194, 5),
    Color.fromARGB(255, 245, 244, 242),
  ),
  furniture(
    'Furniture Assemble ',
    Icons.chair_alt_outlined,
    Color.fromARGB(255, 238, 95, 38),
    Color.fromARGB(255, 245, 241, 240),
  ),
  painting(
    'Painting',
    Icons.brunch_dining_outlined,
    Color.fromARGB(255, 113, 255, 4),
    Color.fromARGB(255, 244, 245, 243),
  ),
  construction(
    'Construction',
    Icons.all_inbox_outlined,
    Color.fromARGB(255, 149, 6, 244),
    Color.fromARGB(255, 245, 246, 247),
  ),
  carpainter(
    'Car Painter',
    Icons.add_business_outlined,
    Color.fromARGB(255, 4, 127, 250),
    Color.fromARGB(255, 243, 243, 243),
  );

  const CategoryInfo(this.label, this.icon, this.color, this.backgroundColor);
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}
*/