// Mẫu input filed, trong đó có sử dụng component image
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(String label, String hint,
      {this.isPassword = false,
      this.icon,
      this.onSave,
      this.validator,
      this.keyboardType}) {
    this.label = label;
    this.hint = hint;
  }

  String label;
  String hint;
  bool isPassword;
  Icon icon;
  FormFieldSetter<String> onSave;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
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
          Container(
            width: 360,
            height: 65,
            child: TextFormField(
              obscureText: this.isPassword,
              keyboardType: this.keyboardType,
              decoration: InputDecoration(
                icon: this.icon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
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
                counterText: ' ',
                contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
              validator: this.validator,
              onSaved: this.onSave,
            ),
          ),
        ],
      ),
    );
  }
}
