set -e 
set -o pipefail

_name=MAGDebugKit
_scheme=$_name
_project=$_name.xcodeproj
_result_zip_filename=$_name.xcframework.zip

_sim_path=./Build/$_name-iphonesimulator.xcarchive
_device_path=./Build/$_name-iphoneos.xcarchive
_result_path=./Build/$_name.xcframework

xcodebuild archive \
 -project $_project \
 -scheme $_scheme \
 -archivePath $_sim_path \
 -sdk iphonesimulator \
 SKIP_INSTALL=NO


xcodebuild archive \
 -project $_project \
 -scheme $_scheme \
 -archivePath $_device_path \
 -sdk iphoneos \
 SKIP_INSTALL=NO


xcodebuild -create-xcframework \
 -framework $_sim_path/Products/Library/Frameworks/$_name.framework \
 -framework $_device_path/Products/Library/Frameworks/$_name.framework \
 -output $_result_path

cd Build

zip --symlinks -r $_result_zip_filename $_name.xcframework/
shasum -a 256 $_result_zip_filename