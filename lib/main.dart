import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r312/screens/box_picker.dart';

const bool DEBUG = false; // Set this to false to hide the navigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r312',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.yellow, // Yellow accents
          secondary: Colors.yellow, // Dark gray background
          surface: Colors.grey[850]!, // Slightly lighter gray for surfaces
        ),
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const R312Scaffold(),
    );
  }
}

class R312Scaffold extends StatefulWidget {
  const R312Scaffold({super.key});

  @override
  // ignore: library_private_types_in_public_api (for now)
  _R312ScaffoldState createState() => _R312ScaffoldState();
}

class _R312ScaffoldState extends State<R312Scaffold> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Box Picker',
      'icon': Icons.add_box,
      'widget': BoxPicker(addPage: _addPage),
    },
  ];

  void _addPage(Map<String, dynamic> newPage) {
    setState(() {
      _pages.add(newPage);
      _selectedIndex = _pages.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          if (DEBUG) // Show navigation only if DEBUG is true
            SizedBox(
              width: 50, // Set width for NavigationRail
              child: NavigationRail(
                leading: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState
                            ?.openDrawer(); // Open the left drawer
                      },
                    ),
                  ],
                ),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: List.generate(
                  _pages.length,
                  (index) => NavigationRailDestination(
                    icon: Icon(_pages[index]['icon'] as IconData?),
                    selectedIcon: Icon(_pages[index]['icon'] as IconData),
                    label: Text(_pages[index]['title'] as String),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Navigator(
              onGenerateRoute: (settings) {
                if (settings.name == '/') {
                  return MaterialPageRoute(
                    builder:
                        (context) =>
                            _pages[_selectedIndex]['widget'] is BoxPicker
                                ? BoxPicker(
                                  addPage: _addPage,
                                ) // Pass _addPage to BoxPicker
                                : _pages[_selectedIndex]['widget'] as Widget,
                  );
                }
                return null;
              },
              // onPopPage: (route, result) {
              //   if (result != null && result is Map<String, dynamic>) {
              //     _addPage(result);
              //   }
              //   return route.didPop(result);
              // },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        // Drawer remains on the left
        child: ListView(
          children: [
            ...List.generate(
              _pages.length,
              (index) => ListTile(
                leading: Icon(_pages[index]['icon'] as IconData?),
                title: Text(_pages[index]['title'] as String),
                selected: _selectedIndex == index,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
