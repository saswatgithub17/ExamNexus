<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Exam Submitted</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
        }

        .success-card {
            border-radius: 20px;
        }

        @media (max-width: 576px) {
            .success-card {
                padding: 2rem 1.5rem !important;
            }
        }
    </style>
</head>

<body class="bg-light d-flex align-items-center justify-content-center">

    <div class="container px-3">
        <div class="card success-card border-0 shadow-lg mx-auto text-center p-4 p-md-5" style="max-width: 500px; width: 100%;">
            
            <h1 class="text-success fw-bold display-6 display-md-5">Success!</h1>
            
            <p class="lead mt-3">Your exam has been submitted.</p>
            
            <p class="text-muted mb-4">
                Coding Challenge results will be announced soon.
            </p>
            
            <a href="../logout.php" class="btn btn-primary w-100 w-md-auto px-4">
                Logout
            </a>

        </div>
    </div>

</body>
</html>