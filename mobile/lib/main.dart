// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import './pages/home.dart' as Home;
import './pages/laser-pen.dart' as LaserPen;

class HttpClient {
  badCertificateCallback(X509Certificate cert, String host, int port) {
    return true;
  }
}

void main() {
  return runApp(MaterialApp(
      home: new Home.Main(),
      routes: <String, WidgetBuilder>{
          '/laserpen': (BuildContext context) => LaserPen.Main()
      }
  ));
}
