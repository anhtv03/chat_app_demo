class RouteConstants {
  static const String baseUrl = 'http://30.30.30.86:8888/api';

  static String getUrl(String endPoint){
    return baseUrl + endPoint;
  }
}