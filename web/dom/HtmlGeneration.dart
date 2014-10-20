part of dom;

void updateFieldsFromCharacter(DiabolicalCharacter char) {
  (querySelector('#character-name')
      as InputElement).value = char.name;
  (querySelector('#character-gender-${char.gender.toLowerCase()}')
      as RadioButtonInputElement).checked = true;
  (querySelector('#character-class')
      as InputElement).value = char.classType;
  (querySelector('#character-level')
      as InputElement).value = char.level.toString();
  (querySelector('#character-money')
      as InputElement).value = char.money.toString();
}

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

  var modifyCharacter = new AnchorElement()
      ..appendText('Modify character');
      //..onClick.listen((_) => handleModifyCharacter(character))
      //..onClick.listen((_) => handleCloseModal('#list-characters'));

  var deleteCharacter = new AnchorElement()
      ..appendText('Delete character')
      ..onClick.listen((_) => handleDeleteCharacter(character));

  deleteCharacter.onClick.listen((_) =>
      deleteCharacter.parent.parent.classes.remove('open'));

  var characterLIs = [useCharacter, modifyCharacter, deleteCharacter]
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