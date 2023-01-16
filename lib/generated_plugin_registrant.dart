//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_database_web/firebase_database_web.dart';
import 'package:flutter_native_splash/flutter_native_splash_web.dart';
import 'package:location_web/location_web.dart';
import 'package:text_to_speech_web/text_to_speech_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseDatabaseWeb.registerWith(registrar);
  FlutterNativeSplashWeb.registerWith(registrar);
  LocationWebPlugin.registerWith(registrar);
  TextToSpeechWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
