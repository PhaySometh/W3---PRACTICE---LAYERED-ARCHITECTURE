import 'dart:io';
import 'dart:convert';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;

  QuizRepository(this.filePath);

  /// Reads a Quiz from a JSON file
  Quiz readQuiz() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content) as Map<String, dynamic>;

    // Parse questions
    var questionsJson = data['questions'] as List;
    var questions = questionsJson.map((q) {
      return Question(
        id: q['id'],
        title: q['title'],
        choices: List<String>.from(q['choices']),
        goodChoice: q['goodChoice'],
        points: q['points'] ?? 1,
      );
    }).toList();

    // Create quiz
    Quiz quiz = Quiz(
      id: data['id'],
      questions: questions,
    );

    // Parse submissions (if any)
    if (data.containsKey('submissions')) {
      var submissionsJson = data['submissions'] as List;
      for (var subJson in submissionsJson) {
        Player player = Player(name: subJson['playerName']);

        var answersJson = subJson['answers'] as List;
        List<Answer> answers = answersJson.map((a) {
          return Answer(
            id: a['id'],
            questionId: a['questionId'],
            answerChoice: a['answerChoice'],
          );
        }).toList();

        Submission submission = Submission(player: player, answers: answers);
        quiz.addSubmission(submission);
      }
    }

    return quiz;
  }

  /// Writes a Quiz to a JSON file (BONUS)
  void writeQuiz(Quiz quiz) {
    Map<String, dynamic> data = {
      'id': quiz.id,
      'questions': quiz.questions.map((q) {
        return {
          'id': q.id,
          'title': q.title,
          'choices': q.choices,
          'goodChoice': q.goodChoice,
          'points': q.points,
        };
      }).toList(),
      'submissions': quiz.submissions.map((sub) {
        return {
          'playerName': sub.player.name,
          'answers': sub.answers.map((a) {
            return {
              'id': a.id,
              'questionId': a.questionId,
              'answerChoice': a.answerChoice,
            };
          }).toList(),
        };
      }).toList(),
    };

    final file = File(filePath);
    file.writeAsStringSync(jsonEncode(data));
    print('Quiz saved to $filePath');
  }
}
