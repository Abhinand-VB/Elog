import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();


 Future <bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }


  Future <bool> requestCameraPermission() async {
    return _requestPermission(PermissionGroup.camera);
  }

  Future<bool> requestStoragePermission() async {
    return _requestPermission(PermissionGroup.storage);
  }

  Future<bool> hasCameraPermission() async {
    return hasPermission(PermissionGroup.camera);
  }
  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.storage);
  }
  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }
  void checkPermissions() async{
    bool cam,storage;
    cam= await hasCameraPermission() ;
    storage= await hasStoragePermission() ;

    if(!storage) {
      storage=await PermissionsService().requestStoragePermission();
    }
    if(!cam) {
      cam= await PermissionsService().requestCameraPermission();
    }
  }
}