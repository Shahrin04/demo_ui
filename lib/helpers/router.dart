import 'package:demo_ui/pages/home_page/pages/home_page.dart';
import 'package:demo_ui/pages/login_page/pages/login_page.dart';
import 'package:fluro/fluro.dart';

class PageRouter {
  static FluroRouter router = FluroRouter();
  static void setupRouter() {
    router.define(
      '/',
      handler: _homeHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/login',
      handler: _loginHandler,
      transitionType: TransitionType.fadeIn,
    );
  }

  static final Handler _homeHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const HomePage(),
  );

  static final Handler _loginHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      return const LoginPage();
    },
  );
}
