import 'package:flutter/material.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/pages/loading_screen.dart';
import 'package:zigma2/src/routes.dart';
import './user.dart';

class DataProvider extends InheritedWidget {
  final LoadingScreen loadingScreen;
  final AdvertList advertList;
  final Routing routing;
  final UserMethodBody user;
  DataProvider({Key key, this.advertList, this.user, this.routing, this.loadingScreen, Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider) as DataProvider;
  }

  @override
  bool updateShouldNotify(DataProvider old) {
    return true;
  }

}