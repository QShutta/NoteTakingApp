import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/controller/Themes.dart';
import 'package:note_taking_tpp3/main.dart';
import 'package:note_taking_tpp3/view/AddNote.dart';
import 'package:note_taking_tpp3/controller/HomeController.dart';
import 'package:note_taking_tpp3/view/Login.dart';
import 'package:note_taking_tpp3/view/UpdateNotePage.dart';
import 'package:note_taking_tpp3/view/viewNote.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controller/LanguageController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController controller = Get.put(HomeController());
  //to initlize the language controller:
  final LanguageController langController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: controller.mytextDirection,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                //When the user hit the floating button it will be taken to the add note page.
                Get.to(() => AddNote());
              }),
          appBar: AppBar(
            title: Text(
              "1".tr,
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: SizedBox(
              child: IconButton(
                  //This button is to change the text direction ,when the user hit the icon button
                  onPressed: () {
                    String currentLangCode =
                        langController.initalLang.languageCode;

                    langController.changeLang();
                  },
                  icon: Icon(Icons.language)),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    //check wither the mode is dark or light?if it's dark will convert it to light
                    //and if if it's light will convert it to dark.
                    if (Get.isDarkMode) {
                      Get.changeTheme(myTheme.lightTheme);
                      //by the previous line we convert the mode to light,and the isDark should set to false
                      //so that once the app opoen the mode will be light and vice verse
                      sharePref!.setBool("isDark", false);
                    } else {
                      Get.changeTheme(myTheme.darkTheme);
                      //by the previous line we convert the mode to dark,and the isDark should set to true
                      //so that once the app opoen the mode will be dark and vice verse
                      sharePref!.setBool("isDark", true);
                    }
                  },
                  icon: Icon(Icons.dark_mode)),
              IconButton(
                  onPressed: () async {
                    //This icon button is ,when the user hit the button he will sign out from the app,and
                    //he will be taken to the login screen.
                    await FirebaseAuth.instance.signOut();
                    sharePref!.clear();
                    Get.off(Login());
                  },
                  icon: Icon(Icons.exit_to_app)),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<HomeController>(
                builder: (controller) {
                  return StreamBuilder(
                    stream: controller.notesRef
                        //نحنا عاوزين نتحصل علي الملاحظات بتاعت المستخدم المسجل معانا فقط فعشان كدة
                        //حنجيب الملاحظات البت
                        //So we will bring the notes that containe the user uid.that we have uploaded with the
                        //note when the user add the note.
                        //"userid":is a normal  filed in the document
                        .where("userid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        //This to sort the note acording to the date of modified.
                        //cr is a filed represend the data of add.
                        .orderBy("cr", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
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
                                    title: '19'.tr,
                                    desc: '20'.tr,
                                    btnOkColor: Colors.redAccent,
                                    btnCancelColor: Colors.blueAccent,
                                    btnOkText: "21".tr,
                                    buttonsTextStyle: TextStyle(fontSize: 15),
                                    btnCancelText: "22".tr,
                                    btnCancelOnPress: () {
                                      //refresh the ui.(when the user canel the delte proccess)
                                      // The line controller.update() will rebuild the GetBuilder widget in GetX
                                      controller.update();
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
                                    height: 80.h,
                                    child: ListTile(
                                      onTap: () {
                                        //This line is to navigate to the "viewNote" page,and we will pass parameters
                                        //to the secound page have a required parameters.
                                        //note,title,imageUrl
                                        Get.to(() => viewNote(
                                            note: snapshot.data.docs[i]
                                                .data()['note'],
                                            title: snapshot.data.docs[i]
                                                .data()['title'],
                                            ImageUrl: snapshot.data.docs[i]
                                                .data()['ImageUrl']));
                                      },
                                      trailing: IconButton(
                                        splashColor: Colors.black,
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          //This to navigate to the updateNote page ,and this page have a constuructor
                                          //require "documentid" as parameter.
                                          Get.to(() => UpdateNotePage(
                                              documentId:
                                                  snapshot.data.docs[i].id));
                                        },
                                      ),
                                      title: AutoSizeText(
                                        snapshot.data.docs[i].data()['title'],
                                        //محدد ليهو  اقصي عدد من الاسطر هو واحد عشان ما يخرب لي التصميم
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp),
                                      ),
                                      subtitle: AutoSizeText(
                                        snapshot.data.docs[i].data()['note'],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.sp),
                                        //محدد ليهو  اقصي عدد من الاسطر هو اثنين عشان ما يخرب لي التصميم
                                        maxLines: 1,
                                      ),
                                      leading: SizedBox(
                                        width: 60.h,
                                        height: 60.h,
                                        //ClipRRect to make the image rounded.
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              "${snapshot.data.docs[i].data()['ImageUrl']}",
                                              fit: BoxFit.cover,
                                              //الكود  الجاي دة ما تشتغل بيهو كتير ,هو انا عاملو بس عشان يظبط ليك الشكل بتاع
                                              //Loading.
                                              loadingBuilder:
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
                          child: AutoSizeText("${snapshot.error}"),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              )),
        ));
  }
}
