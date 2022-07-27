import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translation/annotations.dart';

class TranslationGenerator extends GeneratorForAnnotation<Translation>{
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return " /*${element.runtimeType}*/";
  }

}