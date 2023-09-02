import 'dart:convert';
import 'dart:io';

import 'package:iwut_flutter/config/storage_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _instance = new StorageUtil._();
  factory StorageUtil() => _instance;
  static SharedPreferences? _sharedPreferences;

  StorageUtil._();

  static Future<void> init() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<bool> setTermStart(String date) {
    return _sharedPreferences!.setString(StorageKey.TERM_START, date);
  }

  String? getTermStart() {
    String? termStart = _sharedPreferences!.getString(StorageKey.TERM_START);
    return termStart;
  }

  Future<bool> setBackgroundImage(String path) {
    return _sharedPreferences!.setString(StorageKey.BACKGROUND_IMAGE, path);
  }

  String? getBackgroundImage() {
    String? imagePath = _sharedPreferences!.getString(
      StorageKey.BACKGROUND_IMAGE,
    );
    return imagePath;
  }

  Future<bool> deleteBackGround() {
    String? imagePath = _sharedPreferences!.getString(
      StorageKey.BACKGROUND_IMAGE,
    );
    if (imagePath != null) {
      File file = File(imagePath);
      file.delete();
    }
    return _sharedPreferences!.remove(
      StorageKey.BACKGROUND_IMAGE,
    );
  }

  Future<bool> setVersion(String versionId) {
    return _sharedPreferences!.setString(StorageKey.IS_FIRST_OPEN, versionId);
  }

  String? getVersion() {
    String? versionId = _sharedPreferences!.getString(StorageKey.IS_FIRST_OPEN);
    return versionId;
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _sharedPreferences!.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = _sharedPreferences!.getString(key);
    return jsonString == null ? null : json.decode(jsonString);
  }

  Future<bool> setCardId(String cardId){
    return _sharedPreferences!.setString(StorageKey.CARD_ID, cardId);
  }

  String? getCardId(){
    return _sharedPreferences!.getString(StorageKey.CARD_ID);
  }

  Future<bool> setCardPwd(String cardPwd){
    return _sharedPreferences!.setString(StorageKey.CARD_PWD, cardPwd);
  }

  String? getCardPwd(){
    return _sharedPreferences!.getString(StorageKey.CARD_PWD);
  }

  Future<bool> setBool(String key, bool val) {
    return _sharedPreferences!.setBool(key, val);
  }

  bool getBool(String key) {
    bool? val = _sharedPreferences!.getBool(key);
    return val ?? false;
  }

  Future<bool> remove(String key) {
    return _sharedPreferences!.remove(key);
  }

  Future<bool> setInt(String key, int value) {
    return _sharedPreferences!.setInt(key, value);
  }

  int? getInt(String key, {int? defaultValue}) {
    int? val = _sharedPreferences!.getInt(key);
    return val ?? defaultValue;
  }
}
