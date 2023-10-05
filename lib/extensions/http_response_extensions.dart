import 'package:http/http.dart';

extension HttpExtensions on Response {
  bool get success {
    return (statusCode ~/ 100) == 2;
  }
}
