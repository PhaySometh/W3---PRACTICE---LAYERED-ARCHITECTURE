class Question {
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int points;

  Question(
      {required this.title,
      required this.choices,
      required this.goodChoice,
      this.points = 1});
}

class Answer {
  final Question question;
  final String answerChoice;

  Answer({required this.question, required this.answerChoice});

  bool isGood() {
    return this.answerChoice == question.goodChoice;
  }
}

class Player {
  final String name;
  final List<Answer> answers = [];

  Player({required this.name});

  void addAnswer(Answer answer) {
    this.answers.add(answer);
  }

  int getScoreInPercentage(List<Question> questions) {
    int totalScore = 0;
    for (Answer answer in answers) {
      if (answer.isGood()) {
        totalScore++;
      }
    }
    return ((totalScore / questions.length) * 100).toInt();
  }

  int getScoreInPoints() {
    int totalScoreInPoint = 0;
    for (Answer answer in answers) {
      if (answer.isGood()) {
        totalScoreInPoint += answer.question.points;
      }
    }
    return totalScoreInPoint;
  }
}

class Quiz {
  List<Question> questions;
  List<Player> players = [];

  Quiz({required this.questions});

  void addPlayer(Player player) {
    players.removeWhere((p) => p.name == player.name);
    players.add(player);
  }

  Player? getPlayerFor(String playerName) {
    try {
      return players.firstWhere((p) => p.name == playerName);
    } catch (e) {
      return null;
    }
  }
}
