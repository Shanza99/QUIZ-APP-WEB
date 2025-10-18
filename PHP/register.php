<?php
include_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $database = new Database();
    $db = $database->getConnection();
    
    $data = json_decode(file_get_contents("php://input"));
    
    if(isset($data->name) && isset($data->email) && isset($data->password)) {
        $name = trim($data->name);
        $email = trim($data->email);
        $password = password_hash($data->password, PASSWORD_DEFAULT);
        
        // Check if email already exists
        $check_query = "SELECT id FROM users WHERE email = :email";
        $check_stmt = $db->prepare($check_query);
        $check_stmt->bindParam(":email", $email);
        $check_stmt->execute();
        
        if($check_stmt->rowCount() > 0) {
            jsonResponse(false, "Email already registered");
        }
        
        // Insert new user
        $query = "INSERT INTO users SET name=:name, email=:email, password=:password";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":name", $name);
        $stmt->bindParam(":email", $email);
        $stmt->bindParam(":password", $password);
        
        if($stmt->execute()) {
            jsonResponse(true, "Registration successful", [
                'id' => $db->lastInsertId(),
                'name' => $name,
                'email' => $email
            ]);
        } else {
            jsonResponse(false, "Registration failed");
        }
    } else {
        jsonResponse(false, "All fields are required");
    }
}
?>