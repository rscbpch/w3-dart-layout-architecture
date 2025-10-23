import 'dart:io';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';
import 'data/quiz_file_provider.dart';

void main() {
  const quizFilePath = 'data/quiz.json';
  final repo = QuizRepository(quizFilePath);

  final Map<String, int> scoreboard = {};
  final List<Player> currentRunPlayers = [];

  print('--- Welcome to the Quiz ---\n');
  while (true) {
    stdout.write('Your name: ');
    String? name = stdin.readLineSync();

    if (name == null || name.trim().isEmpty) {
      print('--- Quiz Finished ---');
      break;
    }

    Quiz fileQuiz = repo.readQuiz();
    final List<Question> questions = fileQuiz.questions;

    Player player = Player(name: name);
    currentRunPlayers.add(player);

    Quiz quiz = Quiz(players: currentRunPlayers, questions: questions);
    
    QuizConsole console = QuizConsole(quiz: quiz);
    console.startQuiz(player);

    try {
      repo.writePlayers(currentRunPlayers, questions);
    } catch (e) {
      print('Failed to save player answers: $e');
    }

    final int scoreInPoints = quiz.getScore(player);
    scoreboard[player.name] = scoreInPoints;
    console.printResult(player, scoreboard);
  }
}
