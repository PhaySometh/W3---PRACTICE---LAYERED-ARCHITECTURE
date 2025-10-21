import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class Question {
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int points;

  Question({
    String? id,
    required this.title,
    required this.choices,
    required this.goodChoice,
    this.points = 1,
  }) : id = id ?? _uuid.v4();
  
}

class Answer {
  final String id;
  final String questionId; // Changed from Question question to String questionId (ID reference)
  final String answerChoice;

  Answer({
    String? id, // Allow passing custom ID
    required this.questionId,
    required this.answerChoice,
  }) : id = id ?? _uuid.v4();

  bool isGood(Quiz quiz) {
    final question = quiz.getQuestionById(questionId);
    return question != null && answerChoice == question.goodChoice;
  }
}

class Player {
  final String name;

  Player({required this.name});
}

class Submission {
  final Player player;
  final List<Answer> answers;

  Submission({required this.player, required this.answers});

  int getScoreInPercentage(Quiz quiz) {
    int totalScore = 0;
    for (Answer answer in answers) {
      if (answer.isGood(quiz)) {
        totalScore++;
      }
    }
    return quiz.questions.isEmpty
        ? 0
        : ((totalScore / quiz.questions.length) * 100).toInt();
  }

  int getScoreInPoints(Quiz quiz) {
    int totalScoreInPoint = 0;
    for (Answer answer in answers) {
      if (answer.isGood(quiz)) {
        final question = quiz.getQuestionById(answer.questionId);
        if (question != null) {
          totalScoreInPoint += question.points;
        }
      }
    }
    return totalScoreInPoint;
  }
}

class Quiz {
  final String id;
  final List<Question> questions;
  final List<Submission> submissions = [];

  Quiz({
    String? id,
    required this.questions,
  }) : id = id ?? _uuid.v4();

  void addSubmission(Submission submission) {
    // Remove old submission from same player (overwrite)
    submissions.removeWhere((s) => s.player.name == submission.player.name);
    submissions.add(submission);
  }

  Submission? getSubmissionFor(String playerName) {
    try {
      return submissions.firstWhere((s) => s.player.name == playerName);
    } catch (e) {
      return null;
    }
  }

  Answer? getAnswerById(String id) {
    try {
      for (var submission in submissions) {
        final answer = submission.answers.firstWhere((a) => a.id == id);
        return answer;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Question? getQuestionById(String id) {
    try {
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}
