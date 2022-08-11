import 'dart:io' as io;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translation/annotations.dart';

const _header = """
/*
* conversion completed
*/\n
""";

class ConvertEnumToStringGenerator
    extends GeneratorForAnnotation<ConvertEnumToString> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    try {
      final original = element.source!.contents.data;
      if (original.startsWith(_header)) {
        return;
      }
      final list = annotation.peek("enums")!.listValue.map((e) {
        if (e.type?.element?.kind != ElementKind.ENUM) {
          throw TypeError();
        }
        return e.type!.getDisplayString(withNullability: false) +
            ".${e.getField("_name")?.toStringValue()!}";
      }).toList();
      final target = _convertEnumToString(list, original);
      rewrite(io.File(buildStep.inputId.path), target);
      rewrite(io.File(buildStep.allowedOutputs.first.path), original);
      return original;
    } on TypeError catch (e, stackTrace) {
      print("@Translation 注解只能作用于map类型的数据 \n$stackTrace");
    }
  }

  String _convertEnumToString(List<String> enums, String source) {
    var result = source;
    for (var element in enums) {
      result = result.replaceAll(element, '"$element"');
    }
    return _header + result;
  }

  void rewrite(io.File file, String s) {
    file.writeAsStringSync(s);
  }
}
