bool checkPhone(String? phone) {
  if (phone == null) return false;
  phone = phone.trim();
  if (phone == '') return false;
  var reg = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  return reg.hasMatch(phone);
}

bool checkPassword(String password, String confirmPassword) {
  //print(password == confirmPassword);
  return password == confirmPassword;
}
