import 'dart:async';

import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/providers/auth_resources.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Object with Validators {
  final _emailController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // API: Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get name => _nameController.stream.transform(validateText);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Observable.combineLatest3(email, name, password, (e, n, p) => true);

  // API: change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Future<DBDataModel> getUser() async {
    return await SettingsRepository().getUser();
  }

  Future<DBDataModel> setUser(formData) async {
    return SettingsRepository().setUser(formData);
  }

  // API: dispose/cancel observables/subscriptions
  dispose() {
    _emailController.close();
    _nameController.close();
    _passwordController.close();
  }
}

final settingsBloc = SettingsBloc();

///**
//import 'dart:async';
//
//import 'package:dart_crm/blocs/validators.dart';
//import 'package:dart_crm/models/datamodel.dart';
//import 'package:dart_crm/providers/auth_resources.dart';
//import 'package:rxdart/rxdart.dart';
//
////* Using a shortcut getter method on the class to create simpler and friendlier API for the class to provide access of a particular function on StreamController
////* Mixin can only be used on a class that extends from a base class, therefore, we are adding Bloc class that extends from the Object class
////NOTE: Or you can write "class Bloc extends Validators" since we don't really need to extend Bloc from a base class
//class AuthBloc extends Object with Validators {
//  final _authRepository = AuthRepository();
//  final _authData = PublishSubject<UserModel>();
//
//  //* "_" sets the instance variable to a private variable
//  //NOTE: By default, streams are created as "single-subscription stream", but in this case and in most cases, we need to create "broadcast stream"
//  //Note(con'd): because the email/password streams are consumed by the email/password fields as well as the combineLastest2 RxDart method
//  //Note:(con'd): because we need to merge these two streams as one and get the lastest streams of both that are valid to enable the button state
//  //Note:(con'd): Thus, below two streams are being consumed multiple times
//  //* original single-subscription stream
//  // final _emailController = StreamController<String>();
//  // final _passwordController = StreamController<String>();
//
//  //* Broadcast stream
//  // final _emailController = StreamController<String>.broadcast();
//  // final _passwordController = StreamController<String>.broadcast();
//
//  //* Replacing above Dart StreamController with RxDart BehaviourSubject (which is a broadcast stream by default)
//  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
//  //NOTE: Dart StreamController doesn't have such functionality
//  final _emailController = BehaviorSubject<String>();
//  final _passwordController = BehaviorSubject<String>();
//
//  // Add data to stream
//  Stream<String> get email => _emailController.stream.transform(validateEmail);
//  Stream<String> get password =>
//      _passwordController.stream.transform(validatePassword);
//
//  Stream<bool> get submitValid =>
//      Observable.combineLatest2(email, password, (e, p) => true);
//
//  // change data
//  Function(String) get changeEmail => _emailController.sink.add;
//  Function(String) get changePassword => _passwordController.sink.add;
//
//  submit() {
//    final validEmail = _emailController.value;
//    final validPassword = _passwordController.value;
//
//    print('Email is $validEmail, and password is $validPassword');
//  }
//
//  validateUserAuth() async {
//    final validEmail = _emailController.value;
//    final validPassword = _passwordController.value;
//    UserModel userModel = await _authRepository.validateUser();
//    _authData.sink.add(userModel);
//  }
//
//  dispose() {
//    _emailController.close();
//    _passwordController.close();
//    _authData.close();
//  }
//}
//
////Note: This creates a global instance of Bloc that's automatically exported and can be accessed anywhere in the app
////final bloc = Bloc();
//
///**  INCLUDE this implementation now
// * import '../resources/repository.dart';
//    import 'package:rxdart/rxdart.dart';
//    import '../models/item_model.dart';
//
//    class MoviesBloc {
//    final _repository = Repository();
//    final _moviesFetcher = PublishSubject<ItemModel>();
//
//    Observable<ItemModel> get allMovies => _moviesFetcher.stream;
//
//    fetchAllMovies() async {
//    ItemModel itemModel = await _repository.fetchAllMovies();
//    _moviesFetcher.sink.add(itemModel);
//    }
//
//    dispose() {
//    _moviesFetcher.close();
//    }
//    }
//
//    final bloc = MoviesBloc();
//
// * */
