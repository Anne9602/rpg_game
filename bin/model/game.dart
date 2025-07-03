import 'dart:io';
import 'dart:math';

import 'character.dart';
import 'monster.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];
  int killedMonsters = 0;

  void initializeMonster() {
    //준비작업 1. 몬스터 리스트 만들기
    monsters.addAll([
      Monster('Batman', 30, 20),
      Monster('Spiderman', 20, 30),
      Monster('Superman', 30, 10),
      Monster('Dobi', 38, 10),
    ]);
  }

  //준비작업 2. 리스트 -> 문자열 전환 후 파일에 저장
  Future<void> saveMonstersToFile() async {
    String monsterData = monsters.map((m) => m.toString()).join('\n');
    final file = File('monsters.txt');
    await file.writeAsString(monsterData);
  }

  //준비작업 3. 문자열 ->  리스트화해서 불러오기
  static Future<List<Monster>> loadListFromFile() async {
    final file = File('monsters.txt');
    final lines = await file.readAsLines();
    return lines.map((e) => Monster.fromString(e)).toList();
  }

  startGame() async {
    while (true) {
      //체력이 0이하면 게임 종료
      if (character.hp == 0) {
        print('게임이 종료됩니다.');
        return;
      }

      if (monsters.isEmpty) {
        //설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 승리
        print('VICTORY====천하무적이 되셨습니다.====♬(the End)');
        await saveResult();
        return;
      } else {
        //물리칠때마다 몬스터와 대결한것인지 선택 가능
        print('\n몬스터와 계속 싸우시겠습니까?(y/n)');
        String? input = stdin.readLineSync();

        if (input == 'y') {
          await battle();
        } else if (input == 'n') {
          await saveResult();
          return;
        } else {
          print('잘못 누르셨습니다 y/n중 하나를 골라주세요.');
        }
      }
    }
  }

  Future<void> battle() async {
    //게임 중에 사용자는 매 턴마다 행동을 선택 할 수 있음
    Monster monster = await getRandomMonster();
    while (true) {
      print('\n=============================================');
      print('${character.name}의 턴 \n 행동을 선택하세요(1:공격, 2:방어)');
      print('============================================='); //캐릭터 턴
      String? input = stdin.readLineSync();
      switch (input) {
        case '1':
          character.attackMonster(monster);
          await Future.delayed(Duration(seconds: 2));
          break;
        case '2':
          character.defend(monster);
          await Future.delayed(Duration(seconds: 1));
          break;
        default:
          print('다른 키를 입력하셨습니다.');
          continue; //다시 행동선택으로
      }
      if (monster.monsterHp <= 0) {
        print('만세!! 위대한 용사 ${character.name}이(가) 몬스터를 물리쳤습니다♪');
        break;
      }
      print('=============================================');
      print('${monster.monsterName} 의 턴'); //몬스터 턴
      print('=============================================');
      await Future.delayed(Duration(milliseconds: 1500));
      monster.attackCharacter(character);
      await Future.delayed(Duration(seconds: 1));
      character.showStatus(); //캐릭터 상태 표시
      await Future.delayed(Duration(seconds: 1));
      monster.showStatus(); //캐릭터 상태 표시

      if (character.hp <= 0) {
        print('이런...전사하셨습니다.');
        await Future.delayed(Duration(seconds: 1));
        break;
      }
    }
  }

  Future<Monster> getRandomMonster() async {
    await Future.delayed(Duration(seconds: 2), () {
      print('\n !!!!!새로운 몬스터 출현!!!!!');
    });

    int index = Random().nextInt(monsters.length); //인덱스 번호 추출
    Monster selectedMonster = monsters.removeAt(index);
    print(
      '\n★${selectedMonster.monsterName}-체력: ${selectedMonster.monsterHp}, 공격력: ${selectedMonster.attack}★',
    );
    return selectedMonster;
  }

  //결과 저장하기
  saveResult() async {
    print('결과를 저장하시겠습니까?? (y/n)');
    String? reply = stdin.readLineSync();
    if (reply == 'y') {
      String result = character.hp > 0 ? '승리' : '패배';
      String content =
          '''
이름: ${character.name}
남은 체력: ${character.hp}
결과: $result 
              ''';
      final file = File('result.txt');
      await file.writeAsString(content);
      print('결과가 result.txt파일에 저장되었습니다. \n 저장된 결과들을 확인하시겠습니까?(y/n)');
      String? check = stdin.readLineSync();
      if (check == 'y') {
        String savedResult = await file.readAsString();
        print('\n저장된 결과\n$savedResult');
        return;
      } else {
        return;
      }
    }
  }
}
