part of diabolical;

class DiabolicalCharacter {
  int _id;
  int level, money;
  String classType, _gender, name;

  DiabolicalCharacter(this.classType, Gender gender, this.level, this.money, this.name)
    : this.gender     = gender._gender;

  DiabolicalCharacter._fromMap(Map characterMap)
    : _id         = characterMap['id'],
      classType  = characterMap['classType'],
      _gender     = characterMap['gender'],
      level      = characterMap['level'],
      money      = characterMap['money'],
      name       = characterMap['name'];

  Map<String, dynamic> toMap() {
    var characterMap = {
        'classType':  this.classType,
        'gender':     this._gender,
        'level':      this.level,
        'money':      this.money,
        'name':       this.name
    };

    if (_id != null) {
      characterMap['id'] = _id;
    }

    return characterMap;
  }

  get id => _id;
  get gender => _gender;
  set gender (Gender g) => _gender = g._gender;
}

class Gender {
  String _gender;
  Gender.male(): _gender = 'MALE';
  Gender.female(): _gender = 'FEMALE';
}
