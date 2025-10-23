import 'dart:io';
import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;

  QuizConsole({required this.quiz});

  void startQuiz(Player player) {
    print('');
    for (var question in quiz.questions) {
      print('Question: ${question.title} - ( ${question.points} points )');
      print('Choices: ${question.choices}');
      stdout.write('Your answer: ');
      String? userInput = stdin.readLineSync();

      if (userInput != null && userInput.isNotEmpty) {
        Answer answer = Answer(question: question, answerChoice: userInput);
        quiz.addAnswer(player, answer);
      } else {
        print('No answer entered. Skipping question.\n');
      }
    }
  }

  void printResult(Player player, Map<String, int> allPlayerScore) {
    int scoreInPercentage = quiz.getScoreInPercentage(player);
    int scoreInPoints = quiz.getScore(player);

    print('');
    print('${player.name}, your score in percentage: $scoreInPercentage %');
    print('${player.name}, your score in points: $scoreInPoints\n');

    allPlayerScore[player.name] = scoreInPoints;

    for (var entry in allPlayerScore.entries) {
      print('Player: ${entry.key}\tScore:${entry.value}');
    }
    print('');
  }
}
