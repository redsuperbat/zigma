import 'package:flutter/material.dart';
import 'package:zigma2/pages/advert.dart';

class AdvertListProvider extends InheritedWidget {
  final AdvertList adverts = AdvertList();
  AdvertListProvider({Key key, Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static AdvertListProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AdvertListProvider) as AdvertListProvider;
  }

  @override
  bool updateShouldNotify(AdvertListProvider old) {
    return true;
  }
}