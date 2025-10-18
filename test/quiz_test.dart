import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

main() {
  // Create a quiz test with 2 questions and the answers to the 2 questions
  test('My first test', () {
    Question q1 =
        Question(title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);
    Question q2 =
        Question(title: "4+2", choices: ["1", "2", "3"], goodChoice: "6", points: 20);

    Quiz quiz = Quiz(questions: [q1, q2]);

    // Answer are all good
    quiz.addAnswer(Answer(question: q1, answerChoice: "2"));
    quiz.addAnswer(Answer(question: q2, answerChoice: "6"));

    // Check the score is the expected score (as example: 100, 50 or 0)
    expect(quiz.getScoreInPercentage(), equals(100));
    expect(quiz.getScoreInPoints(), equals(30));
  });
}
