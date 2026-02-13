<?php
session_start();
include 'includes/auth.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = sanitizeInput($_POST['username']);
    $password = sanitizeInput($_POST['password']);

    // ✅ 0. HARDCODED ADMIN LOGIN
    if ($username === 'Admin' && $password === 'admin') {
        $_SESSION['admin_id'] = 1;
        $_SESSION['username'] = 'Admin';
        $_SESSION['full_name'] = 'Administrator';
        $_SESSION['user_type'] = 'admin';
        redirect('admin/dashboard.php');
        exit();
    }

    // 1. FIRST CHECK: Is this an Admin from Database?
    $stmt = $conn->prepare("SELECT id, username, password, full_name FROM admins WHERE username = ?");
    $stmt->execute([$username]);
    $admin = $stmt->fetch();

    if ($admin && password_verify($password, $admin['password'])) {
        $_SESSION['admin_id'] = $admin['id'];
        $_SESSION['username'] = $admin['username'];
        $_SESSION['full_name'] = $admin['full_name'];
        $_SESSION['user_type'] = 'admin';
        redirect('admin/dashboard.php');
        exit();
    } 
    
    // 2. SECOND CHECK: Is this a Student?
    else {
        // Fetch from Student Database (Batch 2025-29)
        $stmt = $conn_student->prepare("SELECT ID, NAME, BATCH, COURSE FROM Batch_2025 WHERE ID = ?");
        $stmt->execute([$username]);
        $student = $stmt->fetch();

        // Roll Number is used as both ID and Password for students
        if ($student && $password === $student['ID']) {
            
            // Check if they already submitted the exam
            $u_check = $conn->prepare("SELECT id FROM users WHERE username = ?");
            $u_check->execute([$username]);
            $local_user = $u_check->fetch();

            if ($local_user) {
                $res_check = $conn->prepare("SELECT id FROM exam_results WHERE user_id = ? AND exam_id = 1");
                $res_check->execute([$local_user['id']]);
                if ($res_check->rowCount() > 0) {
                    $error = 'Access Denied: You have already submitted this exam.';
                }
            }

            if (empty($error)) {
                $_SESSION['user_id'] = $student['ID'];
                $_SESSION['username'] = $student['NAME'];
                $_SESSION['batch'] = $student['BATCH'];
                $_SESSION['course'] = $student['COURSE'];
                $_SESSION['year'] = '2025-2029';
                $_SESSION['user_type'] = 'user';
                redirect('user/exam_interface.php');
                exit();
            }
        } else {
            $error = 'Invalid Credentials. Please check your Roll Number and Password.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    
    <!-- ✅ IMPORTANT FOR MOBILE -->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Code Challenge - Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <style>
        body {
            background: #f0f2f5;
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            background: #fff;
        }

        .btn-primary {
            background: #2563eb;
            border: none;
            padding: 12px;
            font-weight: 700;
            border-radius: 10px;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }

        .form-control {
            border-radius: 10px;
            padding: 12px;
            border: 1px solid #ddd;
        }

        .logo-text {
            font-weight: 900;
            letter-spacing: -1px;
            color: #1e293b;
        }

        .logo-text span {
            color: #2563eb;
        }

        /* ✅ Mobile Optimization */
        @media (max-width: 576px) {
            body {
                padding: 15px;
                align-items: center;
            }

            .card {
                padding: 20px !important;
            }

            .logo-text {
                font-size: 1.5rem;
            }

            .btn-primary {
                padding: 10px;
                font-size: 14px;
            }

            .form-control {
                padding: 10px;
                font-size: 14px;
            }

            .col-md-4 {
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="row justify-content-center">
            
            <!-- ✅ Better Column Responsive Control -->
            <div class="col-12 col-sm-10 col-md-6 col-lg-4 text-center animate__animated animate__zoomIn">
                
                <h1 class="logo-text mb-4">
                    Code Challenge <span>2026</span>
                </h1>

                <div class="card p-4 text-start">
                    <h5 class="fw-bold mb-3 text-center">Access Login</h5>

                    <?php if($error): ?>
                        <div class="alert alert-danger py-2 small animate__animated animate__headShake">
                            <?php echo $error; ?>
                        </div>
                    <?php endif; ?>

                    <form method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Roll Number</label>
                            <input type="text" name="username" class="form-control" placeholder="Enter your ID" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small">Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Enter Password" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 shadow-sm mt-2">
                            LOGIN
                        </button>
                    </form>
                </div>

                <p class="text-muted mt-4 small">
                    &copy; Team Technocrat
                </p>

            </div>
        </div>
    </div>
</body>
</html>
