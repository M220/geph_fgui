import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/server_info.dart';
import '../data/account_data.dart';

const String _themeModeKey = "themeMode";
const String _localeKey = "locale";
const String _routingModeKey = "routingMode";
const String _protocolKey = "protocolMode";
const String _networkVPNKey = "networkVPN";
const String _excludePRCKey = "excludePRC";
const String _autoProxyKey = "autoProxy";
const String _excludeAppsKey = "excludeApps";
const String _listenAllInterfacesKey = "listenAllInterfaces";
const String _usernameKey = "username";
const String _passwordKey = "password";
const String _selectedServerAddressKey = "selectedServerAddress";
const String _selectedServerP2PAllowedKey = "selectedServerP2PAllowed";
const String _selectedServerPlusKey = "selectedServerPlus";
const String _excludedAppsListKey = "excludedAppsList";
const String _newsLoadedNumberKey = "newsLoadedNumber";
const String _rssFileName = "rss.txt";
const String _logFileName = "log.txt";
const String _binaryInstalledKey = "binaryInstalled";
const Locale englishLocale = Locale("en");
const Locale persianLocale = Locale("fa");
const Locale chineseTWLocale = Locale.fromSubtags(
    languageCode: "zh", scriptCode: "Hant", countryCode: "TW");
const Locale chineseCNLocale = Locale.fromSubtags(
    languageCode: "zh", scriptCode: "Hans", countryCode: "CN");

enum RoutingMode {
  auto,
  bridges,
}

enum Protocol {
  auto,
  udp,
  tls,
}

enum ServiceState {
  disconnected,
  connecting,
  connected,
}

class SettingsProvider extends ChangeNotifier {
  SettingsProvider._();

  static SettingsProvider? _instance;
  late final SharedPreferences _sharedPreferences;
  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  bool get networkVPN => _networkVPN;
  bool get excludePRC => _excludePRC;
  bool get autoProxy => _autoProxy;
  bool get excludeApps => _excludeApps;
  List<String> get excludedAppsList => _excludedAppsList;
  bool get listenAllInterfaces => _listenAllInterfaces;
  RoutingMode get routingMode => _routingMode;
  Protocol get protocol => _protocol;
  AccountData? get accountData => _accountData;
  ServerInfo? get selectedServer => _selectedServer;
  int get newsLoadedNumber => _newsLoadedNumber;
  String get rssFeed => _rssFeed;
  bool get lastNewsFetched => _lastNewsFetched;
  bool get newNewsAvailable => _newNewsAvailable;
  String get log => _log;
  ServiceState get serviceState => _serviceState;
  bool get binaryInstalled => _binaryInstalled;
  String get exportPath => _exportPath;
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  bool _networkVPN = false;
  bool _excludePRC = false;
  bool _autoProxy = true;
  bool _excludeApps = false;
  List<String> _excludedAppsList = [];
  bool _listenAllInterfaces = false;
  RoutingMode _routingMode = RoutingMode.auto;
  Protocol _protocol = Protocol.auto;
  AccountData? _accountData;
  ServerInfo? _selectedServer;
  int _newsLoadedNumber = 0;
  String _rssFeed = "";
  bool _lastNewsFetched = false;
  bool _newNewsAvailable = false;
  String _log = "";
  late File _logFile;
  late File _rssFile;
  ServiceState _serviceState = ServiceState.disconnected;
  bool _binaryInstalled = false;
  String _exportPath = "";

  static Future<SettingsProvider> instance({SharedPreferences? sp}) async {
    if (_instance != null) {
      return _instance!;
    }
    final settings = SettingsProvider._();
    await settings._initialize(sp: sp);
    _instance = settings;
    return _instance!;
  }

  Future<void> _initialize({SharedPreferences? sp}) async {
    if (_instance != null) return;
    _sharedPreferences = sp ?? await SharedPreferences.getInstance();
    //TODO: Delete this in prod after tests
    // await _sharedPreferences.clear();

    _networkVPN = _sharedPreferences.getBool(_networkVPNKey) ?? _networkVPN;
    _excludePRC = _sharedPreferences.getBool(_excludePRCKey) ?? _excludePRC;
    _autoProxy = _sharedPreferences.getBool(_autoProxyKey) ?? _autoProxy;
    _excludeApps = _sharedPreferences.getBool(_excludeAppsKey) ?? _excludeApps;
    _excludedAppsList =
        _sharedPreferences.getStringList(_excludedAppsListKey) ?? [];
    _listenAllInterfaces =
        _sharedPreferences.getBool(_listenAllInterfacesKey) ??
            _listenAllInterfaces;
    _accountData = _getAccountData();
    _selectedServer = _getSelectedServer();
    _newsLoadedNumber =
        _sharedPreferences.getInt(_newsLoadedNumberKey) ?? _newsLoadedNumber;
    _logFile = await _getLogFile();
    _log = await _loadLog();
    _routingMode = _getRoutingMode();
    _protocol = _getProtocol();
    _themeMode = _getThemeMode();
    _locale = _getLocale();
    _rssFile = await _getRssFile();
    _rssFeed = await _getRssFeed();
    _binaryInstalled =
        _sharedPreferences.getBool(_binaryInstalledKey) ?? _binaryInstalled;
    _exportPath = await _getExportPath();

    _serviceState = _getServiceState();
  }

  Future<void> setBinaryInstalled(value) async {
    await _sharedPreferences.setBool(_binaryInstalledKey, value);
    _binaryInstalled = value;
    notifyListeners();
  }

  void setNewNewsAvailable(bool value) {
    _newNewsAvailable = value;
    notifyListeners();
  }

  void setLastNewsFetched(bool value) {
    _lastNewsFetched = value;
    notifyListeners();
  }

  ServiceState _getServiceState() {
    return ServiceState.disconnected;
  }

  void setServiceState(ServiceState value) {
    _serviceState = value;
    notifyListeners();
  }

  RoutingMode _getRoutingMode() {
    final currentRoutingMode = _sharedPreferences.getString(_routingModeKey) ??
        _routingMode.toString();
    RoutingMode response = _routingMode;

    if (currentRoutingMode == RoutingMode.bridges.toString()) {
      response = RoutingMode.bridges;
    }
    return response;
  }

  Protocol _getProtocol() {
    final currentProtocol =
        _sharedPreferences.getString(_protocolKey) ?? _protocol.toString();
    Protocol response = _protocol;

    if (currentProtocol == Protocol.udp.toString()) {
      response = Protocol.udp;
    } else if (currentProtocol == Protocol.tls.toString()) {
      response = Protocol.tls;
    }
    return response;
  }

  ThemeMode _getThemeMode() {
    final currentTheme =
        _sharedPreferences.getString(_themeModeKey) ?? _themeMode.toString();
    ThemeMode response = _themeMode;

    if (currentTheme == ThemeMode.light.toString()) {
      response = ThemeMode.light;
    } else if (currentTheme == ThemeMode.dark.toString()) {
      response = ThemeMode.dark;
    }
    return response;
  }

  Locale? _getLocale() {
    final String? currentLocale = _sharedPreferences.getString(_localeKey);
    Locale? response;

    if (currentLocale == englishLocale.toString()) {
      response = englishLocale;
    } else if (currentLocale == chineseCNLocale.toString()) {
      response = chineseCNLocale;
    } else if (currentLocale == chineseTWLocale.toString()) {
      response = chineseTWLocale;
    } else if (currentLocale == persianLocale.toString()) {
      response = persianLocale;
    }
    return response;
  }

  Future<File> _getRssFile() async {
    final String rssPath;
    if (Platform.isWindows) {
      rssPath = "\\$_rssFileName";
    } else {
      rssPath = "/$_rssFileName";
    }

    final docDirectory = await getApplicationSupportDirectory();
    return File(docDirectory.path + rssPath);
  }

  Future<String> _getExportPath() async {
    final String exportPath;
    final docDir = await getApplicationDocumentsDirectory();
    if (Platform.isWindows) {
      exportPath = "${docDir.path}\\exported_log.txt";
    } else {
      exportPath = "${docDir.path}/exported_log.txt";
    }
    return exportPath;
  }

  Future<String> _getRssFeed() async {
    if (!await _rssFile.exists()) {
      await _rssFile.writeAsString("", flush: true);
    }
    final rssContent = await _rssFile.readAsString();
    return rssContent;
  }

  Future<File> _getLogFile() async {
    final String addedLogPath;
    if (Platform.isWindows) {
      addedLogPath = "\\$_logFileName";
    } else {
      addedLogPath = "/$_logFileName";
    }

    final docDirectory = await getApplicationSupportDirectory();
    return File(docDirectory.path + addedLogPath);
  }

  Future<String> _loadLog() async {
    if (!await _logFile.exists()) {
      await _logFile.writeAsString("", flush: true);
    }
    final logContent = await _logFile.readAsString();
    return logContent;
  }

  void setLog(String value) {
    _log = value;
    notifyListeners();
  }

  Future<void> writeLogFile() async {
    await _logFile.writeAsString(_log, flush: true);
  }

  Future<void> exportLogFile() async {
    await writeLogFile();
    await File(exportPath).writeAsString(_log, flush: true);
  }

  AccountData? _getAccountData() {
    final username = _sharedPreferences.getString(_usernameKey);
    final password = _sharedPreferences.getString(_passwordKey);
    if (username == null || password == null) return null;
    return AccountData(username: username, password: password);
  }

  Future<void> setAccountData(AccountData value) async {
    await _sharedPreferences.setString(_usernameKey, value.username);
    await _sharedPreferences.setString(_passwordKey, value.password);
    _accountData = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await _sharedPreferences.remove(_usernameKey);
    await _sharedPreferences.remove(_passwordKey);
    _accountData = null;
    unsetSelectedServer();
    notifyListeners();
  }

  ServerInfo? _getSelectedServer() {
    final address = _sharedPreferences.getString(_selectedServerAddressKey);
    final isP2P = _sharedPreferences.getBool(_selectedServerP2PAllowedKey);
    final isPlus = _sharedPreferences.getBool(_selectedServerPlusKey);

    if (address == null || isP2P == null || isPlus == null) return null;
    return ServerInfo(address: address, plus: isPlus, p2pAllowed: isP2P);
  }

  Future<void> setSelectedServer(ServerInfo value) async {
    await _sharedPreferences.setString(
        _selectedServerAddressKey, value.address);
    await _sharedPreferences.setBool(_selectedServerPlusKey, value.plus);
    await _sharedPreferences.setBool(
        _selectedServerP2PAllowedKey, value.p2pAllowed);

    _selectedServer = value;
    notifyListeners();
  }

  Future<void> unsetSelectedServer() async {
    await _sharedPreferences.remove(_selectedServerAddressKey);
    await _sharedPreferences.remove(_selectedServerPlusKey);
    await _sharedPreferences.remove(_selectedServerP2PAllowedKey);

    _selectedServer = null;
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    await _sharedPreferences.setString(_localeKey, value.toString());
    _locale = value;
    notifyListeners();
  }

  Future<void> setNetworkVPN(bool value) async {
    await _sharedPreferences.setBool(_networkVPNKey, value);
    _networkVPN = value;
    notifyListeners();
  }

  Future<void> setExcludePRC(bool value) async {
    await _sharedPreferences.setBool(_excludePRCKey, value);
    _excludePRC = value;
    notifyListeners();
  }

  Future<void> setAutoProxy(bool value) async {
    await _sharedPreferences.setBool(_autoProxyKey, value);
    _autoProxy = value;
    notifyListeners();
  }

  Future<void> setExcludeApps(bool value) async {
    await _sharedPreferences.setBool(_excludeAppsKey, value);
    _excludeApps = value;
    notifyListeners();
  }

  Future<void> setListenAllInterfaces(bool value) async {
    await _sharedPreferences.setBool(_listenAllInterfacesKey, value);
    _listenAllInterfaces = value;
    notifyListeners();
  }

  Future<void> setRoutingMode(RoutingMode value) async {
    await _sharedPreferences.setString(_routingModeKey, value.toString());
    _routingMode = value;
    notifyListeners();
  }

  Future<void> setProtocol(Protocol value) async {
    await _sharedPreferences.setString(_protocolKey, value.toString());
    _protocol = value;
    notifyListeners();
  }

  Future<void> setNewsLoadedNumber(int value) async {
    await _sharedPreferences.setInt(_newsLoadedNumberKey, value);
    _newsLoadedNumber = value;
    notifyListeners();
  }

  Future<void> setRssFeed(String value) async {
    _rssFeed = value;
    await _writeRssFile();
    notifyListeners();
  }

  Future<void> _writeRssFile() async {
    await _rssFile.writeAsString(_rssFeed, flush: true);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    await _sharedPreferences.setString(_themeModeKey, value.toString());
    _themeMode = value;
    notifyListeners();
  }
}
