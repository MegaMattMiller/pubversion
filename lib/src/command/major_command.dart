// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

/// Command to execute pub run build_runner build.
class MajorCommand extends Command<int> {
  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'major';

  @override
  final description = 'Imcrement major version number.';

  Version _nextMajorVersion;

  MajorCommand();

  @override
  Future<int> run() async {
    var unsupported =
        argResults.rest.where((arg) => !arg.startsWith('-')).toList();
    if (unsupported.isNotEmpty) {
      throw UsageException(
          'Arguments were provided that are not supported: '
          '"${unsupported.join(' ')}".',
          argParser.usage);
    }
    var extraArgs =
        argResults.rest.where((arg) => arg.startsWith('-')).toList();

    final file = new File('test.yaml');
    String contents = await file.readAsString();
    Pubspec currentPubspec = new Pubspec.parse(contents);
    _nextMajorVersion =
        new Version.parse(currentPubspec.version.nextMajor.toString());

    List<String> lines = await file.readAsLines();
    List<String> outputLines = new List<String>();
    for (String line in lines) {
      if (line.trim().startsWith("version:")) {
        outputLines.add("version: ${_nextMajorVersion}");
      }
      else
      {
        outputLines.add(line);
      }
    }

    String output = outputLines.join("\n");

    final outputFile = new File('test.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
  }
}
