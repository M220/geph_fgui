// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Directory, Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

String _temporaryPath = "";
String _downloadsPath = "";
String _libraryPath = "";
String _applicationSupportPath = "";
String _applicationDocumentsPath = "";
String _externalStoragePath = "";
String _externalCachePath = "";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PathProvider full implementation', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    test('getTemporaryDirectory', () async {
      final Directory result = await getTemporaryDirectory();
      expect(result.path, _temporaryPath);
    });

    test('getApplicationSupportDirectory', () async {
      final Directory result = await getApplicationSupportDirectory();
      expect(result.path, _applicationSupportPath);
    });

    test('getLibraryDirectory', () async {
      final Directory result = await getLibraryDirectory();
      expect(result.path, _libraryPath);
    });

    test('getApplicationDocumentsDirectory', () async {
      final Directory result = await getApplicationDocumentsDirectory();
      expect(result.path, _applicationDocumentsPath);
    });

    test('getExternalStorageDirectory', () async {
      final Directory? result = await getExternalStorageDirectory();
      expect(result?.path, _externalStoragePath);
    });

    test('getExternalCacheDirectories', () async {
      final List<Directory>? result = await getExternalCacheDirectories();
      expect(result?.length, 1);
      expect(result?.first.path, _externalCachePath);
    });

    test('getExternalStorageDirectories', () async {
      final List<Directory>? result = await getExternalStorageDirectories();
      expect(result?.length, 1);
      expect(result?.first.path, _externalStoragePath);
    });

    test('getDownloadsDirectory', () async {
      final Directory? result = await getDownloadsDirectory();
      expect(result?.path, _downloadsPath);
    });
  });

  group('PathProvider null implementation', () {
    setUp(() async {
      PathProviderPlatform.instance = AllNullFakePathProviderPlatform();
    });

    test('getTemporaryDirectory throws on null', () async {
      expect(getTemporaryDirectory(),
          throwsA(isA<MissingPlatformDirectoryException>()));
    });

    test('getApplicationSupportDirectory throws on null', () async {
      expect(getApplicationSupportDirectory(),
          throwsA(isA<MissingPlatformDirectoryException>()));
    });

    test('getLibraryDirectory throws on null', () async {
      expect(getLibraryDirectory(),
          throwsA(isA<MissingPlatformDirectoryException>()));
    });

    test('getApplicationDocumentsDirectory throws on null', () async {
      expect(getApplicationDocumentsDirectory(),
          throwsA(isA<MissingPlatformDirectoryException>()));
    });

    test('getExternalStorageDirectory passes null through', () async {
      final Directory? result = await getExternalStorageDirectory();
      expect(result, isNull);
    });

    test('getExternalCacheDirectories passes null through', () async {
      final List<Directory>? result = await getExternalCacheDirectories();
      expect(result, isNull);
    });

    test('getExternalStorageDirectories passes null through', () async {
      final List<Directory>? result = await getExternalStorageDirectories();
      expect(result, isNull);
    });

    test('getDownloadsDirectory passses null through', () async {
      final Directory? result = await getDownloadsDirectory();
      expect(result, isNull);
    });
  });
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  FakePathProviderPlatform() {
    if (Platform.isLinux) {
      final home = Platform.environment[r"HOME"]!;
      _temporaryPath = "/tmp";
      _applicationDocumentsPath = "$home/Documents";
      _applicationSupportPath = "$home/.local/share/com.example.geph_fgui";
      _downloadsPath = "$home/Downloads";
    }
  }

  @override
  Future<String?> getTemporaryPath() async {
    return _temporaryPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return _applicationSupportPath;
  }

  @override
  Future<String?> getLibraryPath() async {
    return _libraryPath;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _applicationDocumentsPath;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return _externalStoragePath;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>[_externalCachePath];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[_externalStoragePath];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return _downloadsPath;
  }
}

class AllNullFakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return null;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return null;
  }

  @override
  Future<String?> getLibraryPath() async {
    return null;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return null;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return null;
  }

  @override
  Future<String?> getDownloadsPath() async {
    return null;
  }
}
