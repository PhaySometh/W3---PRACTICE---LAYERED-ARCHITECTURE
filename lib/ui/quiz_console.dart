import 'dart:io';

import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;

  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n\n');
    stdout.write("Your name: ");
    String? userInput = stdin.readLineSync();

    if (userInput != null && userInput.isNotEmpty) {

    }
    

    for (var question in quiz.questions) {
      print('Question: ${question.title} - (${question.points} points)');
      print('Choices: ${question.choices}');
      stdout.write('Your answer: ');
      String? userInput = stdin.readLineSync();

      // Check for null input
      if (userInput != null && userInput.isNotEmpty) {
        Answer answer = Answer(question: question, answerChoice: userInput);
        quiz.addAnswer(answer);
      } else {
        print('No answer entered. Skipping question.');
      }

      print('');
    }

    int ScoreInPercentage = quiz.getScoreInPercentage();
    int ScoreInPoint = quiz.getScoreInPoints();
    print('Your score in percentage: $ScoreInPercentage % correct');
    print('Your score in points: $ScoreInPoint');
    print('--- Quiz Finished ---');
  }
}
