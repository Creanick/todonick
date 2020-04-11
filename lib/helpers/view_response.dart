import 'package:todonick/helpers/failure.dart';

class ViewResponse<T> {
  final bool error;
  final T data;
  final String message;
  ViewResponse(
      {this.error = false,
      this.data,
      this.message = "Something went wrong try again"});
  ViewResponse.fromFailure(Failure failure)
      : error = true,
        message = failure.message,
        data = null;
}
