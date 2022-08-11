import 'package:flutter_test/flutter_test.dart';
import 'package:translation/src/excel/excel_writer.dart';

void main(){
  
  test("excel_out_put_test", (){
    final excel = ExcelWriter();
    excel.write("../excel/test.xlsx", {
      "zh":{
        "hello_text":"你好"
      }
    });
  });
}