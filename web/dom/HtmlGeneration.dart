part of dom;

void updateFieldsFromCharacter(DiabolicalCharacter char) {
  var el = getCharacterElements();

  el['name'].value = char.name;
  if (char.gender != null) {
    var gender = char.gender.toLowerCase();
    el['gender-$gender'].checked = true;
  }
  el['class'].value = char.classType;
  el['level'].value = char.level.toString();
  el['money'].value = char.money.toString();
}

Map<String, InputElement> getCharacterElements() => {
    'name': querySelector('#character-name'),
    'gender-male': querySelector('#character-gender-male'),
    'gender-female': querySelector('#character-gender-female'),
    'class': querySelector('#character-class'),
    'level': querySelector('#character-level'),
    'money': querySelector('#character-money')
};

void generateModalFromCharacters(Iterable<DiabolicalCharacter> characters) {
  var listCharacterModal = querySelector('#list-characters') as DivElement;
  var rows = characters.map(generateRowFromCharacter);
  var closeButton = new AnchorElement()
      ..classes.add('close-reveal-modal fi-x-circle');
  listCharacterModal.children..addAll(rows)..add(closeButton);

  // We need to make sure foundation knows about our newly generated HTML
  reinitializeFoundation();
}

DivElement generateRowFromCharacter(DiabolicalCharacter character) {
  var attributes = [
    character.name,
    character.gender,
    character.classType,
    character.level,
    character.money
  ];
  var row = new DivElement()
      ..classes.add('row')
      ..children.addAll(attributes.map(generateColumnFromAttribute))
      ..id = 'row-${character.id}';

  row.children.add(generateCharacterDropDown(character));

  return row;
}

DivElement generateCharacterDropDown(DiabolicalCharacter character) {
  var useCharacter = new AnchorElement()
      ..appendText('Use character');

  var characterSaved = savedCharacterIds().contains(character.id);
  var saveUnsaveCharacter = new AnchorElement()
      ..appendText(characterSaved ? 'Unsave character' : 'Save character')
      ..onClick.listen((_) => toggleSavedCharacter(character))
      ..onClick.listen((_) => querySelector('.toggle-topbar').click());

  var modifyCharacter = new AnchorElement()
      ..appendText('Modify character')
      ..onClick.listen((_) => handleModifyCharacter(character));

  var deleteCharacter = new AnchorElement()
      ..appendText('Delete character')
      ..onClick.listen((_) => handleDeleteCharacter(character));

  deleteCharacter.onClick.listen((_) =>
      deleteCharacter.parent.parent.classes.remove('open'));

  var characterLIs = [useCharacter, saveUnsaveCharacter, modifyCharacter, deleteCharacter]
      .map((ButtonElement b) => new LIElement()..children.add(b));

  var dropDown = new UListElement()
      ..children.addAll(characterLIs)
      ..classes.addAll(['f-dropdown'])
      ..dataset['dropdown-content'] = ''
      ..id = 'dropdown-${character.id}';

  var dropDownButton = new ButtonElement()
      ..classes.addAll(['small', 'expand', 'round', 'dropdown'])
      ..dataset['dropdown'] = 'dropdown-${character.id}'
      ..appendText('Actions');
  return generateColumn()..children.addAll([dropDownButton, dropDown]);
}

DivElement generateColumnFromAttribute(Object attribute) =>
    generateColumn()..appendText(attribute.toString());

DivElement generateColumn() =>
    new DivElement()..classes.addAll(['small-2', 'columns']);

void setCreateModifyCharacterText(String headerText, String buttonText,
                                  Function buttonCallback) {
  querySelector('#create-modify-header').text = headerText;
  querySelector('#create-modify-button')
      ..text = buttonText
      ..onClick.listen(buttonCallback);

}

/// [reinitializeFoundation] must be called after inserting this element.
DivElement generateAlert(String cssClass, String text) {
  var alertDiv = new DivElement()
      ..classes.addAll(['alert-box', cssClass, 'temp'])
      ..dataset['alert'] = ''
      ..text = text;

  var closeButton = new ButtonElement()
      ..classes.addAll(['close'])
      ..setInnerHtml("&times;");

  alertDiv.append(closeButton);

  return alertDiv;
}

void clearAllTemp() => querySelectorAll('.temp').forEach((Element e) => e.remove());