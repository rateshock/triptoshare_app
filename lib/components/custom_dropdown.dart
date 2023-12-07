import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown({
    Key? key,
    required this.selectionList,
    required this.label,
    required this.hintText,
    required this.formKey,
    required this.name,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();

  final List<String> selectionList;
  final String label;
  final String hintText;
  final formKey;
  final String name;
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedState = "";

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 320,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.0,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        Container(
          width: 320,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.orange[900],
            border: Border.all(
              width: 1.0,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: FormBuilderDropdown<String>(
            elevation: 1,
            isExpanded: false,
            key: widget.formKey,
            name: widget.name,
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              //labelText: "Ricerca per tipologia",
              hintText: widget.hintText == ""
                  ? widget.selectionList[0]
                  : widget.hintText,
              hintStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            onChanged: (selectedValue) => {
              setState(() {
                selectedState = selectedValue;
              })
            },
            items: widget.selectionList
                .map((attribute) => DropdownMenuItem(
                      value: attribute,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(attribute),
                    ))
                .toList(),
            valueTransformer: (val) => val?.toString(),
          ),
        ),
      ],
    ));
  }
}
