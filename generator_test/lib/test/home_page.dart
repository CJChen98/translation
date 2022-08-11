import 'package:flutter/material.dart';
import 'package:generator_test/test/string_id.dart';
import 'package:translation/annotations.dart';
@ConvertEnumToString(enums: SId.values)
class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Text(getText(SId.title)),
    );
  }

  String getText(id){
    return id.toString();
  }
}