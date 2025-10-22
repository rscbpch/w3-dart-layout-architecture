import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Question {
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int points;

  Question({String? id, required this.title, required this.choices, required this.goodChoice, this.points = 1}) : id = uuid.v4();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      title: json['title'] as String,
      choices: List<String>.from(json['choices']),
      goodChoice: json['goodChoice'] as String,
      points: (json['points'] is int) ? json['points'] as int : int.tryParse('${json['points']}') ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'choices': choices,
      'goodChoice': goodChoice,
      'points': points,
    };
  }
}

class Answer {
  final String id;
  final Question question;
  final String answerChoice;

  Answer({String? id, required this.question, required this.answerChoice}) : id = uuid.v4();

  factory Answer.fromJson(Map<String, dynamic> json, Map<String, Question> questionById) {
    final qid = json['questionId'] as String?;
    return Answer(
      id: json['id'] as String,
      question: questionById[qid]!,
      answerChoice: json['answerChoice'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': question.id,
      'answerChoice': answerChoice,
    };
  }

  bool isGood() {
    return answerChoice == question.goodChoice;
  }
}

class Player {
  final String id;
  final String name;
  List<Answer> answers;

  Player({String? id, required this.name, List<Answer>? answers})  : id = uuid.v4(), answers = answers ?? [];

  factory Player.fromJson(Map<String, dynamic> json, Map<String, Question> questionById) {
    final answersJson = json['answers'] as List<dynamic>? ?? [];
    final answers = answersJson.map((a) => Answer.fromJson(a as Map<String, dynamic>, questionById)).toList();

    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class Quiz {
  final Player player;
  List<Question> questions;

  Quiz({required this.player, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List<dynamic>;
    final questions = questionsJson.map((q) => Question.fromJson(q as Map<String, dynamic>)).toList();

    final questionById = {for (var q in questions) q.id: q};

    Player player;
    if (json.containsKey('player') && json['player'] is Map<String, dynamic>) {
      player = Player.fromJson(json['player'] as Map<String, dynamic>, questionById);
    } else {
      player = Player(name: '');
    }
    return Quiz(player: player, questions: questions);
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
      'player': player.toJson(),
    };
  }

  void addAnswer(Answer answer) {
    player.answers.add(answer);
  }

  int getScore() {
    int totalScore = 0;
    for (Answer answer in player.answers) {
      if (answer.isGood()) {
        totalScore += answer.question.points;
      }
    }
    return totalScore;
  }

  int getScoreInPercentage() {
    int totalCorrect = 0;
    for (Answer answer in player.answers) {
      if (answer.isGood()) totalCorrect++;
    }
    if (questions.isEmpty) return 0;
    return ((totalCorrect / questions.length) * 100).toInt();
  }
}
