class ProcessUtil {
  static bool isEmpty(dynamic output) {
    if(output == null) return true;
    if(output is String && output.isEmpty) return true;
    return false;
  }
}