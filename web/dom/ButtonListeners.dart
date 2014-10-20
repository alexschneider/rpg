part of dom;

// TODO: We probably want a better way to handle multiple things needing the
// same data. For now, we'll just assume that consumers of the future return
// the characters, so we can chain then calls.
Future<Iterable<DiabolicalCharacter>> characterListFuture;

void initializeListeners() {
  querySelector('#random-character').onClick.listen(handleRandomCharacter);
  querySelector('#list-all-characters').onClick.listen(handleListAll);
  querySelector('#create-character').onClick.listen(handleCreateCharacter);
  characterListFuture = DiabolicalApi.getAllCharacters();
}

void handleModifyCharacter(DiabolicalCharacter c) {
  updateFieldsFromCharacter(c);
  setCreateModifyCharacterText('Modify your character', 'Modify');
}

void handleListAll(_) {
  handleClearModal('#list-characters');
  characterListFuture.then((Iterable<DiabolicalCharacter> characters) {
    generateModalFromCharacters(characters);
    return characters;
  });
}

void handleRandomCharacter(_) {
  DiabolicalApi.generateRandomCharacter()
      .then(updateFieldsFromCharacter);
}

void handleCreateCharacter(_) {
  setCreateModifyCharacterText('Create your character', 'Create');
}

void handleDeleteCharacter(DiabolicalCharacter c) {
  DiabolicalApi.deleteCharacter(c)
      .then((_) {
        querySelector('#row-${c.id}').remove();
        characterListFuture = DiabolicalApi.getAllCharacters();
  });
}