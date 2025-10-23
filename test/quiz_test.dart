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

  Quiz quiz = Quiz(players: [p1, p2, p3], questions: [q1, q2]);

  test('All answers correct (100%) answered by pich', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Paris');
    Answer a2 = Answer(question: q2, answerChoice: '4');

    quiz.addAnswer(p1, a1);
    quiz.addAnswer(p1, a2);

    expect(quiz.getScoreInPercentage(p1), 100);
    expect(quiz.getScore(p1), 100);
  });

  test('One answer wrong (50%) answered by poy', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Paris');
    Answer a2 = Answer(question: q2, answerChoice: '5');

    quiz.addAnswer(p2, a1);
    quiz.addAnswer(p2, a2);

    expect(quiz.getScoreInPercentage(p2), 50);
    expect(quiz.getScore(p2), 60);
  });

  test('All answers wrong (0%) answered by pin', () {
    Answer a1 = Answer(question: q1, answerChoice: 'Rome');
    Answer a2 = Answer(question: q2, answerChoice: '5');

    quiz.addAnswer(p3, a1);
    quiz.addAnswer(p3, a2);

    expect(quiz.getScoreInPercentage(p3), 0);
    expect(quiz.getScore(p3), 0);
  });
}
