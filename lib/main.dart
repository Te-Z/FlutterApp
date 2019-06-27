import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.green,
        backgroundColor: Colors.green,
        scaffoldBackgroundColor: Colors.green
      ),
      home: RandomWords(),
    );
  }
}


// Persiste durant le cycle de vie du widget
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.white);
  final Set<WordPair> _saved = Set<WordPair>();

  // this method generate the word pairs
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(

      MaterialPageRoute<void>(
        builder: (BuildContext context) {

          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );

          final List<Widget> divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        /*
         * The itemBuilder callback is called once per suggested word pairing, and places each suggestion into a ListTile row.
         * For even rows, the function adds a ListTile row for the word pairing. For odd rows, the function adds a Divider widget
         * to visually separate the entries. Note that the divider might be difficult to see on smaller devices.
         */

        itemBuilder: (context, i) {
          if(i.isOdd) return Divider(); // Add a one-pixel-high divider widget before each row in the ListView.

          final index = i ~/ 2; // The expression i ~/ 2 divides i by 2 and returns an integer result. For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); // If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon( // Icone qui apparaitra après le titre
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

}


// Création de l'instance de la classe RandomWordsState (immutable)
class RandomWords extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => RandomWordsState();
}
