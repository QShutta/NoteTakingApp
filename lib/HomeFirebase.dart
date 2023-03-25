import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_tpp3/AddNote.dart';
import 'package:note_taking_tpp3/Login.dart';
import 'package:note_taking_tpp3/UpdateNotePage.dart';
import 'package:note_taking_tpp3/viewNote.dart';

class HomeFirebase extends StatefulWidget {
  const HomeFirebase({super.key});

  @override
  State<HomeFirebase> createState() => _HomeFirebaseState();
}

class _HomeFirebaseState extends State<HomeFirebase> {
  //المتغير دة مستخدمنو عشان نغير اتجاة الكتباة من اليمين لليسار والعكس
  //The default of it is left to right,then when the user hit the button ,the direction will change.
  late TextDirection mytextDirection = TextDirection.ltr;

  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: mytextDirection,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                //When the user hit the floating button it will be taken to the add note page.
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return AddNote();
                }));
              }),
          appBar: AppBar(
            title: Text("Home"),
            centerTitle: true,
            leading: IconButton(
                //This button is to change the text direction ,when the user hit the icon button
                onPressed: () {
                  setState(() {
                    if (mytextDirection == TextDirection.ltr) {
                      mytextDirection = TextDirection.rtl;
                    } else {
                      mytextDirection = TextDirection.ltr;
                    }
                  });
                },
                icon: Icon(Icons.language)),
            actions: [
              IconButton(
                  onPressed: () async {
                    //This icon button is ,when the user hit the button he will sign out from the app,and
                    //he will be taken to the login screen.
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (builder) {
                      return Login();
                    }));
                  },
                  icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: notesRef
                    //نحنا عاوزين نتحصل علي الملاحظات بتاعت المستخدم المسجل معانا فقط فعشان كدة
                    //حنجيب الملاحظات البت
                    //So we will bring the notes that containe the user uid.that we have uploaded with the
                    //note when the user add the note.
                    .where("userid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    //This to sort the note acording to the date of modified.
                    .orderBy("cr", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, i) {
                          //dismissable:allow us to drag and drop the list tile
                          return Dismissible(
                            //when the user dismis a note we are goint to delete the note
                            onDismissed: (value) async {
                              //We add an aweasomDialog that apear when the user dismiss the note,
                              //and if the user click ok then the note will be deleted,and if he click on
                              //cancel,then the note will not be delete and the ui will be refreshed
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.topSlide,
                                title: 'Delete Confirmation',
                                desc:
                                    'Are you sure you want to delete this note?',
                                btnOkColor: Colors.redAccent,
                                btnCancelColor: Colors.blueAccent,
                                btnOkText: "Yes, delete it",
                                buttonsTextStyle: TextStyle(fontSize: 15),
                                btnCancelText: "No, cancel",
                                btnCancelOnPress: () {
                                  //refresh the ui.(when the user canel the delte proccess)
                                  setState(() {});
                                },
                                btnOkOnPress: () async {
                                  //If the user click on the ok button ,then delete the document from the fireStore
                                  //By this way we will ge the url of the image and delte the image using the url of the image.
                                  await FirebaseFirestore.instance
                                      .collection("notes")
                                      //to get the document id.
                                      .doc(snapshot.data.docs[i].id)
                                      .delete()
                                      .catchError((e) {
                                    print(e);
                                  });
                                  //This to delete the image from the firebase storage using the url of the image.
                                  //did you need to know how it wrok?
                                  await FirebaseStorage.instance
                                      /**This method(refFromUrl) takes a URL pointing to a file in the Firebase Storage and returns
                                   *  a Reference object that represents the file at that location.
                                   *  Once you have a reference to the file, you can use its delete() 
                                   * method to delete the file from Firebase Storage. 
                                   *-> In Firebase Storage, each uploaded file is stored as an object, 
                                   * which can be thoughtيمكن التفكير  of as a file in the cloud storage system
                                   * */
                                      .refFromURL(snapshot.data.docs[i]
                                          .data()['ImageUrl'])
                                      .delete()
                                      .catchError((e) {
                                    print(e);
                                  });
                                },
                              )..show();
                            },
                            key: UniqueKey(),
                            child: Card(
                              child: SizedBox(
                                height: 80,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return viewNote(
                                          note: snapshot.data.docs[i]
                                              .data()['note'],
                                          title: snapshot.data.docs[i]
                                              .data()['title'],
                                          ImageUrl: snapshot.data.docs[i]
                                              .data()['ImageUrl']);
                                    }));
                                  },
                                  trailing: IconButton(
                                    splashColor: Colors.black,
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (builder) {
                                        return UpdateNote(
                                          documentId: snapshot.data.docs[i].id,
                                        );
                                      }));
                                    },
                                  ),
                                  title: Text(
                                    snapshot.data.docs[i].data()['title'],
                                    //محدد ليهو  اقصي عدد من الاسطر هو واحد عشان ما يخرب لي التصميم
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    snapshot.data.docs[i].data()['note'],
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                    //محدد ليهو  اقصي عدد من الاسطر هو اثنين عشان ما يخرب لي التصميم
                                    maxLines: 2,
                                  ),
                                  leading: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                          "${snapshot.data.docs[i].data()['ImageUrl']}",
                                          fit: BoxFit.cover, loadingBuilder:
                                              (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                      loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    print("${snapshot.error}");
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ));
  }
}
