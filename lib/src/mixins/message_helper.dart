import 'package:args/args.dart';

abstract class MessageHelper {
  String getMessageString(ArgResults argResults)
  {
    String message = "";
    if (argResults.wasParsed("message"))
    {
      message = argResults["message"];
    }
    return message;
  }
}