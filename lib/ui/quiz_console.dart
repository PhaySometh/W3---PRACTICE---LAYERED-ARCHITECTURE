import 'dart:io';
import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;

  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--------- Welcome to the Quiz ---------\n');

    // Loop for multiple players
    while (true) {
      stdout.write("Your name(enter to exit): ");
      String? playerName = stdin.readLineSync();

      // Exit if name is empty
      if (playerName == null || playerName.isEmpty) {
        print('\n--------- Quiz Finished ---------');
        break;
      }

      Player player = Player(name: playerName);
      List<Answer> answers = [];

      // Collect answers
      for (var question in quiz.questions) {
        print('\n-----------------------------');
        print('Question: ${question.title} - ( ${question.points} points)');
        print('Choices: ${question.choices}');
        print('----------------------------');
        stdout.write('Your answer(enter to skip): ');
        String? userInput = stdin.readLineSync();

        if (userInput != null && userInput.isNotEmpty) {
          answers.add(Answer(questionId: question.id, answerChoice: userInput));
        } else {
          print('No answer entered. Skipping question.');
        }
      }

      // Create and add submission
      Submission submission = Submission(player: player, answers: answers);
      quiz.addSubmission(submission);

      int scoreInPercentage = submission.getScoreInPercentage(quiz);
      int scoreInPoints = submission.getScoreInPoints(quiz);
      print('\n-----------------------------');
      print('$playerName, your score in percentage: $scoreInPercentage %');
      print('$playerName, your score in points: $scoreInPoints');
      print('-----------------------------\n');

      // Display all submissions
      for (var sub in quiz.submissions) {
        int points = sub.getScoreInPoints(quiz);
        print('Player: ${sub.player.name}\t\tScore:$points');
      }
      if (quiz.submissions.isNotEmpty) {
        print('\n-----------------------------');
      }
    }
  }
}
