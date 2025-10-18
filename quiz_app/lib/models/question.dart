class Question {
  final int id;
  final String question;
  final Map<String, String> options;
  final String correctOption;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: int.parse(json['id'].toString()),
      question: json['question'],
      options: Map<String, String>.from(json['options']),
      correctOption: json['correct_option'],
    );
  }
}