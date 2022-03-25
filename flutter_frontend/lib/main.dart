import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sheets_items/Person/Person.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'Person/PersonCard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Person>>? responses;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responses = fetchData();
  }

  Future<List<Person>> fetchData() async {
    var rawData = await http.get(Uri.parse('https://ng3jzv.deta.dev/data'));
    if (rawData.statusCode == 200) {
      List<dynamic> json = jsonDecode(rawData.body);
      return json.map((e) => Person.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load persons');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    double width=MediaQuery.of(context).size.width - 100;
    int widthCard = 650;

    int countRow = max(width~/widthCard, 1);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Person>>(
        future: responses,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:

              if (snapshot.data != null){
                return Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: SizedBox(
                    //width: countRow * 650,
                    child: SingleChildScrollView(
                      child: StaggeredGrid.count(
                        //childAspectRatio: (600 / 250),
                        mainAxisSpacing: 25,
                        crossAxisCount: 2,
                        children: snapshot.data?.map((e) =>
                            StaggeredGridTile.fit(
                                crossAxisCellCount: 2,
                                child: PersonCard(e)
                            )).toList() ?? [],
                      ),
                    ),
                  ),
                );
              } else {
                return Text('Не удалось загрузить данные.' + snapshot.error.toString());
              }
            default:
              return Text(snapshot.connectionState.name);

          }
        }
      ),
    );
  }
}
