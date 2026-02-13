<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database configuration
define('DB_HOST', 'localhost');

// Platform DB Credentials
define('DB_USER_PLATFORM', 'u361366281_Code_Event');
define('DB_PASS_PLATFORM', 'CTC@c123');
define('DB_NAME_PLATFORM', 'u361366281_Code_Event');

// Student DB Credentials
define('DB_USER_STUDENT', 'u361366281_Student');
define('DB_PASS_STUDENT', 'CTC@c123');
define('DB_NAME_STUDENT', 'u361366281_Student');

try {

    // Platform DB
    $conn = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME_PLATFORM . ";charset=utf8mb4",
        DB_USER_PLATFORM,
        DB_PASS_PLATFORM,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );

    // Student DB
    $conn_student = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME_STUDENT . ";charset=utf8mb4",
        DB_USER_STUDENT,
        DB_PASS_STUDENT,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );

} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
?>
