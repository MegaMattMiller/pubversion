[![Pub Package](https://img.shields.io/pub/v/pubversion.svg)](https://pub.dartlang.org/packages/pubversion)
[![Build Status](https://travis-ci.org/MegaMattMiller/pubversion.svg?branch=master)](https://travis-ci.org/MegaMattMiller/pubversion)
[![Dart Version](https://img.shields.io/badge/dart-%5E2.0.0-green.svg?branch=master)](https://img.shields.io/badge/dart-%5E2.0.0-green.svg)
[![GitHub issues](https://img.shields.io/github/issues-raw/MegaMattMiller/pubversion.svg)](https://github.com/MegaMattMiller/pubversion/issues)
[![CodeFactor](https://www.codefactor.io/repository/github/megamattmiller/pubversion/badge)](https://www.codefactor.io/repository/github/megamattmiller/pubversion)

A command-line tool for easily incrementing pubspec.yaml version numbers.

## Installation

`pubversion` is not meant to be used as a dependency. Instead, it should be
["activated"][activating].

```console
$ pub global activate pubversion
# or
$ flutter pub global activate pubversion
```

Learn more about activating and using packages [here][pub global].

## Usage

`pubversion` provides three commands:

* `major`
* `minor`
* `patch`

### `pubversion major`

```
$ pubversion major
test_package upgraded from 1.2.1 to 2.0.0
```

### `pubversion minor`

```
$ pubversion minor
test_package upgraded from 1.0.1 to 1.1.0
```

### `pubversion patch`

```
$ pubversion patch
test_package upgraded from 1.0.0 to 1.0.1
```


[activating]: https://www.dartlang.org/tools/pub/cmd/pub-global#activating-a-package
[pub global]: https://www.dartlang.org/tools/pub/cmd/pub-global
