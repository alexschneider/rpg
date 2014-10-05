import 'dart:html';
import 'dart:convert';
import 'dart:async';

class DiabolicalApi {

  static const _diabolicalJsonHeaders = const {
    'Accept' : 'application/json, text/javascript, */*; q=0.01'
  };

  static Future<Iterable<DiabolicalCharacter>> getAllCharacters() =>
      HttpRequest.request('http://lmu-diabolical.appspot.com/characters',
                        method: 'GET',
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
          .then((HttpRequest res) {
            List<Map<String, dynamic>> characters = res.response;
            return characters.map((Map<String, dynamic> character) =>
                new DiabolicalCharacter._fromMap(character));
    });

  static Future<DiabolicalCharacter> getCharacter(int id) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters/$id',
                        method: 'GET',
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((HttpRequest res) =>
            new DiabolicalCharacter._fromMap(res.response));

  /// Returns a future for the character ID
  static Future<int> createCharacter(DiabolicalCharacter c) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters',
                        method: 'POST',
                        sendData: JSON.encode(c.toMap()),
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((HttpRequest res) =>
            res.getResponseHeader('Location').split('/').last);

  /// Returns a future for null
  static Future updateCharacter(DiabolicalCharacter c) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters/${c.id}',
                        method: 'POST',
                        sendData: JSON.encode(c.toMap()),
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((_) => null);

  static Future deleteCharacterFromId(int id) =>
      HttpRequest.request('http://lmu-diabolical.appspot.com/characters/$id',
                          method: 'DELETE',
                          responseType: 'json',
                          requestHeaders: _diabolicalJsonHeaders)
          .then((_) => null);

  static Future deleteCharacter(DiabolicalCharacter c) => deleteCharacterFromId(c.id);

  // TODO: Handle Item Creation
}

class DiabolicalCharacter {
  int id, level, money;
  String classType, gender, name;

  DiabolicalCharacter(this.classType, Gender gender, this.level, this.money, this.name)
    : this.gender     = gender._gender;

  DiabolicalCharacter._fromMap(Map characterMap)
    : id         = characterMap['id'],
      classType  = characterMap['classType'],
      gender     = characterMap['gender'],
      level      = characterMap['level'],
      money      = characterMap['money'],
      name       = characterMap['name'];

  Map<String, dynamic> toMap() {
    var characterMap = {
      'classType':  this.classType,
      'gender':     this.gender,
      'level':      this.level,
      'money':      this.money,
      'name':       this.name
    };

    if (id != null) {
      characterMap['id'] = id;
    }

    return characterMap;
  }
}

class Gender {
  String _gender;
  Gender.male(): _gender = 'MALE';
  Gender.female(): _gender = 'FEMALE';
}