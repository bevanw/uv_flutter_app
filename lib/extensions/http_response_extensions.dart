import 'package:http/http.dart';

extension IsSuccessful on Response {
  bool get success {
    return (statusCode ~/ 100) == 2;
  }
}