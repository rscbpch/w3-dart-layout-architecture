import 'dart:convert';
import 'dart:io';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;

  QuizRepository(this.filePath);

  Quiz readQuiz() {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception("File not found at: $filePath");
      }

      final content = file.readAsStringSync();
      final data = jsonDecode(content);
      return Quiz.fromJson(data);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
  
  void writePlayers(List<Player> players, List<Question> questions) {
    try {
      final outFile = File(filePath);
      final outDir = outFile.parent;
      if (!outDir.existsSync()) {
        outDir.createSync(recursive: true);
      }

      final scoringQuiz = Quiz(players: players, questions: questions);

      final List<Map<String, dynamic>> playersJson = players.map((p) {
        final map = p.toJson();
        map['points'] = scoringQuiz.getScore(p);
        map['percentage'] = scoringQuiz.getScoreInPercentage(p);
        return map;
      }).toList();

      final Map<String, dynamic> data = {
        'questions': questions.map((q) => q.toJson()).toList(),
        'players': playersJson,
      };

      final encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(data);
      outFile.writeAsStringSync(jsonString);
    } catch (e) {
      print("Error writing quiz to $filePath: $e");
      rethrow;
    }
  }
}
