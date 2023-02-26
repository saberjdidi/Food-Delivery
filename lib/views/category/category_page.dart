
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../providers/category_provider.dart';
import 'package:path/path.dart' as mypath;

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  late CategoryProvider categoryProvider;

  @override
  Widget build(BuildContext context) {
     categoryProvider = Provider.of(context);
    Size size = MediaQuery.of(context).size;
    categoryProvider.getCategoryData();

     _getFromCamera() async {
      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      categoryProvider.imageFile = File(pickedFile!.path);
      //_cropImage(pickedFile!.path);
      final User? user = categoryProvider.auth.currentUser;
      final _uid = user!.uid;
      categoryProvider.fileName = '${_uid}_${mypath.basename(pickedFile!.path)}';
      Navigator.pop(context);
    }
     _getFromGallery() async {
      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      categoryProvider.imageFile = File(pickedFile!.path);
      final User? user = categoryProvider.auth.currentUser;
      final _uid = user!.uid;
      categoryProvider.fileName = '${_uid}_${mypath.basename(pickedFile!.path)}';
      //_cropImage(pickedFile!.path);
      Navigator.pop(context);
    }
    void _showImageDialog() {
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Please choose an option'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      _getFromCamera();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.camera, color: Colors.purple,),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Camera', style: TextStyle(color: Colors.purple),)
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      _getFromGallery();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.image, color: Colors.purple,),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('gallery', style: TextStyle(color: Colors.purple),)
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: categoryProvider.getCategoryDataList.isEmpty
          ? Center(
        child: Text("NO DATA"),
      )
          : ListView.builder(
        itemCount: categoryProvider.getCategoryDataList.length,
        itemBuilder: (context, index) {
          CategoryModel data =
          categoryProvider.getCategoryDataList[index];
          return Card(
            color: Color(0xFFE9EAEE),
            child: ListTile(
              leading: Image.network(
                data.imageUrlCategory.toString(),
                width: 80,
                height: 80,
              ),
              title: Text(
                '${data.nameCategory}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${data.descriptionCategory}',
              style: TextStyle(color: Colors.black)),
              trailing: Visibility(
                visible: true,
                child: InkWell(
                    onTap: () {
                      showAlertDialog(context, data.idCategory);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
            ),
          );
           /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    child: Center(
                      child: Image.network(
                        data.imageUrlCategory.toString(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 90,
                    child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data.nameCategory}',
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              "${data.descriptionCategory}",
                              style: TextStyle(
                                  color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                  ),
                ),
              ],
            ),
          ); */
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(30))),
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                maxChildSize: 0.9,
                minChildSize: 0.4,
                builder: (context, scrollController) =>
                    SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListBody(
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              const Center(
                                child: Text(
                                  'new Category',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      //fontFamily: "Brand-Bold",
                                      color: Color(0xffd1ad17),
                                      fontSize: 20.0),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Form(
                                key: categoryProvider.addFormKey,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        _showImageDialog();
                                      },
                                      child: Padding(padding: EdgeInsets.all(8),
                                        child: Container(
                                          width: size.width * 0.8,
                                          height: 200,//size.height * 24,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: primaryColor),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: categoryProvider.imageFile == null
                                                ? Icon(Icons.camera_enhance_sharp, color: Colors.cyan, size: 30,)
                                                : Image.file(categoryProvider.imageFile!, fit: BoxFit.fill,)
                                            ,
                                          ),
                                        ),),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: ()=>FocusScope.of(context).requestFocus(categoryProvider.nameFocusNode),
                                        keyboardType: TextInputType.name,
                                        controller: categoryProvider.name,
                                         validator: (value){
                                    if(value!.isEmpty){
                                      return 'Name is required';
                                    }
                                    else {
                                      return null;
                                    }
                                  },
                                        style: TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            hintStyle: TextStyle(color: Colors.black87),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black87)
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black87)
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red)
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: ()=>FocusScope.of(context).requestFocus(categoryProvider.descriptionFocusNode),
                                        keyboardType: TextInputType.emailAddress,
                                        controller: categoryProvider.description,
                                        validator: (value){
                                if(value!.isEmpty){
                                  return 'Description is required';
                                }
                                else {
                                  return null;
                                }
                              },
                                        style: TextStyle(color: Colors.black87),
                                        decoration: const InputDecoration(
                                            hintText: 'Description',
                                            hintStyle: TextStyle(color: Colors.black87),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black87)
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black87)
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red)
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    categoryProvider.isloadding
                                        ? Center(
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: MaterialButton(
                                          onPressed: (){
                                            categoryProvider.addCategoryData(context);
                                          },
                                          color: primaryColor,
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Save', style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.bold, fontSize: 20),)
                                              ],
                                            ),
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            /*Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                              child: ListView(
                                children: [
                                  SizedBox(height: 15,),
                                  Form(
                                    key: categoryProvider.addFormKey,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            _showImageDialog();
                                          },
                                          child: Padding(padding: EdgeInsets.all(8),
                                            child: Container(
                                              width: size.width * 0.8,
                                              height: 200,//size.height * 24,
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: Colors.cyanAccent),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16),
                                                child: categoryProvider.imageFile == null
                                                    ? Icon(Icons.camera_enhance_sharp, color: Colors.cyan, size: 30,)
                                                    : Image.file(categoryProvider.imageFile!, fit: BoxFit.fill,)
                                                ,
                                              ),
                                            ),),
                                        ),
                                        SizedBox(height: 20,),
                                        TextFormField(
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: ()=>FocusScope.of(context).requestFocus(categoryProvider.nameFocusNode),
                                          keyboardType: TextInputType.name,
                                          controller: categoryProvider.name,
                                          /* validator: (value){
                                if(value!.isEmpty){
                                  return 'Name is required';
                                }
                                else {
                                  return null;
                                }
                              }, */
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              hintText: 'Name',
                                              hintStyle: TextStyle(color: Colors.white),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white)
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.red)
                                              )
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        TextFormField(
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: ()=>FocusScope.of(context).requestFocus(categoryProvider.descriptionFocusNode),
                                          keyboardType: TextInputType.emailAddress,
                                          controller: categoryProvider.description,
                                          /* validator: (value){
                                if(value!.isEmpty){
                                  return 'Description is required';
                                }
                                else {
                                  return null;
                                }
                              }, */
                                          style: TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                              hintText: 'Description',
                                              hintStyle: TextStyle(color: Colors.white),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white)
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.red)
                                              )
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        categoryProvider.isloadding
                                            ? Center(
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                            : MaterialButton(
                                            onPressed: (){
                                              categoryProvider.addCategoryData(context);
                                            },
                                            color: Colors.cyan,
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 14),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Save', style: TextStyle(color: Colors.white,
                                                      fontWeight: FontWeight.bold, fontSize: 20),)
                                                ],
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),*/
                          ),
                        )
                    ),
              )
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }


  showAlertDialog(BuildContext context, idCategory) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(color: Colors.red),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(color: Colors.blue)),
      onPressed: () {
        print('idCategory : $idCategory');
        categoryProvider.categoryDataDelete(idCategory);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cart Product"),
      content: Text("Are you devete on cartProduct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
