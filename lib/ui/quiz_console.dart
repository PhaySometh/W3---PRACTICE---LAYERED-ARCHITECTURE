import 'dart:io';
import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;

  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');

    // Loop for multiple players
    while (true) {
      stdout.write("Your name: ");
      String? playerName = stdin.readLineSync();

      // Exit if name is empty
      if (playerName == null || playerName.isEmpty) {
        print('--- Quiz Finished ---');
        break;
      }

      Player player = Player(name: playerName);

      for (var question in quiz.questions) {
        print(
            'Question: ${question.title} - ( ${question.points} points)'); // Fixed spacing
        print('Choices: ${question.choices}');
        stdout.write('Your answer: ');
        String? userInput = stdin.readLineSync();

        if (userInput != null && userInput.isNotEmpty) {
          Answer answer = Answer(question: question, answerChoice: userInput);
          player.addAnswer(answer);
        } else {
          print('No answer entered. Skipping question.');
        }
      }

      quiz.addPlayer(player);

      int scoreInPercentage = player.getScoreInPercentage(quiz.questions);
      int scoreInPoints = player.getScoreInPoints(); // Fixed variable name

      // Fixed output format with player name
      print('$playerName, your score in percentage: $scoreInPercentage %');
      print('$playerName, your score in points: $scoreInPoints');

      // Display all players' scores
      for (var p in quiz.players) {
        int points = p.getScoreInPoints();
        print('Player: ${p.name}\t\tScore:$points');
      }
    }
  }
}
