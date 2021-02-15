import 'package:bp_monitor/models/BloodPressureData.dart';
import 'package:bp_monitor/screens/AddDataScreen.dart';
import 'package:bp_monitor/screens/ViewDB.dart';
import 'package:bp_monitor/screens/ViewDataScreen.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.redAccent,
        primaryColor: Colors.red,
      ),
      initialRoute: 'home',
      routes: {'home': (_) => HomePage(), 'view_db': (_) => ViewDB()},
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _screens = [ViewDataScreen(), AddDataScreen()];

  void _handlePopupClick(String id) {
    switch (id) {
      case 'clear_db':
        _handleDeleteDBRequest();
        break;
      case 'view_data':
        _handleViewDataRequest();
    }
  }

  void _handleDeleteDBRequest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure you want to clear the database?'),
        content: Text('This will delete all entries'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              BPDataProvider _provider = BPDataProvider();
              await _provider.open(Constants.DB_PATH);
              setState(() {
                _provider.dropTable();
              });
              await _provider.close();
              Navigator.pop(context);
            },
            child: Text('Clear Database'),
          ),
        ],
      ),
    );
  }

  void _handleViewDataRequest() {
    Navigator.pushNamed(context, 'view_db');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Monitor'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handlePopupClick,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'view_data',
                  child: Text('View Data'),
                ),
                PopupMenuItem<String>(
                  value: 'clear_db',
                  child: Text('Clear Database'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart_sharp), label: 'View Data'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Data')
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
