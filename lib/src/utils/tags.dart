abstract class Tag {
  get name;
}

// Tag8 has a maximum name size of 8 bytes
class Tag8 extends Tag {
  final String _name;
  Tag8(this._name) {
    if (_name.length > 8) {
      throw ArgumentError('the string exceeds the maximum size of 8 bytes.');
    }
  }

  @override
  get name => _name;
}

// Tag16 has a maximum name size of 16 bytes
class Tag16 extends Tag {
  final String _name;
  Tag16(this._name) {
    if (_name.length > 16) {
      throw ArgumentError('the string exceeds the maximum size of 16 bytes.');
    }
  }
  @override
  get name => _name;
}
