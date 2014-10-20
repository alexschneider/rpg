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
  clearAllTemp();
  updateFieldsFromCharacter(c);
  setCreateModifyCharacterText('Modify your character', 'Modify', handleModify);
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
  clearAllTemp();
  updateFieldsFromCharacter(new DiabolicalCharacter.empty());
  setCreateModifyCharacterText('Create your character', 'Create', handleCreate);
}

void handleModify(_) {
  var el = getCharacterElements();
  if (validateCharacterForm(el)) {

  }
}

void handleCreate(_) {
  var el = getCharacterElements();
  if (validateCharacterForm(el)) {
    DiabolicalCharacter dbc = new DiabolicalCharacter(
      el['class'].value,
      el['gender-male'].checked ? new Gender.male() : new Gender.female(),
      int.parse(el['level'].value),
      int.parse(el['money'].value),
      el['name'].value
    );
    DiabolicalApi.createCharacter(dbc).then((int characterId) {
      querySelector('#create-modify-character')
          .insertAdjacentElement('beforeend', generateAlert('success', 'Character created'));
      reinitializeFoundation();
    });
  }
}

bool validateCharacterForm(Map<String, InputElement> el) {
  clearAllTemp();
  var valid = true;
  var radio = 0;
  el.forEach((String key, InputElement val) {
    var elementValid = true;
    if (val.type != 'radio' && val.value == '') {
      elementValid = false;
    } else if (val.type == 'radio' && !val.checked) {
      radio++;
      if(radio == 2) {
        elementValid = false;
      }
    }
    if (!elementValid) {
      val.classes.add('error');
      val.parent.children.add(new Element.tag('small')
          ..classes.addAll(['error', 'temp'])
          ..text = 'Invalid entry');
      valid = false;
    }
  });

  return valid;
}

void handleDeleteCharacter(DiabolicalCharacter c) {
  DiabolicalApi.deleteCharacter(c)
      .then((_) {
        querySelector('#row-${c.id}').remove();
        characterListFuture = DiabolicalApi.getAllCharacters();
  });
}