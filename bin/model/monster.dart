import 'dart:math';
import 'unit.dart';

class Monster extends Unit {
  Monster(String name, int hp, int attack)
    : super(name, hp, attack, 0); // 몬스터는 방어력 0으로 설정

  //리스트 -> 파일 문자열 전환(파일 저장용)
  @override
  String toString() {
    return "$name, $hp, $attack";
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

  @override
  void attackTarget(Unit target) {
    // 몬스터 -> 캐릭터 공격
    //  int damage = MonsterVaule -Charater defendValue
    int randomAttack = Random().nextInt(attack + 1);
    int fixedAttack = max(randomAttack, target.defend); //더 큰 값 반환
    int damage = fixedAttack - target.defend;
    if (damage < 0) damage = 0; // min damage =>0
    target.hp -= damage;
    print('$name이(가) ${target.name}에게 $damage 의 데미지를 입혔습니다.');
  }

  showStatus() {
    //몬스터 현재 체력과 공격력을 매 턴 마다 출력
    print('$name - 체력: $hp, 공격력: $attack');
  }
}
