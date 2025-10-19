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

    player.addAnswer(Answer(question: q1, answerChoice: "2"));
    player.addAnswer(Answer(question: q2, answerChoice: "6"));

    expect(player.getScoreInPercentage(quiz.questions), equals(100));
    expect(player.getScoreInPoints(), equals(30));
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
    alice.addAnswer(Answer(question: q1, answerChoice: "2"));
    alice.addAnswer(Answer(question: q2, answerChoice: "6"));
    quiz.addPlayer(alice);

    // Player 2: One correct
    Player bob = Player(name: "Bob");
    bob.addAnswer(Answer(question: q1, answerChoice: "2"));
    bob.addAnswer(Answer(question: q2, answerChoice: "1"));
    quiz.addPlayer(bob);

    expect(alice.getScoreInPercentage(quiz.questions), equals(100));
    expect(alice.getScoreInPoints(), equals(30));
    expect(bob.getScoreInPercentage(quiz.questions), equals(50));
    expect(bob.getScoreInPoints(), equals(10));
    expect(quiz.players.length, equals(2));
  });

  // Test 3: Player replays - score overwritten
  test('Player replays - previous score overwritten', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);

    Quiz quiz = Quiz(questions: [q1]);

    // First attempt: Wrong
    Player alice1 = Player(name: "Alice");
    alice1.addAnswer(Answer(question: q1, answerChoice: "1"));
    quiz.addPlayer(alice1);

    // Second attempt: Correct
    Player alice2 = Player(name: "Alice");
    alice2.addAnswer(Answer(question: q1, answerChoice: "2"));
    quiz.addPlayer(alice2);

    expect(quiz.players.length, equals(1));
    expect(quiz.players[0].name, equals("Alice"));
    expect(quiz.players[0].getScoreInPoints(), equals(10));
  });

  // Test 4: Player with all wrong answers - 0%
  test('Player with all wrong answers - 0%', () {
    Question q1 = Question(
        title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", points: 10);

    Quiz quiz = Quiz(questions: [q1]);
    Player player = Player(name: "Charlie");

    player.addAnswer(Answer(question: q1, answerChoice: "1")); // Wrong

    expect(player.getScoreInPercentage(quiz.questions), equals(0));
    expect(player.getScoreInPoints(), equals(0));
  });
}
