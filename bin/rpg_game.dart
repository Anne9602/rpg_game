import 'dart:io';
import 'model/character.dart';
import 'model/game.dart';
import 'model/monster.dart';

Future<void> main() async {
  Game game = Game();

  // 1. 이름입력 및 유효한 이름인지 확인
  late String name;
  while (true) {
    print('캐릭터의 이름을 입력해주세요:');
    String? inputName = stdin.readLineSync();
    if (inputName != null && RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(inputName)) {
      name = inputName;
      break;
    } else {
      print('이름은 영문 또는 한글만 가능합니다.');
    }
  }

  //2. 파일 생성/저장하기
  Character character = Character(name, 50, 10, 5);
  await character.saveCharacterToFile(); //1. 캐릭터 저장
  game.initializeMonster(); //2. 몬스터들 초기화
  await game.saveMonstersToFile(); //3. 몬스터들 파일 저장

  //3. 파일 불러오기
  Character loadedCharacter = await Character.loadFromFile(name);
  List<Monster> loadedMonsters = await Game.loadListFromFile();
  game.character = loadedCharacter; //캐릭터 불러와 객체화
  game.monsters = loadedMonsters; //몬스터 리스트 불러와 객체화

  //4. 게임시작
  print('자, 게임을 시작하지');
  character.showStatus();
  await game.battle();
  game.startGame();
}
