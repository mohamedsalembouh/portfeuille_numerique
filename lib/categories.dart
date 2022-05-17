import 'package:flutter/material.dart';

class listCategories extends StatefulWidget {
  const listCategories({Key? key}) : super(key: key);

  @override
  State<listCategories> createState() => _listCategoriesState();
}

class _listCategoriesState extends State<listCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.search),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
              title: Text(
            'les categories',
            style: TextStyle(fontSize: 20),
          )),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Achats'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with trailing widget'),
              leading: FlutterLogo(),

              //trailing: FlutterLogo(),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with both widgets'),
            ),
          ),
        ],
      ),
    );
  }
}
