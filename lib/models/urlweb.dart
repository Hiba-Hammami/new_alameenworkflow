import 'package:formz/formz.dart';

enum UrlWebError { invalid, empty }

class UrlWeb extends FormzInput<String, UrlWebError> {
  const UrlWeb.pure([String value = '']) : super.pure(value);
  const UrlWeb.dirty([String value = '']) : super.dirty(value);

  @override
  UrlWebError? validator(String value) {
    if (value.isEmpty) {
      return UrlWebError.empty;
    }
    return Uri.parse(value).isAbsolute
        ? null
        : value.isEmpty
            ? null
            : UrlWebError.invalid;
  }
}

extension Explanation on UrlWebError {
  String? get name {
    switch (this) {
      case UrlWebError.invalid:
        return "Invalid url";
      case UrlWebError.empty:
        return "url is required";
      default:
        return "url is required";
    }
  }
}
