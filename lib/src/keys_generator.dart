import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translation/annotations.dart';

class KeysGenerator extends GeneratorForAnnotation<Keys> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if(element is EnumElementImpl){
      print(element.constants.first.name);
    }
  }
}
