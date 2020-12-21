import 'package:schedule_dva232/map/core/error/exceptions.dart';
import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either <Failure, String> processInput (String str){
    try {
      if (str == "")
        throw InvalidInputException();
      else
        return Right(str.replaceAll(new RegExp(r"\s+|-"), "").toUpperCase());
    }
    on InvalidInputException{
      return Left(InvalidInputFailure());
    }
  }
}