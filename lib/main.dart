import 'package:dean_pong/models/boardState.dart';
import 'package:dean_pong/providers/auth.dart';
import 'package:dean_pong/screens/auth_screen.dart';
import 'package:dean_pong/screens/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Board(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
//          primaryColor: Color.fromRGBO(191, 0, 0, 1),
//          accentColor: Color.fromRGBO(0, 0, 0, 1),
        ),
        home: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return auth.isAuth ? BoardScreen() :
            FutureBuilder(
              // TODO: removethe "hi" text widget.
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState ==
                  ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator(),)
                  : AuthScreen(),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _btnColor = Colors.purple;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _incrementCounter(Board board) {
    _toggleBoardState(board);
    setState(() {
      _counter++;
    });
  }

  void _toggleBoardState(Board board) {

  }

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (ctx, authResultSnapshot) {
            return authResultSnapshot.connectionState == ConnectionState.waiting ?
            Center(child: CircularProgressIndicator()) :
            Column(
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
            );
          },
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
