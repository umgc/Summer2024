import 'package:flutter/material.dart';
import 'package:mindinsync/BottomNavigation.dart';
import 'package:mindinsync/Drawer.dart';
import 'package:mindinsync/StorageService.dart';
import 'package:search_page/search_page.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Person implements Comparable<Person> {
  final String name, surname;
  final num age;

  const Person(this.name, this.surname, this.age);

  @override
  int compareTo(Person other) => name.compareTo(other.name);
}

class Transcript implements Comparable<Transcript> {
  String name = "";
  List<String> keywords = [];
  int id = 0;
  String date = "";

  Transcript(this.name, this.keywords, this.id, this.date);

  int compareTo(Transcript other) => name.compareTo(other.name);
}

void main() => runApp(const Search());

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

var scripts;

class _SearchState extends State<Search> {
  var tran_store;
  var transcriptValues = [];

  @override
  void initState() {
    super.initState();
    tran_store = StorageService();
    loadTranscripts();
    // Load existing profile data here if available
  }

  void loadTranscripts() async {
    scripts = await tran_store.getTranscripts();
    var transcript;
    for (int i = 0; i < scripts.length; i++) {
      transcript = Transcript(
          scripts[i]['transcript_name'],
          scripts[i]['keywords'].split(", "),
          scripts[i]['transcript_id'],
          scripts[i]['created_at']);
      //transcriptValues.add(transcript);
      setState(() {
        transcriptValues.add(transcript);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Past Conversations'),
        backgroundColor: Colors.blue[300],
      ),
      body: ListView.builder(
        itemCount: transcriptValues.length,
        itemBuilder: (context, index) {
          final transcript = transcriptValues[index];

          return ListTile(
              title: Text(transcript.name),
              subtitle: Text(transcript.keywords.toString()),
              trailing: Text(transcript.date),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/Detail',
                  arguments: transcript.id,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search transcripts',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage(
            onQueryUpdate: print,
            items: transcriptValues,
            searchLabel: 'Search transcripts',
            suggestion: const Center(
              child: Text('Search for a specific Conversation'),
            ),
            failure: const Center(
              child: Text('No results found'),
            ),
            filter: (transcript) => [
              transcript.name,
              transcript.keywords.toString(),
            ],
            sort: (a, b) => a.compareTo(b),
            builder: (transcript) => ListTile(
                title: Text(transcript.name),
                subtitle: Text(transcript.keywords.toString()),
                trailing: Text(transcript.date),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/Detail',
                    arguments: transcript.id,
                  );
                }),
          ),
        ),
        child: const Icon(Icons.search),
      ),
      drawer: const DrawerMenu(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index for the Home screen
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/Search');
              break;
            case 2:
              Navigator.pushNamed(context, '/knowledge_base');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
