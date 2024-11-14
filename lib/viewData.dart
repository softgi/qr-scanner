import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  List<String> viewList = ['기본 데이터로 적용되어있습니다.'];

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  Future<void> _loadInitialValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedValues = prefs.getStringList('check_list');

    // 저장된 값이 있으면 사용, 없으면 초기값 사용
    if (savedValues != null) {
      setState(() {
        viewList = savedValues;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Data')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewList != null && viewList[0] != '기본 데이터로 적용되어있습니다.')
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: viewList.toString()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3)
                    ),
                    child: const Text('copy'),
                  ),
                if (viewList != null)
                  for (var view in viewList!) Text(view.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
