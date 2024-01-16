import 'package:dio/dio.dart'; 
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Repository {
    Future logout() async {
    final Dio _dio = Dio();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String sessionToken = prefs.getString('session') ?? "";
      Map fdataMap = {'session_token': sessionToken};
      FormData fdata = FormData();
      fdata.fields.addAll(fdataMap.entries.map((e) => MapEntry(e.key, e.value)));
      final response = await _dio.post('', 
      data: fdata,
      );
    prefs.remove('session_token');
    }

Future login({required String username, required String password}) async {
  final Dio _dio = Dio();
  Map fdataMap = {'user': username, 'pwd' : password};
      FormData fdata = FormData();
      final response = await _dio.post(
        '',
        data: fdata,
      );
      log("res $response");
      Map repoResponse = {"status": false, "data": Null};
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.data);
        if(data['status'] == 'success') {
          repoResponse['status'] = true;
          repoResponse['data'] = data;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('session', data['session_token']);
        } else {
          repoResponse['data'] = data;
        }
      }
      return repoResponse;
}
    }