import 'package:booking_app/api/socket.dart';
import 'package:booking_app/firebase_options.dart';
import 'package:booking_app/page/add_photo_profile_page.dart';
import 'package:booking_app/page/add_product_page.dart';
import 'package:booking_app/page/all_your_products_page.dart';
import 'package:booking_app/page/contents_page.dart';
import 'package:booking_app/page/login_page.dart';
import 'package:booking_app/page/register_page.dart';
import 'package:booking_app/page/your_products_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _AppState();
  }
}
class _AppState extends ConsumerState {
  void updateSocket (String token) {
    setSocket(token, ref);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>  LoginPage(updateSocketFunc: updateSocket,),
          '/register/set-photo': (context) => AddPhotoProfilePage(),
          '/register': (context) => const RegisterPage(),
          '/app': (context) => AppPage(key: UniqueKey(),),
          '/add-product': (context) => AddProductsPage(),
          '/all-your-products': (context) => AllYourProductPage()
         },
      );
}}


