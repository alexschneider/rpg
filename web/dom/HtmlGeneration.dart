part of dom;

void updateFieldsFromCharacter(DiabolicalCharacter char, String idPrefix) {
  (querySelector('#${idPrefix}-character-name')
      as InputElement).value = char.name;
  (querySelector('#${idPrefix}-character-gender-${char.gender.toLowerCase()}')
      as RadioButtonInputElement).checked = true;
  (querySelector('#${idPrefix}-character-class')
      as InputElement).value = char.classType;
  (querySelector('#${idPrefix}-character-level')
      as InputElement).value = char.level.toString();
  (querySelector('#${idPrefix}-character-money')
      as InputElement).value = char.money.toString();
}

void generateModalFromCharacters(Iterable<DiabolicalCharacter> characters) {
  var listCharacterModal = querySelector('#list-characters') as DivElement;
  var rows = characters.map(generateRowFromCharacter);
  var closeButton = new AnchorElement()
      ..classes.add('close-reveal-modal fi-x-circle')
      ..onClick.listen((_) => handleCloseModal(listCharacterModal));
  listCharacterModal.children..addAll(rows)..add(closeButton);
}

DivElement generateRowFromCharacter(DiabolicalCharacter character) {
  var characterButton = new AnchorElement()
    ..classes.addAll(['button', 'small', 'expand', 'round'])
    ..appendText('Use character')
    ..onClick.listen((_) => handleSelectCharacter(character));
  var characterButtonColumn = generateColumn()..children.add(characterButton);
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
    ..children.add(characterButtonColumn);

  return row;
}

DivElement generateColumnFromAttribute(Object attribute) =>
    generateColumn()..appendText(attribute.toString());

DivElement generateColumn() =>
    new DivElement()..classes.addAll(['small-2', 'columns']);