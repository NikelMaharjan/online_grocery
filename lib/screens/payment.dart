import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selfcheckoutapp/constants.dart';
import 'package:selfcheckoutapp/screens/payment_khalti/khalti_page.dart';
import 'package:selfcheckoutapp/services/firebase_services.dart';

import 'home.dart';

class PaymentPage extends StatefulWidget {
  final double? total;
  PaymentPage({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<PaymentPage> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PayViaKhalti(total: widget.total)));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  FirebaseServices _firebaseServices = FirebaseServices();
  Future _removeFromCart() async {
    await _firebaseServices.usersCartRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc()
        .delete()
        .then((value) => debugPrint("Deleted"));
  }

  Future<Future> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Leave?'),
            content: Text('Exiting cart will clear all your items.'),
            actions: [
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  _removeFromCart().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  });
                },
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_firebaseServices.getUserId().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: Constants.boldHeadingAppBar,
        ),
        leading: Icon(Icons.monetization_on_rounded), toolbarTextStyle: GoogleFonts.poppinsTextTheme().bodyText2, titleTextStyle: GoogleFonts.poppinsTextTheme().headline6,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Widget? icon;
              Text? text;

              switch (index) {
                case 0:
                  icon = Image.asset("assets/khalti_logo.png");

                  text = Text("Pay via Khalti");
                  break;
              }
              return InkWell(
                child: ListTile(
                  tileColor: index == 2
                      ? Colors.deepPurpleAccent
                      : Theme.of(context).primaryColor,
                  onTap: () {
                    onItemPress(context, index);
                  },
                  title: text,
                  leading: index == 2
                      ? Container(height: 30, width: 60, child: icon)
                      : icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).primaryColor,
                ),
            itemCount: 3),
      ),
    );
  }
}
