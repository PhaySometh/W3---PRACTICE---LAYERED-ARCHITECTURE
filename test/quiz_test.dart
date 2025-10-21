import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

main() {
  // Test 1: Single player with all correct answers
  test('Single player - all correct answers', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);
    Question q2 = Question(
        title: "4+2", choices: ["1", "2", "6"], goodChoice: "6", points: 20);

    Quiz quiz = Quiz(questions: [q1, q2]);
    Player player = Player(name: "Test Player");

    List<Answer> answers = [
      Answer(questionId: q1.id, answerChoice: "2"),
      Answer(questionId: q2.id, answerChoice: "6"),
    ];
    Submission submission = Submission(player: player, answers: answers);
    quiz.addSubmission(submission);

    expect(submission.getScoreInPercentage(quiz), equals(100));
    expect(submission.getScoreInPoints(quiz), equals(30));
  });

  // Test 2: Multiple players with different scores
  test('Multiple players - different scores', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);
    Question q2 = Question(
        title: "4+2", choices: ["1", "2", "6"], goodChoice: "6", points: 20);

    Quiz quiz = Quiz(questions: [q1, q2]);

    // Player 1: All correct
    Player alice = Player(name: "Alice");
    Submission aliceSubmission = Submission(
      player: alice,
      answers: [
        Answer(questionId: q1.id, answerChoice: "2"),
        Answer(questionId: q2.id, answerChoice: "6"),
      ],
    );
    quiz.addSubmission(aliceSubmission);

    // Player 2: One correct
    Player bob = Player(name: "Bob");
    Submission bobSubmission = Submission(
      player: bob,
      answers: [
        Answer(questionId: q1.id, answerChoice: "2"),
        Answer(questionId: q2.id, answerChoice: "1"),
      ],
    );
    quiz.addSubmission(bobSubmission);

    expect(aliceSubmission.getScoreInPercentage(quiz), equals(100));
    expect(aliceSubmission.getScoreInPoints(quiz), equals(30));
    expect(bobSubmission.getScoreInPercentage(quiz), equals(50));
    expect(bobSubmission.getScoreInPoints(quiz), equals(10));
    expect(quiz.submissions.length, equals(2));
  });

  // Test 3: Player replays - score overwritten
  test('Player replays - previous score overwritten', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);

    Quiz quiz = Quiz(questions: [q1]);
    Player alice = Player(name: "Alice");

    // First attempt: Wrong
    Submission firstAttempt = Submission(
      player: alice,
      answers: [Answer(questionId: q1.id, answerChoice: "1")],
    );
    quiz.addSubmission(firstAttempt);

    // Second attempt: Correct
    Submission secondAttempt = Submission(
      player: alice,
      answers: [Answer(questionId: q1.id, answerChoice: "2")],
    );
    quiz.addSubmission(secondAttempt);

    expect(quiz.submissions.length, equals(1));
    expect(quiz.submissions[0].player.name, equals("Alice"));
    expect(quiz.submissions[0].getScoreInPoints(quiz), equals(10));
  });

  // Test 4: Player with all wrong answers - 0%
  test('Player with all wrong answers - 0%', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);

    Quiz quiz = Quiz(questions: [q1]);
    Player player = Player(name: "Charlie");

    Submission submission = Submission(
      player: player,
      answers: [Answer(questionId: q1.id, answerChoice: "1")],
    );

    expect(submission.getScoreInPercentage(quiz), equals(0));
    expect(submission.getScoreInPoints(quiz), equals(0));
  });
}
