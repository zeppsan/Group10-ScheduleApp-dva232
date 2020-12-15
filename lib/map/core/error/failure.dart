abstract class Failure{
  Failure ([List properties=const<dynamic>[]]);
}
class AssetsFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {}