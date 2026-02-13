<?php
include '../includes/auth.php';
require_once '../includes/config.php';

// include '../includes/config.php'; // Ensure both $conn and $conn_student are here

if (!isAdminLoggedIn()) redirect('../login.php');

// Fetch results from coding platform
// Fetch results - Using a LEFT JOIN to see even if some data is missing
$stmt = $conn->prepare("
    SELECT 
        er.total_marks_obtained, 
        er.percentage, 
        er.submitted_at,
        u.username as roll_no, 
        e.title as exam_title, 
        e.total_marks as max_m
    FROM exam_results er
    LEFT JOIN users u ON er.user_id = u.id
    LEFT JOIN exams e ON er.exam_id = e.id
    ORDER BY er.total_marks_obtained DESC
");
$stmt->execute();
$results = $stmt->fetchAll(PDO::FETCH_ASSOC);
$stmt->execute();
$results = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Challenge - 2025</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .header-bg { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: white; padding: 30px 0; margin-bottom: 30px; }
        .table-card { background: white; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.05); padding: 25px; }
        .score-badge { font-size: 1rem; border-radius: 6px; }
    </style>
</head>
<body>

<div class="header-bg shadow">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h3 mb-1"><i class="fas fa-chart-line me-2"></i>Exam Analytics</h1>
                <p class="mb-0 opacity-75">Live submission report for batch 2025</p>
            </div>
            <button onclick="window.print()" class="btn btn-light"><i class="fas fa-print me-2"></i>Print Report</button>
        </div>
    </div>
</div>

<div class="container mb-5">
    <div class="table-card">
        <table class="table table-hover border-top">
            <thead class="table-light">
                <tr>
                    <th>Roll No</th>
                    <th>Full Name</th>
                    <th>Course (Batch)</th>
                    <th>Score Obtained</th>
                    <th>Percentage</th>
                    <th>Submission Time</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($results as $row): 
                    // Fetch student details from the student DB using Roll Number
                    $st_stmt = $conn_student->prepare("SELECT NAME, COURSE, BATCH FROM Batch_2025 WHERE ID = ?");
                    $st_stmt->execute([$row['roll_no']]);
                    $st = $st_stmt->fetch();
                ?>
                <tr>
                    <td><span class="fw-bold text-primary"><?php echo $row['roll_no']; ?></span></td>
                    <td><?php echo $st['NAME'] ?? '<span class="text-muted">Not Found</span>'; ?></td>
                    <td><?php echo $st['COURSE'] ?? '-'; ?></td>
                    <td>
                        <span class="badge bg-primary score-badge">
                            <?php echo $row['total_marks_obtained']; ?> / <?php echo $row['max_m']; ?>
                        </span>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                <div class="progress-bar <?php echo $row['percentage'] >= 40 ? 'bg-success' : 'bg-danger'; ?>" 
                                     style="width: <?php echo $row['percentage']; ?>%"></div>
                            </div>
                            <small class="fw-bold"><?php echo round($row['percentage'], 1); ?>%</small>
                        </div>
                    </td>
                    <td class="text-muted small"><?php echo date('d M, h:i A', strtotime($row['submitted_at'])); ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>