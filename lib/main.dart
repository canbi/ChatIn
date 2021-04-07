import 'package:flutter/material.dart';
import 'package:chatin/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatIn Home',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Hello World Title"),
      ),*/
      body: SafeArea(
        //Telefondaki üst çubuklar için
        child: Container(
          padding: EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start ChatIn',
                    style:
                        Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.pink.shade200,
                    // TODO Buraya kullanıcının görseli gelecek
                    //backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              // TODO Buraya chatroom list gelecek
              Expanded(
                child: SizedBox(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 20,
                    ),
                    children: List.generate(
                      45, // TODO chatrooms.length olacak ileride buna göre chatroomları görselleştireceğiz.
                      (index) => Container(
                        child: Column(
                          children: [
                            CircleAvatar(backgroundColor: Colors.redAccent, minRadius: 42),
                            SizedBox(height: 8),
                            Text("ChatRoom #${index + 1}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
