part of diabolical;


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
            if (res.status != 200) {
              throw new DiabolicalApiException('API Issue', res);
            }
            List<Map<String, dynamic>> characters = res.response;
            return characters.map((Map<String, dynamic> character) {
              new DiabolicalCharacter._fromMap(character);
      });
    });

  static Future<DiabolicalCharacter> getCharacter(int id) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters/$id',
                        method: 'GET',
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((HttpRequest res) {
          if (res.status != 200) {
            throw new DiabolicalApiException('Character not found', res);
          }
          return new DiabolicalCharacter._fromMap(res.response);
    });

  /// Returns a future for the character ID
  static Future<int> createCharacter(DiabolicalCharacter c) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters',
                        method: 'POST',
                        sendData: JSON.encode(c.toMap()),
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((HttpRequest res) {
          if (res.status != 201) {
            throw new DiabolicalApiException('Character not created', res);
          }
          int id = res.getResponseHeader('Location').split('/').last;
          c._id = id;
          return id;
    });

  /// Returns a future for null
  static Future updateCharacter(DiabolicalCharacter c) =>
    HttpRequest.request('http://lmu-diabolical.appspot.com/characters/${c.id}',
                        method: 'POST',
                        sendData: JSON.encode(c.toMap()),
                        responseType: 'json',
                        requestHeaders: _diabolicalJsonHeaders)
        .then((HttpRequest res) {
          if (res.status != 204) {
            throw new DiabolicalApiException('Character not updated', res);
          }
          return null;
    });
  /// Returns a future for null
  static Future deleteCharacterFromId(int id) =>
      HttpRequest.request('http://lmu-diabolical.appspot.com/characters/$id',
                          method: 'DELETE',
                          responseType: 'json',
                          requestHeaders: _diabolicalJsonHeaders)
          .then((HttpRequest res) {
            if (res.status != 204) {
              throw new DiabolicalApiException('Character not updated', res);
            }
            return null;
      });

  static Future deleteCharacter(DiabolicalCharacter c) => deleteCharacterFromId(c.id);

  static Future<DiabolicalItem> createRandomItem(int level, String slot) =>
      HttpRequest.request('http://lmu-diabolical.appspot.com/items/spawn',
                          method: 'GET',
                          sendData: JSON.encode({level: level, slot: slot}),
                          responseType: 'json',
                          requestHeaders: _diabolicalJsonHeaders)
          .then((HttpRequest res) {
            if (res.status != 200) {
              throw new DiabolicalApiException('Error fetching item', res);
            }
            return new DiabolicalItem._fromMap(res.response);
      });

  /// The character returned by this future must be created by using createCharacter
  static Future<DiabolicalCharacter> generateRandomCharacter() =>
      HttpRequest.request('http://lmu-diabolical.appspot.com/characters/spawn',
                          method: 'get',
                          responseType: 'json',
                          requestHeaders: _diabolicalJsonHeaders)
          .then((HttpRequest res) {
            if (res.status != 201) {
              throw new DiabolicalApiException('Character not created', res);
            }
            return res.getResponseHeader('Location').split('/').last;
  });
}

class DiabolicalApiException implements Exception {
  final String _cause;
  final HttpRequest response;
  const DiabolicalApiException(this._cause, this.response);
  String toString () => _cause == null ? 'Diabolical' : _cause;
}