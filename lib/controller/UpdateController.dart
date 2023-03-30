import 'package:get/get.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateNoteControler extends GetxController {
  final myFormKey = GlobalKey<FormState>();
  //we willtell him to give us the document id once he want to use the controller,b
  //because of we will use it here in the onInit method
  final documentId;
  UpdateNoteControler({required this.documentId});

  var noteFocus = FocusNode();
  var fireStore = FirebaseFirestore.instance;

  TextEditingController titleNote = TextEditingController();
  TextEditingController noteBode = TextEditingController();

  var storage = FirebaseStorage.instance.ref();
  //Test
  var ref = FirebaseStorage.instance.ref();
  File? image;
  
  @override
  void onInit() {
    // Use the Firestore library to get the note document with the given document ID.
    //In the code provided, "value" is a variable that contains the result of the
    //asynchronous operation to get a Firestore document with the specified documentId.
    fireStore.collection("notes").doc(documentId).get().then((value) {
      // Set the text of a text field called "titleNote" to the "title" field of the retrieved document.
      titleNote.text = value.data()!['title'];

      // Set the text of a text field called "noteBode" to the "note" field of the retrieved document.
      noteBode.text = value.data()!['note'];
    }).catchError((e) {
      // If there is an error getting the note data, print the error to the console.
      print(e);
    });

    super.onInit();
  }

  EditImageFromCamera() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      var PickedImageNmae = basename(pickedImage.name);
      //Test
      ref = FirebaseStorage.instance.ref("images/$PickedImageNmae");
      // await ref.putFile(image!);
    }
  }

  EditImageFromGellary() async {
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


  isEmptyValidator(value) {
    if (value == null || value == "") {
      return "26".tr;
    }
    return null;
  }

  updateNoteButton(documentId, BuildContext context) async {
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
        //في حال انو الملف بتاع الصورة فاضي دة بعني انو  المستخدم ما عاوز يعدل علي الصورة
        //وفي الحالة دي حنعدل علي   الحقول بتاعت النص فقط
        //وما حيحصل تعديل علي الصورة او باقي الحقول
        //علي فكرة انا هنا مستخدم ال
        //set
        // قلة ادب مني ساي عشان اوري روحي اني شفاتي ,في حين انو مفترض استخدم ال
        //update

        //This to load the notes to the fireStore
        await fireStore.collection("notes").doc(documentId).set({
          "title": "${titleNote.text}",
          "note": "${noteBode.text}",
        }, SetOptions(merge: true)).then((value) {
          //If the addation complete succfuly,then take me to the home page.
          //لو عملية الاضافة تمت بي نجاح حيقوم ياخدنا للصفحة الرئيسية
          //loading will desiabear.
          Navigator.pop(context);
          //This to make him git out from the current page and move to the home page.
          Navigator.pop(context);
        });
      } else {
        //في حال انوو ملف الصورة ما فاضي دة بعني انو المستخدم عاوز يعدل علي الصورة وفي الحالة
        //دي حنعدل ليهو عليها
        //This to load the image to the firebase storage.
        await ref.putFile(image!);
        //This to get the url of the image ,after it has been uploaded to the firebase storage.
        // gets the URL of the uploaded image
        var url = await ref.getDownloadURL();

        //This to load the notes to the fireStore
        await fireStore.collection("notes").doc(documentId).set({
          "title": "${titleNote.text}",
          "note": "${noteBode.text}",
          "ImageUrl": "${url}",
          //we will not msodify this field because of we don't want
          // to change the sort of the element in the listعشان ما يتغيير تريب العناصر ما حنغير عل يالفيلد دة
          //ع
          // "cr": FieldValue.serverTimestamp()
        }, SetOptions(merge: true)).then((value) {
          //لو عملية الاضافة تمت بي نجاح حيقوم ياخدنا للصفحة الرئيسية
          //If the addation complete succfuly,then take me to the home page.
          //loading will desiabear.
          Navigator.pop(context);
          //This to make him git out from the current page and move to the home page.
          Navigator.pop(context);
        }).catchError((e) {
          print(e);
        });
      }
    }
  }
}
