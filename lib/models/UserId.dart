class UserId{
  static String _abbr = "";
  static String _value = "";

  static String getUserId(){
    return _abbr+_value;
  }

  static void setValue(String value){
    _value = value;
  }

  static String getValue(){
    return _value;
  }

  static void setAbbr(String abbr){
    _abbr = abbr;
  }

  static String getAbbr(){
    return _abbr;
  }
}