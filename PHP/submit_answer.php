<?php
include_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $database = new Database();
    $db = $database->getConnection();
    
    $data = json_decode(file_get_contents("php://input"));
    
    if(isset($data->user_id) && isset($data->question_id) && isset($data->user_answer)) {
        $user_id = $data->user_id;
        $question_id = $data->question_id;
        $user_answer = $data->user_answer;
        
        // Get correct answer
        $query = "SELECT correct_option FROM questions WHERE id = :question_id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":question_id", $question_id);
        $stmt->execute();
        
        if($stmt->rowCount() == 1) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            $is_correct = ($user_answer == $row['correct_option']);
            
            // Save attempt
            $insert_query = "INSERT INTO attempts (user_id, question_id, user_answer, is_correct) 
                            VALUES (:user_id, :question_id, :user_answer, :is_correct)";
            $insert_stmt = $db->prepare($insert_query);
            $insert_stmt->bindParam(":user_id", $user_id);
            $insert_stmt->bindParam(":question_id", $question_id);
            $insert_stmt->bindParam(":user_answer", $user_answer);
            $insert_stmt->bindParam(":is_correct", $is_correct);
            
            if($insert_stmt->execute()) {
                jsonResponse(true, "Answer submitted", [
                    'is_correct' => $is_correct,
                    'correct_answer' => $row['correct_option']
                ]);
            } else {
                jsonResponse(false, "Failed to save attempt");
            }
        } else {
            jsonResponse(false, "Question not found");
        }
    } else {
        jsonResponse(false, "All fields are required");
    }
}
?>