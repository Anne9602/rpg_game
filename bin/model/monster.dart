import 'dart:math';

import 'character.dart';

class Monster {
  String monsterName;
  int monsterHp;
  int attack;
  int dependValue = 0;

  Monster(this.monsterName, this.monsterHp, this.attack);

  //리스트 -> 파일 문자열 전환(파일 저장용)
  @override
  String toString() {
    return "$monsterName, $monsterHp, $attack";
  }

  //파일 -> 리스트화 작업 (파일 불러오기용)
  factory Monster.fromString(String line) {
    //factory = 생성자 앞에 붙어 직접 객체를 반환하도록 함
    final parts = line.split(',');
    if (parts.length != 3) {
      //잘못된 형식에 대한 오류 방지
      throw FormatException('invaild monster data: $line');
    }
    return Monster(parts[0], int.parse(parts[1]), int.parse(parts[2]));
  }

  //
  void attackCharacter(Character character) {
    // 몬스터 -> 캐릭터 공격
    //  int damage = MonsterVaule -Charater defendValue
    int randomAttack = Random().nextInt(attack + 1);
    int fixedAttack = max(randomAttack, character.defendValue); //더 큰 값 반환
    int damage = fixedAttack - character.defendValue;
    if (damage < 0) damage = 0; // min damage =>0
    character.hp -= damage;
    print('$monsterName이(가) ${character.name}에게 $damage 의 데미지를 입혔습니다.');
  }

  showStatus() {
    //몬스터 현재 체력과 공격력을 매 턴 마다 출력
    print('$monsterName - 체력: $monsterHp, 공격력: $attack');
  }
}
