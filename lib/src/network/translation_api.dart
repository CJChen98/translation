import 'dart:convert';
import 'dart:io';

class TranslationApi {
  final httpClient = HttpClient();
  static TranslationApi? _instance;

  TranslationApi._();

  factory TranslationApi() {
    return _instance ??= TranslationApi._();
  }

  Future<Map<String, String>> translate(
      Map<String, String> data, String to) async {
    final Map<String, String> result = {};
    for (final key in data.keys) {
      result[key] = await _translateV2(q: data[key]!, to: to);
    }
    return result;
  }

  Future<String> _translateV1({required String q, required String to}) async {
    try {
      final requset = await httpClient.getUrl(Uri.parse(
          "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$to&dj=1&dt=t&dt=bd&dt=qc&dt=rm&dt=ex&dt=at&dt=ss&dt=rw&dt=ld&q=$q&tk=233819.233819"));
      final response = await requset.close();
      if (response.statusCode == 200) {
        final str = await response.transform(utf8.decoder).join();
        final map = json.decode(str);
        return map["sentences"].first["trans"];
      }
      throw HttpException("翻译api请求失败 code = ${response.statusCode}");
    } on Exception catch (e, s) {
      print("$e,\n$s");
    }
    return "";
  }

  Future<String> _translateV2({required String q, required String to}) async {
    try {
      final requset = await httpClient.getUrl(Uri.parse("https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=auto&tl=$to&q=$q"));
      final response = await requset.close();
      if (response.statusCode == 200) {
        final str = await response.transform(utf8.decoder).join();
        final list = json.decode(str);
        return list.first.first.toString().trim();
      }
      throw HttpException("翻译api请求失败 code = ${response.statusCode}");
    } on Exception catch (e, s) {
      print("$e,\n$s");
    }
    return "";
  }
}
