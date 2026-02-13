<?php
include 'includes/auth.php';

// Unset all session variables
$_SESSION = array();

// Destroy the session
session_destroy();

// Redirect to login page
redirect('login.php');
?>