import 'dart:io';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';
import 'data/QuizRepository.dart';

void main() {
  QuizRepository repository = QuizRepository('lib/data/quiz_data.json');
  Quiz quiz;

  List<Question> allQuestions = [
    Question(
        title: "Capital of Cambodia?",
        choices: ["Phnom Penh", "Paris Saint Germain", "Ching Chong"],
        goodChoice: "Phnom Penh",
        points: 10),
    Question(
        title: "2 + 2 = ?",
        choices: ["2", "4", "6", "8"],
        goodChoice: "4",
        points: 50),
  ];

  // Check if JSON file exists
  if (File('lib/data/quiz_data.json').existsSync()) {
    // Load from existing file
    print('\n----------------------------');
    print('Loading quiz from file...');
    quiz = repository.readQuiz();
    print('Loaded ${quiz.questions.length} questions');
    print('Loaded ${quiz.submissions.length} previous submissions\n');

    int newQuestionsAdded = 0;
    int questionsUpdated = 0;
    int questionsDeleted = 0;

    // ADD or UPDATE questions
    for (var newQuestion in allQuestions) {
      int existingIndex =
          quiz.questions.indexWhere((q) => q.title == newQuestion.title);

      if (existingIndex == -1) {
        quiz.questions.add(newQuestion);
        newQuestionsAdded++;
        print('Added new question: "${newQuestion.title}"');
      } else {
        Question existing = quiz.questions[existingIndex];
        if (existing.choices.join(',') != newQuestion.choices.join(',') ||
            existing.goodChoice != newQuestion.goodChoice ||
            existing.points != newQuestion.points) {
          quiz.questions[existingIndex] = newQuestion;
          questionsUpdated++;
          print('Updated question: "${newQuestion.title}"');
        }
      }
    }

    // REMOVE deleted questions
    List<Question> questionsToRemove = [];
    for (var existingQuestion in quiz.questions) {
      bool stillExists = allQuestions.any((q) => q.title == existingQuestion.title);
      if (!stillExists) {
        questionsToRemove.add(existingQuestion);
        questionsDeleted++;
        print('Deleted question: "${existingQuestion.title}"');
      }
    }

    for (var question in questionsToRemove) {
      quiz.questions.remove(question);
    }

    if (newQuestionsAdded > 0 || questionsUpdated > 0 || questionsDeleted > 0) {
      print('$newQuestionsAdded new, $questionsUpdated updated, $questionsDeleted deleted!');
      repository.writeQuiz(quiz);
    } else {
      print('No changes detected.');
    }
  } else {
    print('No quiz file found. Creating new quiz...');
    quiz = Quiz(questions: allQuestions);
    repository.writeQuiz(quiz);
    print('Quiz saved to lib/data/quiz_data.json with ${allQuestions.length} questions\n');
  }

  QuizConsole console = QuizConsole(quiz: quiz);
  console.startQuiz();

  repository.writeQuiz(quiz);
  print('\nAll submissions saved to lib/data/quiz_data.json!');
}
