<?php
include_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $database = new Database();
    $db = $database->getConnection();
    
    $data = json_decode(file_get_contents("php://input"));
    
    if(isset($data->email) && isset($data->password)) {
        $email = trim($data->email);
        $password = $data->password;
        
        $query = "SELECT id, name, email, password FROM users WHERE email = :email";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":email", $email);
        $stmt->execute();
        
        if($stmt->rowCount() == 1) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if(password_verify($password, $row['password'])) {
                jsonResponse(true, "Login successful", [
                    'id' => $row['id'],
                    'name' => $row['name'],
                    'email' => $row['email']
                ]);
            } else {
                jsonResponse(false, "Invalid password");
            }
        } else {
            jsonResponse(false, "User not found");
        }
    } else {
        jsonResponse(false, "Email and password are required");
    }
}
?>