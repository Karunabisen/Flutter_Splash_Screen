import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int m = 0;
  int n = 0;
  List<List<String>> grid = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Search App'),
        centerTitle:true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter the number of rows (m)',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    m = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter the number of columns (n)',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    n = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    grid = createGrid(m, n);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Create Grid',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Enter text to search in the grid',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String searchText = searchController.text;
                  SearchResult result = searchTextInGrid(grid, searchText);

if (result.found) {
                    highlightText(result.startRow, result.startCol, result.direction, searchText);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Text found!'),
                          content: Column(
                            children: [
                              Text('Highlighted Grid:'),
                              SizedBox(height: 10),
                              displayGrid(grid),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Text not found in the grid.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Search Text',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<List<String>> createGrid(int rows, int cols) {
    List<String> alphabets = "abcdefghijklmnopqrstuvwxyz".split('');
    return List.generate(rows, (i) => List.generate(cols, (j) => alphabets[j % alphabets.length]));
  }

  SearchResult searchTextInGrid(List<List<String>> grid, String text) {
    List<List<int>> directions = [
      [0, 1], // East
      [1, 0], // South
      [1, 1], // South-East
    ];

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        for (var dir in directions) {
          bool found = true;
          for (int k = 0; k < text.length; k++) {
            int x = i + k * dir[0];
            int y = j + k * dir[1];

            if (x < 0 || x >= grid.length  || y < 0  || y >= grid[0].length  || grid[x][y] != text[k]) {
              found = false;
              break;
            }
          }
          if (found) {
            return SearchResult(true, i, j, dir);
          }
        }
      }
    }
    return SearchResult(false, -1, -1, []);
  }

  void highlightText(int startRow, int startCol, List<int> direction, String text) {
    for (int k = 0; k < text.length; k++) {
      int x = startRow + k * direction[0];
      int y = startCol + k * direction[1];
      grid[x][y] = grid[x][y].toUpperCase();
    }
  }

  Widget displayGrid(List<List<String>> grid) {
    return Column(
      children: grid.map((row) {
        return Row(
          children: row.map((cell) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(),
                color: cell == cell.toUpperCase()? Colors.green: null,
              ),
              child: Text(cell),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class SearchResult {
  bool found;
  int startRow;
  int startCol;
  List<int> direction;

  SearchResult(this.found, this.startRow, this.startCol, this.direction);
}
