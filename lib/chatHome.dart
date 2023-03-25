import 'package:flutter/material.dart';
import 'package:note_taking_tpp3/AddNote.dart';

class NoteList extends StatefulWidget {
  // const NoteList({Key key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  TextDirection mytextDirection = TextDirection.ltr;
  List<String> noteTitles = [
    "Lorn Ipsum Lorn Ipsum 0 ",
    "Lorn Ipsum Lorn Ipsum 1 ",
    "Lorn Ipsum Lorn Ipsum  2",
    "Lorn Ipsum Lorn Ipsum  3",
    "Lorn Ipsum Lorn Ipsum  4 ",
  ];
  int count = 5;
  final double _padding = 8.0;
  final Color? _titleColor = Colors.grey[150];
  final Color _subtitleColor = Colors.grey;
  final Color _trailingColor = Colors.grey;

  @override
  void initState() {
    count = noteTitles.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool selected = false;

    return Directionality(
        textDirection: mytextDirection,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return AddNote();
                }));
              },
            ),
            appBar: AppBar(
              title: Text("ChatGpt Note List"),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      mytextDirection = (mytextDirection == TextDirection.ltr)
                          ? TextDirection.rtl
                          : TextDirection.ltr;
                    });
                  },
                  icon: Icon(Icons.language),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(_padding),
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('$index'),
                    child: Card(
                      child: ListTile(
                        selectedColor: Colors.blue,
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                        selectedTileColor: Colors.blue,
                        selected: selected,
                        title: Text("Title"),
                        tileColor: _titleColor,
                        subtitle: Text(
                          "${noteTitles[index]}",
                          style: TextStyle(color: _subtitleColor),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: _trailingColor,
                          ),
                          onPressed: () {},
                        ),
                        leading: Icon(Icons.book),
                      ),
                    ),
                  );
                },
              ),
            )));
  }
}
