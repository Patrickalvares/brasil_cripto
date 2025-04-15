flutter pub cache clean --force &&
rm pubspec.lock &&
rm -rf .dart_tool &&
flutter pub get &&
rm -Rf ios/Pods &&
rm -Rf ios/.symlinks &&
rm -Rf ios/Flutter/Flutter.framework &&
rm -Rf ios/Flutter/Flutter.podspec &&
flutter pub get &&
cd ios &&
pod deintegrate &&
pod install --clean-install
dart pub global activate flutterfire_cli   