import 'package:chatin/constants.dart';
import 'package:chatin/home_page/homePage.dart';
import 'package:chatin/ChatinFirebaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  String nickname;
  bool isExist;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 146,
              ),
              Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildNicknameField(),
                    SizedBox(height: 5),
                    FormError(errors: errors),
                    SizedBox(height: 25),
                    PrimaryButton(
                      text: "Sign In",
                      press: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          KeyboardUtil.hideKeyboard(context);
                          ChatinFirebaseService()
                              .checkIfUserExists(nickname)
                              .then((result) => result
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //TODO nickname will be passed
                                        builder: (context) =>
                                            HomePage(nickname: nickname),
                                      ),
                                    )
                                  : addError(error: knoNickError));
                        }
                      },
                    ),
                    SizedBox(height: 25),
                    PrimaryButton(
                      text: "Sign Up",
                      press: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          KeyboardUtil.hideKeyboard(context);
                          ChatinFirebaseService()
                              .checkIfUserExists(nickname)
                              .then((result) => result
                                  ? addError(error: kAlreadyNickError)
                                  : ChatinFirebaseService()
                                      .createUser(nickname)
                                      .then((result) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage(nickname: nickname),
                                            ),
                                          )));
                        }
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildNicknameField() {
    return TextFormField(
      onSaved: (newValue) => nickname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNickNullError);
        }
        if (value.length >= 5) {
          removeError(error: kShortNickError);
        } else {
          removeError(error: kAlreadyNickError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNickNullError);
          return "";
        } else if (value.length < 5) {
          addError(error: kShortNickError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nickname",
        hintText: "Enter your nickname",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key key,
    @required this.text,
    @required this.press,
    this.color = kPrimaryColor,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  final color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      padding: padding,
      color: color,
      minWidth: MediaQuery.of(context).size.width / 3,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class FormError extends StatelessWidget {
  const FormError({
    Key key,
    @required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length, (index) => Text(errors[index])),
    );
  }
}

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
