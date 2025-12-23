{ pkgs, ... }: {
  channel = "stable-24.05";
  
  packages = [
    pkgs.flutter
    pkgs.jdk21
    pkgs.unzip
    pkgs.git
    
    # Android SDK y emulador
    pkgs.android-studio
    pkgs.android-tools
    
    # Dependencias para SQLite nativo
    pkgs.sqlite
    pkgs.pkg-config
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
  ];
  
  env = {
    FLUTTER_ROOT = "${pkgs.flutter}";
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    
    # Variables para compilación nativa
    LD_LIBRARY_PATH = "${pkgs.sqlite.out}/lib";
    PKG_CONFIG_PATH = "${pkgs.sqlite.dev}/lib/pkgconfig";
  };
  
  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    
    workspace = {
      onCreate = {
        default.openFiles = [ "lib/main.dart" ];
      };
      
      onStart = {
        flutter-config = "flutter config --no-analytics --android-sdk $ANDROID_HOME";
        flutter-clean = "flutter clean";
        flutter-pub-get = "flutter pub get";
        # Inicia el emulador al cargar el IDE
        start-emulator = "emulator -avd Pixel_5_API_34 -no-snapshot-load &";
      };
    };
    
    previews = {
      enable = true;
      previews = {
        android = {
          command = [
            "flutter" 
            "run" 
            "-d" 
            "emulator-5554"  # ID típico del primer emulador
          ];
          manager = "flutter";
        };
      };
    };
  };
}