import 'package:dean_pong/models/boardState.dart';
import 'package:dean_pong/services/firebaseService.dart';
import 'package:dean_pong/services/firebaseService.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Board(),
        )
      ],
      child: MaterialApp(
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
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _didLoad = false;
  Color _btnColor = Colors.purple;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      Provider.of<Board>(context, listen: false).setBoard();
      _didLoad = true;
    }
  }

  void _incrementCounter(Board board) {
    _toggleBoardState(board);
    setState(() {
      _counter++;
    });
  }

  void _toggleBoardState(Board board) {
    final newState = board.boardDetails.state == BoardState.free ? BoardState.matchInProgress : BoardState.free;
    Color newColor;

    board.setBoardState(newState).then( (_) {
      if (newState == BoardState.free) {
        newColor = Colors.green;
      } else {
        newColor = Colors.red;
      }
      setState(() {
        _btnColor = newColor;
      });
    }).catchError((error) {
      print(error.toString());
      setState(() {
        _btnColor = Colors.yellow;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(board),
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: _btnColor,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
