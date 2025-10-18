<?php
include_once 'db.php';

$database = new Database();
$db = $database->getConnection();

// Get total questions
$questions_query = "SELECT COUNT(*) as total FROM questions";
$questions_stmt = $db->prepare($questions_query);
$questions_stmt->execute();
$questions_data = $questions_stmt->fetch(PDO::FETCH_ASSOC);
$total_questions = $questions_data['total'];

// Get total quiz attempts (unique user-quiz sessions)
$quizzes_query = "SELECT COUNT(DISTINCT DATE(attempt_time), user_id) as total FROM attempts";
$quizzes_stmt = $db->prepare($quizzes_query);
$quizzes_stmt->execute();
$quizzes_data = $quizzes_stmt->fetch(PDO::FETCH_ASSOC);
$total_quizzes = $quizzes_data['total'];

// Get success rate
$success_query = "SELECT 
    COUNT(*) as total_attempts,
    SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct_attempts 
    FROM attempts";
$success_stmt = $db->prepare($success_query);
$success_stmt->execute();
$success_data = $success_stmt->fetch(PDO::FETCH_ASSOC);

$success_rate = 0;
if ($success_data['total_attempts'] > 0) {
    $success_rate = round(($success_data['correct_attempts'] / $success_data['total_attempts']) * 100, 1);
}

jsonResponse(true, "Stats loaded successfully", [
    'total_questions' => $total_questions,
    'total_quizzes' => $total_quizzes,
    'success_rate' => $success_rate
]);
?>