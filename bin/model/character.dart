import 'dart:io';
import 'monster.dart';
import 'unit.dart';

class Character extends Unit {
  Character(super.name, super.hp, super.attack, super.defend);

  //객체 문자열 변환
  @override
  String toString() {
    return '$name, $hp, $attack, $defend';
  }

  //캐릭터 파일 저장
  Future<void> saveCharacterToFile() async {
    await File('characters.txt').writeAsString(
      '$hp, $attack, $defend', //파일구조 -> 체력,공격력,방어력
    );
  }

  static Future<Character> loadFromFile(String name) async {
    final file = File('characters.txt');
    final contents = await file.readAsString();
    final parts = contents.trim().split(',');

    if (parts.length != 3) throw FormatException('invaild characterdata');

    return Character(
      name,
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override //추상 매써드 사용
  attackTarget(Unit target) {
    //몬스터에게 공격을 가함
    target.hp -= attack;
    print('$name이(가) ${target.name}에게 $attack만큼 데미지를 입혔습니다.\n');
  }

  characterDefend(Monster monster) {
    //방어 시 몬스터가 입힌 데미지 만큼 캐릭터의 체력을 상승시킴
    hp += monster.attack;
    print('$name이(가) 방어 태세를 취하여 ${monster.attack}만큼 체력을 얻었습니다.');
  }

  showStatus() {
    //캐릭터의 현재 체력, 공격력, 방어력을 매 턴마다 출력함
    print("$name - 체력: $hp, 공격력: $attack, 방어력: $defend");
  }
}
