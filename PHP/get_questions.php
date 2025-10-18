<?php
include_once 'db.php';

$database = new Database();
$db = $database->getConnection();

// Get number of questions from request (default to 10)
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 10;
$limit = max(1, min($limit, 50)); // Limit between 1 and 50

$query = "SELECT id, question, option_a, option_b, option_c, option_d, correct_option 
          FROM questions ORDER BY RAND() LIMIT :limit";
$stmt = $db->prepare($query);
$stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
$stmt->execute();

$questions = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $questions[] = [
        'id' => $row['id'],
        'question' => $row['question'],
        'options' => [
            'A' => $row['option_a'],
            'B' => $row['option_b'],
            'C' => $row['option_c'],
            'D' => $row['option_d']
        ],
        'correct_option' => $row['correct_option']
    ];
}

jsonResponse(true, "Questions fetched successfully", [
    'questions' => $questions,
    'total' => count($questions)
]);
?>