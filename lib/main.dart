import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '扫码测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel eventChannel =
      const EventChannel('bg7lgb/scan_event');

  //List<String> items;
  var items = new List<String> ();

  FocusNode _focusNode =  FocusNode();

  DateTime _startTime, _endTime;

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    _endTime = DateTime.now();
    if (_startTime != null){
      var diffTime = _endTime.difference(_startTime);
      _startTime = null;
      print(event.toString());
    setState(() {
      items.insert(0, "${event.toString()}  ${diffTime.inMilliseconds} ms");
    });
    } else {
      print(event.toString());
      setState(() {
        items.insert(0, "${event.toString()}  ");
      });
    }


  }

  void _onError(Object error) {
    setState(() {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: items.length,
        itemBuilder: buildItem),
      floatingActionButton: new FloatingActionButton(
          onPressed: deleteAllItems,
          child: new Icon(Icons.clear)),);
  }

  Widget buildItem(BuildContext context, int index) {
    //if (index.isOdd) return new Divider();
    FocusScope.of(context).requestFocus(_focusNode);

    return RawKeyboardListener(
      onKey: handleKey,
      focusNode: _focusNode,
      child: Padding(padding: const EdgeInsets.all(3.0),
      child: Text(items[index]),),
    );
  }

  void deleteAllItems() {
    setState(() {
      items.clear();
    });
  }

  handleKey(RawKeyEvent key) {
//   handleKey(KeyEvent key) {
//    print("key: ${key.keyCode.toString()}");
  final c6000 = 139;
  final v8 = 284;
  final d8 = 164;

    print("key type: ${key.runtimeType.toString()}");
    if (key.runtimeType.toString() == 'RawKeyDownEvent') {
      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      var _keyCode = data.keyCode; //keycode of key event (66 is return)
      print("key code: $_keyCode");
      if (_keyCode == c6000 || _keyCode == v8 || _keyCode == d8) _startTime = DateTime.now();
    }
  }
}
