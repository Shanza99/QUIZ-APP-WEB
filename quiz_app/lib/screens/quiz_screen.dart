import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final User user;
  final int questionCount;

  const QuizScreen({
    super.key,
    required this.user,
    required this.questionCount,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  bool _isLoading = true;
  bool _showResult = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.getQuestions();
      setState(() {
        _questions = questions.take(widget.questionCount).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to load questions: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
      _showResult = true;
      
      // Check if answer is correct
      final currentQuestion = _questions[_currentQuestionIndex];
      if (answer == currentQuestion.correctOption) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showResult = false;
      });
    } else {
      _showFinalResults();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _showResult = false;
      });
    }
  }

  void _showFinalResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score/${_questions.length}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Percentage: ${((_score / _questions.length) * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            },
            child: const Text('Back to Dashboard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              setState(() {
                _currentQuestionIndex = 0;
                _userAnswers.clear();
                _score = 0;
                _showResult = false;
              });
            },
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${_currentQuestionIndex + 1}/${_questions.length}'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('No questions available'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                      ),
                      const SizedBox(height: 20),

                      // Question
                      Text(
                        'Q${_currentQuestionIndex + 1}: ${_questions[_currentQuestionIndex].question}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: _questions[_currentQuestionIndex].options.length,
                          itemBuilder: (context, index) {
                            final optionKey = _questions[_currentQuestionIndex].options.keys.elementAt(index);
                            final optionText = _questions[_currentQuestionIndex].options[optionKey]!;
                            final isSelected = _userAnswers[_currentQuestionIndex] == optionKey;
                            final isCorrect = optionKey == _questions[_currentQuestionIndex].correctOption;
                            
                            Color? backgroundColor;
                            if (_showResult) {
                              if (isCorrect) {
                                backgroundColor = Colors.green.withOpacity(0.2);
                              } else if (isSelected && !isCorrect) {
                                backgroundColor = Colors.red.withOpacity(0.2);
                              }
                            }

                            return Card(
                              color: backgroundColor,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: Text(
                                  '$optionKey.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Text(optionText),
                                trailing: _showResult
                                    ? isCorrect
                                        ? const Icon(Icons.check_circle, color: Colors.green)
                                        : isSelected
                                            ? const Icon(Icons.cancel, color: Colors.red)
                                            : null
                                    : null,
                                onTap: _showResult ? null : () => _selectAnswer(optionKey),
                              ),
                            );
                          },
                        ),
                      ),

                      // Result and Navigation
                      if (_showResult) ...[
                        const SizedBox(height: 20),
                        Card(
                          color: _userAnswers[_currentQuestionIndex] == _questions[_currentQuestionIndex].correctOption
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  _userAnswers[_currentQuestionIndex] == _questions[_currentQuestionIndex].correctOption
                                      ? '✅ Correct! Well done!'
                                      : '❌ Incorrect! The correct answer is ${_questions[_currentQuestionIndex].correctOption}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_userAnswers[_currentQuestionIndex] != _questions[_currentQuestionIndex].correctOption)
                                  Text(
                                    'Correct answer: ${_questions[_currentQuestionIndex].options[_questions[_currentQuestionIndex].correctOption]}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Navigation buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Previous'),
                          ),
                          ElevatedButton(
                            onPressed: _userAnswers.containsKey(_currentQuestionIndex) ? _nextQuestion : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667eea),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              _currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}