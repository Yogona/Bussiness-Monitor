class User{
  static String _username = "";
  static String _userId = "";
  static String _fName = "";
  static String _sName = "";
  static String _lName = "";
  static String _email = "";
  static String _phone = "";
  static String _location = "";
  static String _gender = "";
  static String _roleId = "";
  static bool _loggedIn = false;

  static String getRoleId(){
    return _roleId;
  }

  static String getUserId(){
    return _userId;
  }

  static void toggleLoginStatus(){
    User._loggedIn = !User._loggedIn;
  }

  static bool getLoginStatus(){
    return _loggedIn;
  }

  static void setProfile(String userId, String roleId, String username, String fName, String sName, String lName, String email, String phone, String location, String gender){
    User._userId = userId;
    User._roleId = roleId;
    User._username = username;
    User._fName = fName;
    User._sName = sName;
    User._lName = lName;
    User._email = email;
    User._phone = phone;
    User._location = location;
    User._gender = gender;
  }

  static User getProfile(){
    return User();
  }

  static void setCredentials(){

  }
}