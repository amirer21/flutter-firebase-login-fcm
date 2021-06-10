String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return '이메일 형식이 맞지 않습니다.';
  } else {
    return null;
  }
}

String passwordValidator(String value) {
  if (value.length < 8) {
    return '8자리 이상 입력해주세요.';
  } else {
    return null;
  }
}