import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeData extends StatefulWidget {
  const ChangeData({super.key});

  @override
  State<ChangeData> createState() => _ChangeDataState();
}

class _ChangeDataState extends State<ChangeData> {
  String _excelData = '엑셀 파일에서 데이터를 불러오세요';

  Future<void> _loadExcelFile() async {
    String data = '';

    // 엑셀 파일을 읽어와서 데이터를 설정
    await pickAndReadExcelFile().then((excelData) {
      setState(() {
        _excelData = excelData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_excelData),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadExcelFile,
              child: const Text('엑셀 파일 선택'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateValues(List<String> newValues) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('check_list', newValues);
}

Future pickAndReadExcelFile() async {
  // 파일 선택
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'xls'],  // 엑셀 파일 확장자만 허용
  );

  if (result != null) {
    // 선택된 파일 경로 가져오기
    String filePath = result.files.single.path!;
    List<String> collectedValues = [];

    // 파일을 읽어 엑셀 데이터 파싱
    var bytes = File(filePath).readAsBytesSync();
    try {
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          collectedValues.addAll(row.map((e) => e?.value?.toString()).whereType<String>());
        }
      }
      updateValues(collectedValues);
      return '파일 업로드에 성공하였습니다.';
    } catch (e) {
      log("decodeBytes 오류 발생: $e");
      return '파일에 문제가 있습니다.';
    }
  } else {
    log('파일을 선택하지 않았습니다.');
    return '파일을 선택하지 않았습니다.';
  }
}