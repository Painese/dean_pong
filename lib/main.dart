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
        ),
        home: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return auth.isAuth ? BoardScreen() :
            FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
              authResultSnapshot.connectionState ==
                  ConnectionState.waiting
                  ? Text('Hi')
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
      // TODO: when login screen is ready move this method into the build method - to the "future" property of the FutureBuilder (instead of the auth.tryLogin method).
      Provider.of<Board>(context, listen: false).initialize();
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
