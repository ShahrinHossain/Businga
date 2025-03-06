class GlobalVariables {
  // Private constructor
  GlobalVariables._privateConstructor();

  // Singleton instance
  static final GlobalVariables instance = GlobalVariables._privateConstructor();

  // Your global variables
  String globalString = "Hello, World!";
  int globalCounter = 0;
  String ipAddress = 'http://192.168.0.108:8000';
}

// Access anywhere in your project
void someFunction() {
  print(GlobalVariables.instance.globalString);
  GlobalVariables.instance.globalCounter++;
}

String getIp(){
  return GlobalVariables.instance.ipAddress;
}
