class Failure {
  final String message;
  Failure([this.message = 'an unexpected error occured']);
}
class ServerFailure extends Failure {
   ServerFailure(super.message);
}