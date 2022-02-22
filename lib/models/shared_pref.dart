import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class SharedPref {
  final LocalStorage storage = LocalStorage('localstorage_app');

  read(String key) async {
    // var info = json.decode(storage.getItem(key));
    //   print(info);
    return json.decode(storage.getItem(key));
  }

  save(String key, value) async {
    storage.setItem(key, json.encode(value));
  }

  remove(String key) async {
    storage.deleteItem(key);
  }
}
