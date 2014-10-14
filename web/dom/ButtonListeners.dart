part of dom;

// TODO: We probably want a better way to handle multiple things needing the
// same data. For now, we'll just assume that consumers of the future return
// the characters
Future<Iterable<DiabolicalCharacter>> characterListFuture;

void initializeListeners() {
  querySelector('#random-character').onClick.listen(handleRandomCharacter);
  querySelector('#list-all-characters').onClick.listen(handleListAll);
  characterListFuture = DiabolicalApi.getAllCharacters();
}

void handleSelectCharacter(DiabolicalCharacter c) {
  //updateFieldsFromCharacter(c, 'update');
}

void handleCloseModal(DivElement modalElement) {
  modalElement.children.clear();
}

void handleListAll(_) {
  characterListFuture.then((Iterable<DiabolicalCharacter> characters) {
    generateModalFromCharacters(characters);
    return characters;
  });
}

void handleRandomCharacter(_) {
  DiabolicalApi.generateRandomCharacter().then((DiabolicalCharacter char) =>
  updateFieldsFromCharacter(char, 'create'));
}