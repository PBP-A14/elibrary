import 'package:elibrary/data/model/home_book_model.dart';
import 'package:elibrary/pages/authentication/login_user.dart';
import 'package:elibrary/widgets/book_tile.dart';
import 'package:elibrary/widgets/password_form.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../../auth/auth.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Book>> fetchProduct(BuildContext context) async {
    final request = context.watch<CookieRequest>();
    var url = 'http://127.0.0.1:8000/my_profile/get_reading_history_json/';
    var response = await request.get(url);
    // print(response);
    var data = [...response];
    // print(data.runtimeType);

    List<Book> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Book.fromJson(d));
      }
    }
    // print(list_product);
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    String uname = CurrUserData.username!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${uname}'),
      ),
      body: FutureBuilder(
        future: fetchProduct(context),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          // print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              snapshot.data == null) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tidak ada data produk.",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordFormPage())),
                    child: Text('Change Password'))
              ],
            ));
          } else {
            return Column(
              children: [
                Text(
                  'Your Reading History',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      BookTile(book: snapshot.data![index]),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordFormPage())),
                    child: Text('Change Password'))
              ],
            );
          }
        },
      ),
    );
  }
}
