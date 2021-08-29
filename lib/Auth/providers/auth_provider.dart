import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/auth_helper.dart';
import 'package:gsg2_firebase/Auth/helpers/firestorage_helper.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/Auth/models/country_model.dart';
import 'package:gsg2_firebase/Auth/models/register_request.dart';
import 'package:gsg2_firebase/Auth/models/user_model.dart';
import 'package:gsg2_firebase/Auth/ui/auth_main_page.dart';
import 'package:gsg2_firebase/Auth/ui/login_page.dart';
import 'package:gsg2_firebase/chats/chat_page.dart';
import 'package:gsg2_firebase/chats/home_page.dart';
import 'package:gsg2_firebase/services/custom_dialoug.dart';
import 'package:gsg2_firebase/services/routes_helper.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  List<UserModel> users;
  String myId;
  AuthProvider() {
    getCountriesFromFirestore();
  }
  TabController tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cituController = TextEditingController();

  getAllUsers() async {
    users = await FirestoreHelper.firestoreHelper.getAllUsersFromFirestore();
    users.removeWhere((element) => element.id == myId);
    notifyListeners();
  }

  UserModel user;
  getUserFromFirestore() async {
    String userId = AuthHelper.authHelper.getUserId();
    user = await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
    notifyListeners();
  }

  resetControllers() {
    emailController.clear();
    passwordController.clear();
  }

  List<CountryModel> countries;
  List<dynamic> cities = [];
  CountryModel selectedCountry;
  String selectedCity;
  selectCountry(CountryModel countryModel) {
    this.selectedCountry = countryModel;
    this.cities = countryModel.cities;
    selectCity(cities.first.toString());
    notifyListeners();
  }

  selectCity(dynamic city) {
    this.selectedCity = city;
    notifyListeners();
  }

  getCountriesFromFirestore() async {
    List<CountryModel> countries =
        await FirestoreHelper.firestoreHelper.getAllCountries();
    this.countries = countries;
    selectCountry(countries.first);
    notifyListeners();
  }

///////////////////////////////////////////////////
  ///upload Image
  File file;
  selectFile() async {
    XFile imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    this.file = File(imageFile.path);
    notifyListeners();
  }

///////////////////////////////////////////////////
  register() async {
    try {
      UserCredential userCredential = await AuthHelper.authHelper
          .signup(emailController.text, passwordController.text);
      String imageUrl =
          await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
      RegisterRequest registerRequest = RegisterRequest(
          imageUrl: imageUrl,
          id: userCredential.user.uid,
          city: selectedCity,
          country: selectedCountry.name,
          email: emailController.text,
          fName: firstNameController.text,
          lName: lastNameController.text,
          password: passwordController.text);
      await FirestoreHelper.firestoreHelper.addUserToFirestore(registerRequest);
      await AuthHelper.authHelper.verifyEmail();
      await AuthHelper.authHelper.logout();
      tabController.animateTo(1);
    } on Exception catch (e) {
      // TODO
    }
// navigate to login

    resetControllers();
  }

  logout() async {
    await AuthHelper.authHelper.logout();
    RouteHelper.routeHelper.goToPageWithReplacement(AuthMainPage.routeName);
  }

  login() async {
    UserCredential userCredinial = await AuthHelper.authHelper
        .signin(emailController.text, passwordController.text);
    FirestoreHelper.firestoreHelper
        .getUserFromFirestore(userCredinial.user.uid);
    // bool isVerifiedEmail = AuthHelper.authHelper.checkEmailVerification();
    // if (isVerifiedEmail) {
    RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    // } else {
    //   CustomDialoug.customDialoug.showCustomDialoug(
    //       'You have to verify your email, press ok to send another email',
    //       sendVericiafion);
    // }
    resetControllers();
  }

  sendVericiafion() {
    AuthHelper.authHelper.verifyEmail();
    AuthHelper.authHelper.logout();
  }

  resetPassword() async {
    AuthHelper.authHelper.resetPassword(emailController.text);
    resetControllers();
  }

  checkLogin() {
    bool isLoggedIn = AuthHelper.authHelper.checkUserLoging();

    if (isLoggedIn) {
      this.myId = AuthHelper.authHelper.getUserId();
      getAllUsers();
      RouteHelper.routeHelper.goToPageWithReplacement(ChatPage.routeName);
    } else {
      RouteHelper.routeHelper.goToPageWithReplacement(AuthMainPage.routeName);
    }
  }

  fillControllers() {
    emailController.text = user.email;
    firstNameController.text = user.fName;
    lastNameController.text = user.lName;
    countryController.text = user.country;
    cituController.text = user.city;
  }

  File updatedFile;
  captureUpdateProfileImage() async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.updatedFile = File(file.path);
    notifyListeners();
  }

  updateProfile() async {
    String imageUrl;
    if (updatedFile != null) {
      imageUrl = await FirebaseStorageHelper.firebaseStorageHelper
          .uploadImage(updatedFile);
    }
    UserModel userModel = UserModel(
        city: cituController.text,
        country: countryController.text,
        fName: firstNameController.text,
        lName: lastNameController.text,
        id: user.id,
        imageUrl: imageUrl ?? user.imageUrl);

    await FirestoreHelper.firestoreHelper.updateProfile(userModel);
    getUserFromFirestore();
    Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop();
  }
}
