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

  Player({required this.name});
}

class Quiz {
  List<Question> questions;
  List<Answer> answers = [];
  List<Player> players = []; 

  Quiz({required this.questions});

  void addAnswer(Answer answer) {
    this.answers.add(answer);
  }

  int getScoreInPercentage() {
    int totalSCore = 0;
    for (Answer answer in answers) {
      if (answer.isGood()) {
        totalSCore++;
      }
    }
    return ((totalSCore / questions.length) * 100).toInt();
  }

  int getScoreInPoints() {
    int totalScoreInPoint = 0;
    for (Answer answer in answers) {
      if (answer.isGood()) {
        // Add the question's point value when the answer is correct
        totalScoreInPoint += answer.question.points;
      }
    }
    return totalScoreInPoint;
  }
}
