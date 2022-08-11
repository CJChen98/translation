library translation;

class Translation {
  final List<String> to;
  final String from;
  final String name;

  const Translation({required this.name, required this.from, required this.to});
}

class ConvertEnumToString {
  final List enums;

  const ConvertEnumToString({required this.enums});
}

class From {
  const From();
}

class Keys {
  const Keys();
}
