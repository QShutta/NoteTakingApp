import 'package:flutter/material.dart';
import 'package:note_taking_tpp3/AddNote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextDirection mytextDirection = TextDirection.ltr;
  List myL = [
    "Lorn Ipsum Lorn Ipsum 0 ",
    "Lorn Ipsum Lorn Ipsum 1 ",
    "Lorn Ipsum Lorn Ipsum  2",
    "Lorn Ipsum Lorn Ipsum  3",
    "Lorn Ipsum Lorn Ipsum  4 ",
  ];
  int count = 5;
  @override
  void initState() {
    count = myL.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectVal = false;
    // return Directionality(
    // textDirection: mytextDirection,
    // child:
    var titleColor = Colors.grey[150];
    var subTitlColor = Colors.grey;
    var tralignColor = Colors.grey;

    return Directionality(
      textDirection: mytextDirection,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
                return AddNote();
              }));
            }),
        appBar: AppBar(
          title: Text("Home Page"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (mytextDirection == TextDirection.ltr) {
                      mytextDirection = TextDirection.rtl;
                    } else {
                      mytextDirection = TextDirection.ltr;
                    }
                  });
                },
                icon: Icon(Icons.language))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: count,
              itemBuilder: (builder, i) {
                return Dismissible(
                  key: Key('$i'),
                  child: Card(
                    child: ListTile(
                      selectedColor: Colors.blue,
                      onTap: () {
                        setState(() {});
                      },
                      selectedTileColor: Colors.blue,
                      selected: selectVal,
                      title: Text("Title"),
                      tileColor: titleColor,
                      subtitle: Text(
                        "${myL[i]}",
                        style: TextStyle(color: subTitlColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: tralignColor,
                        ),
                        onPressed: () {},
                      ),
                      leading: Icon(Icons.book),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
