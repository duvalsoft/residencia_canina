{ pkgs, ... }: {
  channel = "stable-24.05";
  
  packages = [
    pkgs.flutter
    pkgs.jdk21
    pkgs.unzip
    pkgs.git
    
    # Android SDK (no instales android-studio completo, es muy pesado)
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
    # Para Project IDX no necesitas configurar ANDROID_HOME manualmente
    # Ya viene preconfigurado
    
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
        flutter-config = "flutter config --no-analytics";
        flutter-pub-get = "flutter pub get";
      };
    };
    
    previews = {
      enable = true;
      previews = {
        android = {
          command = [
            "flutter" 
            "run"
          ];
          manager = "flutter";
        };
      };
    };
  };
}