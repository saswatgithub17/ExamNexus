<?php
include 'config.php';

// Function to sanitize user input
function sanitizeInput($data) {
    return htmlspecialchars(strip_tags(trim($data)));
}

// Function to redirect
function redirect($url) {
    header("Location: $url");
    exit();
}

// Check if user is logged in
function isUserLoggedIn() {
    return isset($_SESSION['user_id']);
}

// Check if admin is logged in
function isAdminLoggedIn() {
    return isset($_SESSION['admin_id']);
}
?>