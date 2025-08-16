import 'package:flutter/material.dart';
import 'package:alpha_easy_fix/models/category_model.dart';
import 'package:alpha_easy_fix/services/category_services.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CategoryList> {
  final CarouselController controller = CarouselController(initialItem: 1);

  late Future<List<Category>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = readJson();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('An error has occurred!'));
        } else if (snapshot.hasData) {
          return CategoriesList(categories: snapshot.data!);
        } else {
          return const Center(child: LinearProgressIndicator());
        }
      },
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key, required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    var IconList = {
      "Electronic": Icons.blender_outlined,
      "Plumber": Icons.plumbing_outlined,
      "Elevation": Icons.window_outlined,
      "Construction": Icons.construction_outlined,
      "Furniture": Icons.bed_outlined,
      "Painting":Icons.brush_outlined,
    };
    return CarouselView(
      itemExtent: 270,
      shrinkExtent: 240,
      children:
          categories.map((Category info) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(35, 132, 215, 1),
                  child: Icon(
                    //IconData(0xe760, fontFamily: 'MaterialIcons'),
                    IconList[info.name],
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                Text(
                  info.name,
                  style: TextStyle(
                    color: Color.fromRGBO(35, 132, 215, 1),
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 8,
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(35, 132, 215, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        info.sub_category.join(", "),
                        maxLines: 2,
                        style: TextStyle(
                          color: Color.fromRGBO(35, 132, 215, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),

    );
  }
}

