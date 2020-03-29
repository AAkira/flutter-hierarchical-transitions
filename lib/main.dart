import 'package:flutter/material.dart';
import 'package:listtransition/detail.dart';
import 'package:listtransition/dummy.dart';

const int TRANSITION_DURATION = 600;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hierarchical transitions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(
        title: 'Hierarchical transitions',
        list: PHONETIC_CODES,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key key, this.title, this.list}) : super(key: key);

  final String title;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Hero(
            tag: 'list$index',
            child: Card(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder<DetailPage>(
                      opaque: false,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child:
                              DetailPage(title: list[index], tag: 'list$index'),
                        );
                      },
                      transitionDuration:
                          const Duration(milliseconds: TRANSITION_DURATION),
                    ),
                  );
                },
                child: Padding(
                  child: Text(
                    list[index],
                    style: const TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(24.0),
                ),
              ),
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
