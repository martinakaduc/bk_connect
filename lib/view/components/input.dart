// Mẫu input filed, trong đó có sử dụng component image
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(String label, String hint, String iconImage) {
    this.label = label;
    this.hint = hint;
    this.iconImage = iconImage;
  }

  String label;
  String hint;
  String iconImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 75,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 335,
                height: 25,
                child: Text(
                  this.label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: Image(image: AssetImage(this.iconImage)),
              ),
              Container(
                width: 285,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    hintStyle: TextStyle(
                      color: const Color(0xffbdbdbd),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                    ),
                    hintText: this.hint,
                    contentPadding:
                        const EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
