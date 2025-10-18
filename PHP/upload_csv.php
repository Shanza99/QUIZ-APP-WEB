<?php
include_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['csv_file'])) {
    $database = new Database();
    $db = $database->getConnection();
    
    $file = $_FILES['csv_file']['tmp_name'];
    $handle = fopen($file, "r");
    
    $successCount = 0;
    $errorCount = 0;
    $firstRow = true;
    
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        // Skip header row
        if ($firstRow) {
            $firstRow = false;
            continue;
        }
        
        if (count($data) == 6) {
            $question = trim($data[0]);
            $option_a = trim($data[1]);
            $option_b = trim($data[2]);
            $option_c = trim($data[3]);
            $option_d = trim($data[4]);
            $correct_option = strtoupper(trim($data[5]));
            
            // Validate correct option
            if (!in_array($correct_option, ['A', 'B', 'C', 'D'])) {
                $errorCount++;
                continue;
            }
            
            $query = "INSERT INTO questions (question, option_a, option_b, option_c, option_d, correct_option) 
                     VALUES (:question, :option_a, :option_b, :option_c, :option_d, :correct_option)";
            $stmt = $db->prepare($query);
            $stmt->bindParam(":question", $question);
            $stmt->bindParam(":option_a", $option_a);
            $stmt->bindParam(":option_b", $option_b);
            $stmt->bindParam(":option_c", $option_c);
            $stmt->bindParam(":option_d", $option_d);
            $stmt->bindParam(":correct_option", $correct_option);
            
            if ($stmt->execute()) {
                $successCount++;
            } else {
                $errorCount++;
            }
        } else {
            $errorCount++;
        }
    }
    fclose($handle);
    
    echo json_encode([
        'success' => true,
        'message' => "CSV upload completed",
        'uploaded' => $successCount,
        'failed' => $errorCount
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => "No file uploaded"
    ]);
}
?>