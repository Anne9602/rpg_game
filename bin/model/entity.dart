// unit.dart
abstract class Unit {
  String name;
  int hp;
  int attack;
  int defend;
  Unit(this.name, this.hp, this.attack, this.defend);

  void attackTarget(Unit target); // 추상 메서드
}
