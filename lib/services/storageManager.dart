import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A manager for the storage in the server and locally.
class StorageManager {

  static final _storage = FirebaseStorage.instance;

  /// Gets a local file given the relative path.
  Future<File> getLocalFile(String relativePath) async {
    final absDir = await getApplicationDocumentsDirectory();
    String absolute = absDir.absolute.toString();
    return File('$absolute/$relativePath');
  }

  /// Uploads a file into the cloud storage.
  UploadTask uploadFile(File file, String path, [Map<String, String> metadata]) {
    // Adds optional metadata if it was given
    SettableMetadata realMetadata;

    if (metadata != null) {
      realMetadata = SettableMetadata(
        customMetadata: metadata,
      );
    }
    try {
      return _storage.ref(path).putFile(file, realMetadata);
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  /// Uploads raw bytes into the cloud storage.
  UploadTask uploadRaw(Uint8List data, String path, {Map<String, String> metadata,String contentType}) {
    // Adds optional metadata if it was given
    SettableMetadata realMetadata;
    if(contentType!=null){
      realMetadata = SettableMetadata(
        contentType: contentType,
      );
    }
    /*if (metadata != null) {
      realMetadata = SettableMetadata(
        customMetadata: metadata,
      );
    }*/
    try {
      // Upload raw data.
      return _storage.ref(path).putData(data, realMetadata);
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  /// Downloads a file from the cloud storage into the local device.
  Future<Uint8List> downloadFile(String serverPath) async {
    try {
      return await _storage.ref(serverPath).getData();
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  /// Gets the reference for all the files inside a directory in the cloud storage.
  Future<List<Reference>> getFilesFromCloudDirectory(String dir, { int maxResults }) async {
    try {
      return (await _storage.ref(dir).list(ListOptions(
        maxResults: maxResults
      ))).items;
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  /// Downloads all the files inside a directory in the cloud storage.
  Future<List<Uint8List>> downloadFilesFromDirectory(String dir, { int maxResults }) async {
    try {
      // Gets the references for all the files in the directory
      final references = (await _storage.ref(dir).list(ListOptions(
        maxResults: maxResults
      ))).items;
      // Then it downloads each one
      final List<Future<Uint8List>> futures = [];
      for (final ref in references)
        futures.add(ref.getData());
      return await Future.wait(futures);
    } catch(ex) {
      print(ex);
    }
    return null;
  }

  /// Checks if a directory in the cloud storage has files.
  Future<bool> hasCloudFiles(String dir) async {
    try {
      return (await _storage.ref(dir).list(ListOptions(
      maxResults: 1
      ))).items.length > 0;
    } catch(ex) {
      print(ex);
    }
    return false;
  }    

  /// Gets a download URL for a file in the cloud storage.
  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch(ex) {
      print(ex);
    }
    return null;
  }

  /// Deletes a file located in the cloud storage.
  Future<void> deleteCloudFile(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch(ex) {
      print(ex);
    }
    return null;
  }

  /// Deletes a whole directory in the cloud storage.
  Future<void> deleteCloudDirectory(String dir) async {
    try {
      // Gets all file references
      final references = await getFilesFromCloudDirectory(dir);
      final List<Future> futures = [];
      for (final ref in references)
        futures.add(ref.delete());
      await Future.wait(futures);
    } catch(ex) {
      print(ex);
    }
    return null;
  }
}


/*
////////////////////// Future code to listen to progress or rule errors
///
irebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
      .ref('uploads/hello-world.txt')
      .putFile(largeFile);

  task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
    print('Task state: ${snapshot.state}');
    print(
        'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  }, onError: (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    print(task.snapshot);

    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
  });
  */