import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show ByteData;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class ConnectionManager {
  // static Isolate? _staticProcessIsolate;
  // static int? _staticProcessId;

  static Future<void> connect(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.setServiceState(ServiceState.connecting);

    final binaryPath = await _getBinaryPath(context);

    if (!context.mounted) return;
    final args = _getArgs(context);

    // _staticProcessIsolate = await _startConnection(context, binaryPath, args);
    await _startConnection(context, binaryPath, args);

    settingsProvider.setServiceState(ServiceState.connected);
  }

  static Future<void> disconnect(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    // if (_staticProcessId != null) {
    //   Process.killPid(_staticProcessId!);
    // }
    // final processIsolate = _staticProcessIsolate;
    // Future.delayed(Duration(seconds: 2), () {
    //   processIsolate?.kill();
    // });

    await Process.run("sudo", ["killall", "geph4-client"]);

    settingsProvider.setServiceState(ServiceState.disconnected);
  }

  static Future<void> _startConnection(
    BuildContext context,
    String binaryPath,
    List<String> args,
  ) async {
    // final settingsProvider = context.read<SettingsProvider>();
    final process = await Process.start("sudo", [
      binaryPath,
      ...args,
    ]);

    process.stdout.pipe(stdout);
    process.stderr.pipe(stderr);
    // _staticProcessId = process.pid;

    // process.stderr.transform(utf8.decoder).listen((event) {
    //   settingsProvider.setLog(settingsProvider.log + event);
    //   print(settingsProvider.log);
    // });
    // final rPort = ReceivePort();
    //
    // rPort.listen((message) {
    //   final output = message as (int, List<int>);
    //   _staticProcessId = output.$1;
    //   stderr.add(output.$2);
    // });
    //
    // final processIsolate =
    //     await Isolate.spawn((sendPort) async {}, rPort.sendPort);
    //
    // return processIsolate;
  }

  static List<String> _getArgs(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final args = ["connect"];
    if (settingsProvider.networkVPN) {
      args.addAll(["--vpn-mode", "tun-route"]);
    } else {
      if (settingsProvider.excludePRC) {
        args.add("--exclude-prc");
      }
      if (settingsProvider.autoProxy) {
        //TODO
      }
    }
    if (settingsProvider.listenAllInterfaces) {
      //TODO
    }
    if (settingsProvider.routingMode == RoutingMode.bridges) {
      args.add("--use-bridges");
    }
    if (settingsProvider.protocol == Protocol.udp) {
      //TODO
      args.addAll(["--force-protocol", ""]);
    } else if (settingsProvider.protocol == Protocol.tls) {
      //TODO
      args.addAll(["--force-protocol", ""]);
    }
    args.addAll(["--exit-server", settingsProvider.selectedServer!.address]);

    args.addAll([
      "auth-password",
      "--username",
      settingsProvider.accountData!.username,
      "--password",
      settingsProvider.accountData!.password,
    ]);

    return args;
  }

  static Future<String> _getBinaryPath(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    final docDir = await getApplicationSupportDirectory();
    File installedBinaryFile;
    ByteData gephAssetData;
    if (Platform.isWindows) {
      installedBinaryFile = File("${docDir.path}\\geph4-client.exe");
    } else {
      installedBinaryFile = File("${docDir.path}/geph4-client");
    }

    if (!settingsProvider.binaryInstalled) {
      if (!context.mounted) {
        throw StateError(
            "Context should be attached but isn't. this was the context: $context");
      }
      if (Platform.isLinux) {
        gephAssetData =
            await DefaultAssetBundle.of(context).load("assets/geph4-client");
      } else {
        //TODO
        gephAssetData =
            await DefaultAssetBundle.of(context).load("assets/geph4-client");
      }
      await installedBinaryFile.writeAsBytes(gephAssetData.buffer.asInt8List());

      if (Platform.isLinux) {
        await Process.run("chmod", ["+x", installedBinaryFile.path]);
      }

      await settingsProvider.setBinaryInstalled(true);
    }
    return installedBinaryFile.path;
  }
}
