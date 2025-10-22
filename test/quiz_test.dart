import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

void main() {
  Question q1 = Question(
    title: "Capital of France?",
    choices: ["Paris", "London", "Rome"],
    goodChoice: "Paris",
    points: 60,
  );
  Question q2 = Question(
    title: "2 + 2 = ?",
    choices: ["2", "4", "5"],
    goodChoice: "4",
    points: 40,
  );

  Player p1 = Player(name: 'pich');
  Player p2 = Player(name: 'poy');
  Player p3 = Player(name: 'pin');

  Quiz quizP1 = Quiz(player: p1, questions: [q1, q2]);
  Quiz quizP2 = Quiz(player: p2, questions: [q1, q2]);
  Quiz quizP3 = Quiz(player: p3, questions: [q1, q2]);

  test('All answers correct (100%) answered by pich', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Paris');
    Answer a2 = Answer(question: q2, answerChoice: '4');

    quizP1.player.answers = [a1, a2];

    expect(quizP1.getScoreInPercentage(), 100);
    expect(quizP1.getScore(), 100);
  });

  test('One answer wrong (50%) answered by poy', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Paris');
    Answer a2 = Answer(question: q2, answerChoice: '5');

    quizP2.player.answers = [a1, a2];

    expect(quizP2.getScoreInPercentage(), 50);
    expect(quizP2.getScore(), 60);
  });

  test('All answers wrong (0%) answered by pin', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Rome');
    Answer a2 = Answer(question: q2, answerChoice: '5');

    quizP3.player.answers = [a1, a2];

    expect(quizP3.getScoreInPercentage(), 0);
    expect(quizP3.getScore(), 0);
  });
}
