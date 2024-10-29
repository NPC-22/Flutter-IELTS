
class HttpResponse {
  int? statusCode = 400;
  String? message = "";
  dynamic data;
 dynamic status;
  HttpResponse({ this.statusCode, this.message, this.data , this.status});

}