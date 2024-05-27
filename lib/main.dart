import 'package:auth_app/pages/add_member_page.dart';
import 'package:auth_app/pages/dashboard_page.dart';
import 'package:auth_app/pages/login_page.dart';
import 'package:auth_app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savings And Loan App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/register': (context) => RegisterPage(),
        '/member/add': (context) => const AddMemberPage()
        // '/member/edit/': (context) => const EditMemberPage(Map < String, dynamic > memberData)
        // '/member/transaction/add': (context) =>
        //     AddMemberTrxPage(memberId: memberId)
        // '/member/transaction/history': (context) => const TrxHistoryPage(memberId: memberId)
      },
    );
  }
}
