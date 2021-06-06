import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              BackButton(),
              Center(
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person_outline_rounded),
                  SizedBox(width: 10),
                  Text("Account",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(height: 30, thickness: 1.5),
              SizedBox(height: 1),
              accountOption(context, "Change Username"),
              Divider(height: 15, thickness: 0.7), //inside section divider
              accountOption(context, "Change Password"),
              SizedBox(height: 50),

              Row(
                children: [
                  Icon(Icons.settings_cell),
                  SizedBox(width: 10),
                  Text("Device",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(height: 30, thickness: 2), //section divider
              accountOption(context, "Notifications"),
              Divider(height: 15, thickness: 0.7), //inside section divider
              accountOption(context, "Language"),
              Divider(height: 15, thickness: 0.7), //inside section divider
              accountOption(context, "Privacy & Security")
            ],
          ),
        ));
  }
}

GestureDetector accountOption(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white70),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}
