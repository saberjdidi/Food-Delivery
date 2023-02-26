import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../configs/global_method.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isloadding = false;
  File? imageFile;
  String? imageUrl;
  String fileName = '';
  final addFormKey = GlobalKey<FormState>();
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  //random data
 /* var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, () => chars.codeUnitAt(_rnd.nextInt(_chars.length)))); */

  @override
  void dispose() {
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

    addCategoryData(context) async {
    if(addFormKey.currentState!.validate()){
      if(imageFile == null){
        GlobalMethod.showErrorDialog(error: 'Please pick an image', context: context);
        //Toast.show("image is empty", duration: Toast.lengthLong, gravity:  Toast.bottom, backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
        return;
      }
      else if (name.text.isEmpty) {
        Toast.show("name is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
            backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
      } else if (description.text.isEmpty) {
        Toast.show("description is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
            backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
      }
      else {
        try {
          isloadding = true;
          notifyListeners();
          final User? user = auth.currentUser;
          final _uid = user!.uid;
          final categoryId = const Uuid().v4();
          final ref = FirebaseStorage.instance.ref().child('categoryImages').child(fileName);
          await ref.putFile(imageFile!);
          imageUrl = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("Category")
              .add({
            "idCategory": categoryId,
            "nameCategory": name.text,
            "imageUrlCategory": imageUrl,
            "descriptionCategory": description.text,
            "uploadedBy":_uid
          }).then((value) async {
            Navigator.of(context).pop();
            name.clear();
            description.clear();
            imageFile = null;
            fileName = '';
            print('data added');
            isloadding = false;
            notifyListeners();
            Toast.show("Catgory added", duration: Toast.lengthLong, gravity:  Toast.bottom, backgroundColor: Colors.blueAccent, textStyle: TextStyle(color: Colors.black));
            notifyListeners();
          }).onError((error, stackTrace){
            print('error : ${error.toString()}');
          });
          // notifyListeners();
        }
        catch(exception){
          isloadding = false;
          print('exception : ${exception.toString()}');
          Toast.show(exception.toString(), duration: Toast.lengthLong, gravity:  Toast.bottom,
              backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
        }
        finally {
          isloadding = false;
        }
      }
    }

  }

  List<CategoryModel> categoriesList = [];
  void getCategoryData() async {
    List<CategoryModel> newList = [];

    QuerySnapshot reviewCartValue = await FirebaseFirestore.instance
        .collection("Category")
        .get();
    reviewCartValue.docs.forEach((element) {
      //print('categories : ${element.get("nameCategory")}');
      CategoryModel reviewCartModel = CategoryModel(
        idCategory: element.get("idCategory"),
        nameCategory: element.get("nameCategory"),
        imageUrlCategory: element.get("imageUrlCategory"),
        descriptionCategory: element.get("descriptionCategory"),
        uploadedBy: element.get("uploadedBy"),
      );
      newList.add(reviewCartModel);
    });
    categoriesList = newList;
    notifyListeners();
  }

  List<CategoryModel> get getCategoryDataList {
    return categoriesList;
  }

  categoryDataDelete(idCategory) {
    FirebaseFirestore.instance
        .collection("Category")
        .doc(idCategory)
        .delete();
    notifyListeners();
  }
}