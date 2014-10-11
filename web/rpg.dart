import 'dart:html';
import 'package:dquery/dquery.dart';
import 'src/Diabolical.dart';

void initializeListeners() {
  querySelector('#random-character').onClick.listen(generateRandomCharacter);
}

updateFieldsFromCharacter(DiabolicalCharacter char, String idPrefix) {
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

void generateRandomCharacter(_) {
  DiabolicalApi.generateRandomCharacter().then((DiabolicalCharacter char) =>
      updateFieldsFromCharacter(char, 'create'));
}

void main() {
  initializeListeners();
}