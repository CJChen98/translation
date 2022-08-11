class ExcelWriter {
  static ExcelWriter? _instance;

  ExcelWriter._();

  factory ExcelWriter() {
    return _instance ??= ExcelWriter._();
  }

  void write(String path, Map<String,Map<String,String>>data) async {

  }
}
