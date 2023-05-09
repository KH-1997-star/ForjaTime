import 'package:flutter/widgets.dart';

import '../business_logic/blocs/app/app_bloc.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';

List<Page> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}
