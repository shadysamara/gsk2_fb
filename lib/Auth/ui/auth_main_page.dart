import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:gsg2_firebase/Auth/ui/login_page.dart';
import 'package:gsg2_firebase/Auth/ui/register_page.dart';
import 'package:provider/provider.dart';

class AuthMainPage extends StatefulWidget {
  @override
  _AuthMainPageState createState() => _AuthMainPageState();
}

class _AuthMainPageState extends State<AuthMainPage>
    with SingleTickerProviderStateMixin {
  @override
  initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).tabController =
        TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
          bottom: TabBar(
              controller: Provider.of<AuthProvider>(context).tabController,
              tabs: [
                Tab(
                  text: 'Register',
                ),
                Tab(
                  text: 'Login',
                )
              ]),
        ),
        body: TabBarView(
          controller: Provider.of<AuthProvider>(context).tabController,
          children: [RegisterPage(), LoginPage()],
        ));
  }
}
