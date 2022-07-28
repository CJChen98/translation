import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translation/annotations.dart';
import 'package:translation/src/network/translation_api.dart';

class TranslationGenerator extends GeneratorForAnnotation<Translation> {
  final api = TranslationApi();

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    var str = "";
    try {
      if (element is TopLevelVariableElement) {

        final data =
            element.computeConstantValue()!.toMapValue()!.map((key, value) {
          return MapEntry(key!.getField("_name")!.toStringValue()!,
              value!.toStringValue()!);
        });
        final tos = annotation
            .read("to")
            .listValue
            .map((e) => e.toStringValue()!)
            .toList();
        str = convertToDart(data, annotation.read("from").stringValue) +
            await translate(data, tos);

        return  str;
      }
    } on TypeError catch (e, stackTrace) {
      print("@Translation 注解只能作用于map类型的数据 \n$stackTrace");
      rethrow;
    } on ArgumentError catch (e, stackTrace) {
      print("{$e.message}\n$stackTrace");
      rethrow;
    }
  }

  Future<String> translate(Map<String, String> data, List<String> tos) async {
    var str = "";
    for (final to in tos) {
      str += convertToDart(await api.translate(data, to), to);
    }
    return str;
  }

  final emitter = DartEmitter();

  String convertToDart(Map<String, String> data, String to) {
    String code = data.entries
        .map((e) => "\"${e.key}\":\"${e.value.replaceAll("\n", "\\n")}\"")
        .join(",\n");
    final l = Library((b) => b.body.add(Field((f) => f
      ..type = TypeReference((t) => t.symbol = "Map<String,String>")
      ..name = to
      ..assignment = Block.of([
        const Code("{"),
        lazyCode(() => refer(code).code),
        const Code("}"),
      ]))));
    return "// $to \n" +
        DartFormatter().format('const ${l.accept(emitter)}') +
        "\n";
  }
}
