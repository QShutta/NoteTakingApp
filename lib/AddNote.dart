import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final myFormKey = GlobalKey<FormState>();

  var noteFocus = FocusNode();
  var fireStore = FirebaseFirestore.instance;

  TextEditingController titleNote = TextEditingController();
  TextEditingController noteBode = TextEditingController();

  var storage = FirebaseStorage.instance.ref();
  //Test
  var ref = FirebaseStorage.instance.ref();
  File? image;
  addImageFromCamera() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      var PickedImageNmae = basename(pickedImage.name);
      //Test
      ref = FirebaseStorage.instance.ref("images/$PickedImageNmae");
      // await ref.putFile(image!);
    }
  }

  addImageFromGellary() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //To get the name of the image?why did we need to get the name of the image? to make a uniqu name
    //for the image ,becuse of ,if there is a tow image with the same name they are going to be override.
    if (pickedImage != null) {
      image = File(pickedImage.path);
      var PickedImageNmae = basename(pickedImage.name);
      var random = Random().nextInt(10000);
      PickedImageNmae = "$random$PickedImageNmae";
      ref = FirebaseStorage.instance.ref("images/$PickedImageNmae");
      // await ref.putFile(image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        //We wrap our scaffold with gestureDetector,so that when the user  click on any part of the screen out of the t
        //textfield ,the keypoard will dismess.
        GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Note",
            style: TextStyle(color: Colors.white),
          ),
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.of(context)
          //           .pushReplacement(MaterialPageRoute(builder: (builder) {
          //         return Home();
          //       }));
          //     },
          //     icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Form(
              key: myFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleNote,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(noteFocus);
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "This Field Can't Be empty";
                      }
                      return null;
                    },
                    maxLength: 30,
                    decoration: InputDecoration(
                        labelText: "Title Note",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.note),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  TextFormField(
                    controller: noteBode,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "This Field Can't Be empty";
                      }
                      return null;
                    },
                    // maxLines: 3,
                    maxLength: 200,
                    //This to make when the user submit on the first text field he will auto be take
                    //this text field.(Note textField.)
                    focusNode: noteFocus,

                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: "Note",
                        prefixIcon: Icon(Icons.note),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (builder) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    child: Text(
                                  "Please Choose Image",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                                ListTile(
                                  title: Text("From Gellery",
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                  onTap: () {
                                    addImageFromGellary();
                                    Navigator.of(context).pop();
                                  },
                                  leading: Icon(
                                    Icons.image,
                                    color: Colors.black,
                                  ),
                                ),
                                ListTile(
                                  title: Text("From Camera",
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                  onTap: () {
                                    addImageFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                  leading: Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text("Add image for Note"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (myFormKey.currentState!.validate()) {
                          //This to show loading while the note is upload to the firebase
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              });
                          //This condition to make if the user didn't select an image from the image picker
                          //there is an error message will apear to him,to tell him select an image.
                          if (image == null || image == "") {
                            Navigator.pop(context);
                            //we want to replace the scaffoldMessanger with aweasome dialog.
                            //Because of the snack bar doesn't apear in some phones
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.error,
                              body: Center(
                                child: Text(
                                  'Please select an image',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'Warring',
                              btnOkColor: Colors.red,
                              btnOkOnPress: () {},
                            )..show();
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('Please select an image'),
                            //   ),
                            // );
                          } else {
                            //This to load the image to the firebase storage.
                            await ref.putFile(image!);
                            //This to get the url of the image ,after it has been uploaded to the firebase storage.
                            // gets the URL of the uploaded image
                            var url = await ref.getDownloadURL();

                            //This to load the notes to the fireStore
                            await fireStore.collection("notes").add({
                              "title": "${titleNote.text}",
                              "note": "${noteBode.text}",
                              "ImageUrl": "${url}",
                              "userid":
                                  "${FirebaseAuth.instance.currentUser!.uid}",
                              //The cr field represent the date of creataion.
                              //serverTimestamp() value, which is a special value provided by Firestore that represents
                              // the current timestamp as determined by Firestore servers.
                              // This ensures that the timestamp is consistent across all devices and time zones.
                              "cr": FieldValue.serverTimestamp()
                            }).then((value) {
                              //لو عملية الاضافة تمت بي نجاح؟
                              //حيقدر انو ينتقل للصفحات التانية .
                              //This to make when the image loading succfuly the alert dialog with
                              //loading will desiabear.
                              Navigator.pop(context);
                              //This to make him git out from the current page and move to the home page.
                              Navigator.pop(context);
                            }).catchError((e) {
                              print(e);
                            });
                          }
                        }
                      },
                      child: Text(
                        "Add Note",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
