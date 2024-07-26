import 'package:flutter/material.dart';
import 'package:mindinsync/StorageService.dart';

class TranscriptionDetails extends StatefulWidget {
  const TranscriptionDetails({super.key});
  @override
  State<StatefulWidget> createState() => _TranscriptionDetailstate();
}

class _TranscriptionDetailstate extends State<TranscriptionDetails> {
  StorageService tran_store = new StorageService();
  List<Map<String, dynamic>> transcription = [
    {
      'summarization': '',
      'transcript_content': '',
      'keywords': '',
      'transcript_name': ''
    }
  ];
  var isLoaded = false;
  List<String> keywords = [];
  List<String> transcript = [];
  List<String> speakers = [
    "Username",
    "Speaker 2",
    "Speaker 3",
    "Speaker 4",
    "Speaker 5",
    "Speaker 6"
  ];
  String summary = "";

  @override
  void initState() {
    super.initState();

    // Load existing profile data here if available
  }

  @override
  Widget build(BuildContext context) {
    loadTranscript();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(         
          title: FittedBox(
            fit: BoxFit.fill,
            child: Text(transcription[0]['transcript_name'])),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'Transcription'),
              Tab(text: 'Keywords'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Container(
              height: 100,
              constraints: BoxConstraints(maxHeight: 100),
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              //color: Colors.amber[600],
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(summary),
            )),
            Container(
              child: new ListView.builder(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: transcript.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return new Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      //color: Colors.amber[600],
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(transcript[Index]),
                    );
                  }),
            ),
            Container(
              child: new ListView.builder(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: keywords.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return new Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      //color: Colors.amber[600],
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(keywords[Index]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void loadTranscript() async {
    if (!isLoaded) {
      var args = ModalRoute.of(context)!.settings.arguments as int?;
      transcription = await tran_store.getTranscript(args!);
      //print(transcription[0]['keywords']);
      //test = "now";
      keywords = transcription[0]['keywords'].split(", ");
      var transcriptbasic = transcription[0]['transcript_content']
          .replaceAll("[", "")
          .replaceAll("]", "");
      var tempscript;
      var index = 0;
      var found = false;
      transcript = transcriptbasic.split(":");
      for (int i = 1; i < transcript.length - 1; i++) {
        for (int j = 0; j < speakers.length; j++) {
          if (transcript[i].endsWith(speakers[j])) {
            found = true;
            index = transcript[i].indexOf(speakers[j]);
            tempscript = transcript[i].substring(0, index - 2);
            transcript[i - 1] += ": " + tempscript;
            transcript[i] = transcript[i].substring(index);
          }
        }
        index = transcript[i].lastIndexOf(" ");
        if (!found && index > 1) {
          tempscript = transcript[i].substring(0, index - 2);
          transcript[i - 1] += ": " + tempscript;
          transcript[i] = transcript[i].substring(index);
        }
        found = false;
      }
      transcript[transcript.length - 2] +=
          ": " + transcript[transcript.length - 1];
      transcript.length = transcript.length - 1;
      summary = transcription[0]['summarization'];
      setState(() {});
    }
    isLoaded = true;
  }
}
