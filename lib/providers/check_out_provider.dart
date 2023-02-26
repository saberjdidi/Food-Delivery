
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

import '../models/delivery_address_model.dart';
import '../models/review_cart_model.dart';

class CheckoutProvider with ChangeNotifier {
  bool isloadding = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController alternateMobileNo = TextEditingController();
  TextEditingController scoiety = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController aera = TextEditingController();
  TextEditingController pincode = TextEditingController();
  LocationData? setLoaction;

  void validator(context, myType) async {
    if (firstName.text.isEmpty) {
      //Fluttertoast.showToast(msg: "firstname is empty");
      Toast.show("firstname is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (lastName.text.isEmpty) {
      Toast.show("lastname is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (mobileNo.text.isEmpty) {
      Toast.show("mobileNo is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (alternateMobileNo.text.isEmpty) {
      Toast.show("alternateMobileNo is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (scoiety.text.isEmpty) {
      Toast.show("society is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (street.text.isEmpty) {
      Toast.show("street is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (landmark.text.isEmpty) {
      Toast.show("landmark is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (city.text.isEmpty) {
      Toast.show("city is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (aera.text.isEmpty) {
      Toast.show("aera is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    } else if (pincode.text.isEmpty) {
      Toast.show("pincode is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    }
    else if (setLoaction == null) {
      Toast.show("setLoaction is empty", duration: Toast.lengthLong, gravity:  Toast.bottom,
          backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white));
    }
    else {
      isloadding = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("AddDeliverAddress")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "firstname": firstName.text,
        "lastname": lastName.text,
        "mobileNo": mobileNo.text,
        "alternateMobileNo": alternateMobileNo.text,
        "scoiety": scoiety.text,
        "street": street.text,
        "landmark": landmark.text,
        "city": city.text,
        "aera": aera.text,
        "pincode": pincode.text,
        "addressType": myType.toString(),
        "longitude": setLoaction?.longitude, //23.768955
        "latitude": setLoaction?.latitude //157.24666
      }).then((value) async {
        isloadding = false;
        notifyListeners();
        //await Fluttertoast.showToast(msg: "Add your deliver address");
        Toast.show("Add your deliver address", duration: Toast.lengthLong, gravity:  Toast.bottom,
            backgroundColor: Colors.blueAccent, textStyle: TextStyle(color: Colors.black));
        Navigator.of(context).pop();
        notifyListeners();
      });
      notifyListeners();
    }
  }

  List<DeliveryAddressModel> deliveryAdressList = [];
  getDeliveryAddressData() async {
    List<DeliveryAddressModel> newList = [];

    DeliveryAddressModel deliveryAddressModel;
    DocumentSnapshot _db = await FirebaseFirestore.instance
        .collection("AddDeliverAddress")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (_db.exists) {
      deliveryAddressModel = DeliveryAddressModel(
        firstName: _db.get("firstname"),
        lastName: _db.get("lastname"),
        addressType: _db.get("addressType"),
        aera: _db.get("aera"),
        alternateMobileNo: _db.get("alternateMobileNo"),
        city: _db.get("city"),
        landMark: _db.get("landmark"),
        mobileNo: _db.get("mobileNo"),
        pinCode: _db.get("pincode"),
        scoirty: _db.get("scoiety"),
        street: _db.get("street"),
      );
      newList.add(deliveryAddressModel);
      notifyListeners();
    }

    deliveryAdressList = newList;
    notifyListeners();
  }

  List<DeliveryAddressModel> get getDeliveryAddressList {
    return deliveryAdressList;
  }

////// Order /////////

  addPlaceOderData({
    required List<ReviewCartModel> oderItemList,
    var subTotal,
    var address,
    var shipping,
  }) async {
    FirebaseFirestore.instance
        .collection("Order")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("MyOrders")
        .doc()
        .set(
      {
        "subTotal": "1234",
        "Shipping Charge": "",
        "Discount": "10",
        "orderItems": oderItemList
            .map((e) => {
          "orderTime": DateTime.now(),
          "orderImage": e.cartImage,
          "orderName": e.cartName,
          "orderUnit": e.cartUnit,
          "orderPrice": e.cartPrice,
          "orderQuantity": e.cartQuantity
        })
            .toList(),
        // "address": address
        //     .map((e) => {
        //           "orderTime": DateTime.now(),
        //           "orderImage": e.cartImage,
        //           "orderName": e.cartName,
        //           "orderUnit": e.cartUnit,
        //           "orderPrice": e.cartPrice,
        //           "orderQuantity": e.cartQuantity
        //         })
        //     .toList(),
      },
    );
  }
}
