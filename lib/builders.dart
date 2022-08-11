import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translation/src/convert_enum_to_string_generator.dart';
import 'package:translation/src/keys_generator.dart';
import 'package:translation/src/translation_generator.dart';

Builder keysBuilder(BuilderOptions options) => LibraryBuilder(KeysGenerator());

Builder translationBuilder(BuilderOptions options) =>
    SharedPartBuilder([TranslationGenerator()],"translation");

Builder convertBuilder(BuilderOptions options) =>
    LibraryBuilder(ConvertEnumToStringGenerator(),generatedExtension: ".dart.back");
