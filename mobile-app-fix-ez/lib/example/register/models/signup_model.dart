class SignUpBody {
  //  String name;
  String username;
  // String email;
  String password;
  SignUpBody({
    // required this.name,
    required this.username,
    // required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data["f_name"] = name;
    data["username"] = username;
    //data['email'] = email;
    data['password'] = password;
    return data;
  }
}
