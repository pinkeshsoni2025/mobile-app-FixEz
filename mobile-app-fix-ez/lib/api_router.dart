class RoutingBase {
  //static const ApiUrl = "http://ec2-13-235-241-130.ap-south-1.compute.amazonaws.com:8080/api";
  static const ApiUrl = "http://192.168.31.62:8180/api/v/1.1";
}

class RoutingBalance extends RoutingBase{
  static const LOGIN = "${RoutingBase.ApiUrl}/auth/signin";
  static const REGISTER = "${RoutingBase.ApiUrl}/auth/signup";
  static const OTP_SENT = "${RoutingBase.ApiUrl}/otp/send";
  static const OTP_VERIFY = "${RoutingBase.ApiUrl}/otp/verify";
  static const CHANGE_PASSWORD = "${RoutingBase.ApiUrl}/auth/changepassword/";
  static const CHANGE_PROFILE = "${RoutingBase.ApiUrl}/auth/edit/";
}