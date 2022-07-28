import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:translation/src/network/translation_api.dart';

void main() {
  final api = TranslationApi();
  test('adds one to input values', () async {
    // final result = await api.translate({"string_hello":"你好"}, "en");
    print(convertToDart({"string_hello": "你好"}, "en"));
  });
}

String convertToDart(Map<String, String> data, String to) {
  String code =
      data.entries.map((e) => "\"${e.key}\" : \"${e.value}\"").join(",\n");
  final l = Library((b)=>b.body.add(
      Field((f) => f
        ..type = TypeReference((t) => t.symbol = "Map<String,String>")
        ..name = to
        ..assignment = Block.of([
          const Code("{"),
          lazyCode(() => refer(code).code),
          const Code("}"),
        ]))
  ));
  return DartFormatter().format('const ${l.accept(DartEmitter.scoped())}');
}
