import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/data/account_data.dart';
import 'package:geph_fgui/data/server_info.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../path_provider_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Preferences', () {
    setUpAll(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
      final appSupportPath = await getApplicationSupportDirectory();
      final appDocumentsPath = await getApplicationDocumentsDirectory();
      final File logFile;
      final File rssFile;
      final File exportedFile;
      if (Platform.isWindows) {
        logFile = File("${appSupportPath.path}\\log.txt");
        rssFile = File("${appSupportPath.path}\\rss.txt");
        exportedFile = File("${appDocumentsPath.path}\\exported_log.txt");
      } else {
        logFile = File("${appSupportPath.path}/log.txt");
        rssFile = File("${appSupportPath.path}/rss.txt");
        exportedFile = File("${appDocumentsPath.path}/exported_log.txt");
      }

      if (await logFile.exists()) {
        await logFile.delete();
      }
      if (await rssFile.exists()) {
        await rssFile.delete();
      }
      if (await exportedFile.exists()) {
        await exportedFile.delete();
      }
    });

    test("test for singleton", () async {
      SharedPreferences.setMockInitialValues({});
      final settings1 = await SettingsProvider.instance();
      final settings2 = await SettingsProvider.instance();

      expect(identical(settings1, settings2), true);
      settings1.dispose();

      final settings3 = await SettingsProvider.instance();
      expect(identical(settings1, settings3), false);
      settings3.dispose();
    });

    test('default values are as expected', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();

      expect(settings.locale, null);
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.log, "");
      expect(settings.rssFeed, null);
      expect(settings.protocol, Protocol.auto);
      expect(settings.autoProxy, true);
      expect(settings.networkVPN, false);
      expect(settings.excludePRC, false);
      expect(settings.excludeApps, false);
      expect(settings.routingMode, RoutingMode.auto);
      expect(settings.accountData, null);
      expect(settings.serviceState, ServiceState.disconnected);
      expect(settings.selectedServer, null);
      expect(settings.lastNewsFetched, false);
      expect(settings.binaryInstalled, false);
      expect(settings.excludedAppsList, List.empty());
      expect(settings.newNewsAvailable, false);

      final docPath = await getApplicationDocumentsDirectory();
      const exportedLogFileName = "exported_log.txt";
      if (Platform.isWindows) {
        expect(settings.exportPath, "${docPath.path}\\$exportedLogFileName");
      } else {
        expect(settings.exportPath, "${docPath.path}/$exportedLogFileName");
      }
      settings.dispose();
    });
  });

  group('Method tests', () {
    // Test once that the current instance property is correctly modified,
    // and then test that the modified property persists with
    // SharedPreferences after disposing the instance.
    //
    // Finally, dispose the instance so that the next tests can initialize
    // SettingsProvider with mock SharedPreferences values. If this is not done,
    // the modified SharedPreferences by this test, will be used by the next tests.

    test('setLocale works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.locale, null);

      await settings.setLocale(englishLocale);
      expect(settings.locale, englishLocale);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.locale, englishLocale);

      await settings.setLocale(persianLocale);
      expect(settings.locale, persianLocale);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.locale, persianLocale);

      await settings.setLocale(chineseTWLocale);
      expect(settings.locale, chineseTWLocale);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.locale, chineseTWLocale);

      await settings.setLocale(chineseCNLocale);
      expect(settings.locale, chineseCNLocale);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.locale, chineseCNLocale);

      settings.dispose();
    });

    test('setThemeMode works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.themeMode, ThemeMode.system);

      await settings.setThemeMode(ThemeMode.dark);
      expect(settings.themeMode, ThemeMode.dark);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.themeMode, ThemeMode.dark);

      await settings.setThemeMode(ThemeMode.light);
      expect(settings.themeMode, ThemeMode.light);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.themeMode, ThemeMode.light);

      await settings.setThemeMode(ThemeMode.system);
      expect(settings.themeMode, ThemeMode.system);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.themeMode, ThemeMode.system);

      settings.dispose();
    });

    test('setProtocol works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.protocol, Protocol.auto);

      await settings.setProtocol(Protocol.udp);
      expect(settings.protocol, Protocol.udp);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.protocol, Protocol.udp);

      await settings.setProtocol(Protocol.tls);
      expect(settings.protocol, Protocol.tls);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.protocol, Protocol.tls);

      await settings.setProtocol(Protocol.auto);
      expect(settings.protocol, Protocol.auto);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.protocol, Protocol.auto);

      settings.dispose();
    });

    test('setRoutingMode works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.routingMode, RoutingMode.auto);

      await settings.setRoutingMode(RoutingMode.bridges);
      expect(settings.routingMode, RoutingMode.bridges);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.routingMode, RoutingMode.bridges);

      await settings.setRoutingMode(RoutingMode.auto);
      expect(settings.routingMode, RoutingMode.auto);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.routingMode, RoutingMode.auto);

      settings.dispose();
    });

    test('setServiceState works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.serviceState, ServiceState.disconnected);

      settings.setServiceState(ServiceState.connecting);
      expect(settings.serviceState, ServiceState.connecting);

      settings.setServiceState(ServiceState.connected);
      expect(settings.serviceState, ServiceState.connected);

      settings.setServiceState(ServiceState.disconnected);
      expect(settings.serviceState, ServiceState.disconnected);

      settings.dispose();
    });

    test('setNetworkVPN works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.networkVPN, false);

      await settings.setNetworkVPN(true);
      expect(settings.networkVPN, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.networkVPN, true);

      await settings.setNetworkVPN(false);
      expect(settings.networkVPN, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.networkVPN, false);

      settings.dispose();
    });

    test('setExcludePRC works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.excludePRC, false);

      await settings.setExcludePRC(true);
      expect(settings.excludePRC, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.excludePRC, true);

      await settings.setExcludePRC(false);
      expect(settings.excludePRC, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.excludePRC, false);

      settings.dispose();
    });

    test('setAutoProxy works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.autoProxy, true);

      await settings.setAutoProxy(false);
      expect(settings.autoProxy, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.autoProxy, false);

      await settings.setAutoProxy(true);
      expect(settings.autoProxy, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.autoProxy, true);

      settings.dispose();
    });

    test('setListenAllInterfaces works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.listenAllInterfaces, false);

      await settings.setListenAllInterfaces(true);
      expect(settings.listenAllInterfaces, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.listenAllInterfaces, true);

      await settings.setListenAllInterfaces(false);
      expect(settings.listenAllInterfaces, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.listenAllInterfaces, false);

      settings.dispose();
    });

    test('setAccountData works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.accountData, null);

      const accountData =
          AccountData(username: "MockUsername", password: "MockPassword");

      await settings.setAccountData(accountData);
      expect(settings.accountData, accountData);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.accountData, accountData);

      settings.dispose();
    });

    test('setExcludeApps works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.excludeApps, false);

      await settings.setExcludeApps(true);
      expect(settings.excludeApps, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.excludeApps, true);

      await settings.setExcludeApps(false);
      expect(settings.excludeApps, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.excludeApps, false);

      settings.dispose();
    });

    test('setSelectedServer & unsetSelectedServer works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.selectedServer, null);

      const czServer = ServerInfo(
          address: "cz-prg-101.geph.io", plus: true, p2pAllowed: true);

      await settings.setSelectedServer(czServer);
      expect(settings.selectedServer, czServer);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.selectedServer, czServer);

      await settings.unsetSelectedServer();
      expect(settings.selectedServer, null);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.selectedServer, null);

      settings.dispose();
    });

    test('setLastNewsFetched works', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      expect(settings.lastNewsFetched, false);

      settings.setLastNewsFetched(true);
      expect(settings.lastNewsFetched, true);

      settings.setLastNewsFetched(false);
      expect(settings.lastNewsFetched, false);

      settings.dispose();
    });

    test('setBinaryInstalled works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      expect(settings.binaryInstalled, false);

      await settings.setBinaryInstalled(true);
      expect(settings.binaryInstalled, true);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.binaryInstalled, true);

      await settings.setBinaryInstalled(false);
      expect(settings.binaryInstalled, false);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.binaryInstalled, false);

      settings.dispose();
    });

    test('setNewNewsAvailable works', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      expect(settings.newNewsAvailable, false);

      settings.setNewNewsAvailable(true);
      expect(settings.newNewsAvailable, true);

      settings.setNewNewsAvailable(false);
      expect(settings.newNewsAvailable, false);

      settings.dispose();
    });

    test('setLog works', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      const mockData = "Mock data";
      expect(settings.log, "");

      settings.setLog(mockData);
      expect(settings.log, mockData);

      settings.dispose();
    });

    test('writeLogFile works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();
      const mockData = "Mock data";
      settings.setLog(mockData);
      final appSupportPath = await getApplicationSupportDirectory();
      final File logFile;
      if (Platform.isWindows) {
        logFile = File("${appSupportPath.path}\\log.txt");
      } else {
        logFile = File("${appSupportPath.path}/log.txt");
      }

      await settings.writeLogFile();
      expect(await logFile.exists(), true);
      expect(await logFile.readAsString(), mockData);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.log, mockData);

      settings.dispose();
    });

    test('logout works', () async {
      SharedPreferences.setMockInitialValues({});
      var settings = await SettingsProvider.instance();

      const accountData =
          AccountData(username: "MockUsername", password: "MockPassword");
      const czServer = ServerInfo(
          address: "cz-prg-101.geph.io", plus: true, p2pAllowed: true);

      await settings.setAccountData(accountData);
      await settings.setSelectedServer(czServer);

      await settings.logout();
      expect(settings.accountData, null);
      expect(settings.selectedServer, null);
      settings.dispose();
      settings = await SettingsProvider.instance();
      expect(settings.accountData, null);
      expect(settings.selectedServer, null);

      settings.dispose();
    });

    test('exportLogFile works', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      const mockData = "Mock data";
      settings.setLog(mockData);
      final exportFile = File(settings.exportPath);
      expect(await exportFile.exists(), false);

      await settings.exportLogFile();
      expect(await exportFile.exists(), true);
      expect(await exportFile.readAsString(), mockData);

      settings.dispose();
    });
  });
}
