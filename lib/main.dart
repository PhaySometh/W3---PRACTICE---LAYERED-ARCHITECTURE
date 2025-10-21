import 'dart:io';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';
import 'data/QuizRepository.dart';

void main() {
  QuizRepository repository = QuizRepository('lib/data/quiz_data.json');
  Quiz quiz;

  // Check if JSON file exists
  if (File('lib/data/quiz_data.json').existsSync()) {
    // Load from existing file
    print('\n----------------------------');
    print('Loading quiz from file...');
    quiz = repository.readQuiz();
    print('Loaded ${quiz.questions.length} questions');
    print('Loaded ${quiz.submissions.length} previous submissions\n');
  } else {
    // Create new quiz and save it
    print('No quiz file found. Creating new quiz...');
    List<Question> questions = [
      Question(
          title: "Capital of Cambodia?",
          choices: ["Phnom Penh", "Tokyo", "Duma"],
          goodChoice: "Phnom Penh",
          points: 10),
      Question(
          title: "2 + 2 = ?",
          choices: ["2", "4", "67"],
          goodChoice: "4",
          points: 50),
    ];
    quiz = Quiz(questions: questions);

    // Save initial quiz (will create lib/data/quiz_data.json)
    repository.writeQuiz(quiz);
    print('Quiz saved to lib/data/quiz_data.json\n');
  }

  // Start the quiz console
  QuizConsole console = QuizConsole(quiz: quiz);
  console.startQuiz();

  // Save after quiz ends (with all new submissions!)
  repository.writeQuiz(quiz);
  print('\nAll submissions saved to lib/data/quiz_data.json!');
}
