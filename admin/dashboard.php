<?php
include '../includes/auth.php';
if (!isAdminLoggedIn()) redirect('../login.php');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | OCP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .admin-card { background: white; border-radius: 15px; border: 1px solid #e2e8f0; transition: 0.3s; cursor: pointer; text-decoration: none; display: block; }
        .admin-card:hover { transform: translateY(-10px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); border-color: #2563eb; }
        .icon-box { background: #eff6ff; color: #2563eb; width: 80px; height: 80px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 20px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-dark px-4 py-3">
        <span class="navbar-brand fw-bold">OCP Admin Panel</span>
        <a href="../logout.php" class="btn btn-outline-light btn-sm">Logout</a>
    </nav>

    <div class="container py-5 text-center">
        <h2 class="fw-bold mb-5">Welcome, <?php echo $_SESSION['full_name']; ?></h2>
        
        <div class="row justify-content-center">
            <div class="col-md-4">
                <a href="results.php" class="admin-card p-5 shadow-sm">
                    <div class="icon-box"><i class="fas fa-file-invoice"></i></div>
                    <h3 class="fw-bold text-dark">View Results</h3>
                    <p class="text-muted">Analyze scores, student attempts, and coding submissions for Batch 2025.</p>
                    <span class="btn btn-primary mt-3 px-4">Open Reports</span>
                </a>
            </div>
        </div>
    </div>
</body>
</html>