<?php
include 'config.php';

class CodeExecutor {
    private $api_url = 'https://judge0-ce.p.rapidapi.com';
    private $api_key = '66087273famshf9034cdf0b84301p11e298jsnd3250bf85d70';
    
    public function executeCode($source_code, $language_id, $stdin = null) {
        $url = $this->api_url . '/submissions?base64_encoded=false&wait=true';
        
        $data = [
            'source_code' => $source_code,
            'language_id' => $language_id,
            'stdin' => $stdin,
            'cpu_time_limit' => 5,
            'memory_limit' => 128000,
            'wall_time_limit' => 10
        ];
        
        $options = [
            'http' => [
                'header' => implode("\r\n", [
                    'Content-Type: application/json',
                    'X-RapidAPI-Host: judge0-ce.p.rapidapi.com',
                    'X-RapidAPI-Key: ' . $this->api_key,
                    'Accept: application/json'
                ]),
                'method' => 'POST',
                'content' => json_encode($data),
                'ignore_errors' => true
            ]
        ];
        
        $context = stream_context_create($options);
        $result = @file_get_contents($url, false, $context);
        
        if ($result === FALSE) {
            $error = error_get_last();
            return ['error' => 'Failed to connect to Judge0 API: ' . ($error['message'] ?? 'Unknown error')];
        }
        
        $response = json_decode($result, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            return ['error' => 'Invalid API response format'];
        }
        
        if (isset($response['error'])) {
            return ['error' => $response['error']];
        }
        
        return $response;
    }
    
    public function getLanguages() {
        global $conn;
        try {
            $stmt = $conn->prepare("SELECT * FROM languages WHERE is_active = TRUE");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getLanguages: " . $e->getMessage());
            return [];
        }
    }
    
    public function evaluateTestCases($source_code, $language_id, $test_cases) {
        $results = [];
        $total_passed = 0;
        
        foreach ($test_cases as $test_case) {
            $stdin = $test_case['input_data'];
            $expected_output = trim($test_case['expected_output']);
            
            $execution_result = $this->executeCode($source_code, $language_id, $stdin);
            
            $actual_output = '';
            $is_passed = false;
            $error = '';
            
            if (isset($execution_result['stdout'])) {
                $actual_output = trim($execution_result['stdout']);
                $is_passed = ($actual_output === $expected_output);
            } elseif (isset($execution_result['stderr']) && !empty($execution_result['stderr'])) {
                $error = $execution_result['stderr'];
            } elseif (isset($execution_result['compile_output']) && !empty($execution_result['compile_output'])) {
                $error = $execution_result['compile_output'];
            } elseif (isset($execution_result['message'])) {
                $error = $execution_result['message'];
            }
            
            if ($is_passed) {
                $total_passed++;
            }
            
            $results[] = [
                'test_case_id' => $test_case['id'],
                'input' => $stdin,
                'expected_output' => $expected_output,
                'actual_output' => $actual_output,
                'is_passed' => $is_passed,
                'error' => $error,
                'execution_time' => $execution_result['time'] ?? 0
            ];
        }
        
        return [
            'results' => $results,
            'total_passed' => $total_passed,
            'total_cases' => count($test_cases),
            'score_percentage' => count($test_cases) > 0 ? ($total_passed / count($test_cases)) * 100 : 0
        ];
    }
}

class ExamManager {
    public function getActiveExams() {
        global $conn;
        try {
            $stmt = $conn->prepare("SELECT * FROM exams WHERE is_active = TRUE ORDER BY created_at DESC");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getActiveExams: " . $e->getMessage());
            return [];
        }
    }
    
    public function getExamQuestions($exam_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT q.*, l.name as language_name 
                FROM questions q 
                LEFT JOIN languages l ON q.language_id = l.id 
                WHERE q.exam_id = ? 
                ORDER BY q.display_order ASC
            ");
            $stmt->execute([$exam_id]);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getExamQuestions: " . $e->getMessage());
            return [];
        }
    }
    
    public function getQuestionTestCases($question_id, $include_hidden = false) {
        global $conn;
        try {
            $sql = "SELECT * FROM test_cases WHERE question_id = ?";
            if (!$include_hidden) {
                $sql .= " AND is_hidden = FALSE";
            }
            $sql .= " ORDER BY id ASC";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute([$question_id]);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getQuestionTestCases: " . $e->getMessage());
            return [];
        }
    }
    
    public function getStudentAttempts($user_id, $question_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT * FROM student_attempts 
                WHERE user_id = ? AND question_id = ? 
                ORDER BY attempt_number ASC
            ");
            $stmt->execute([$user_id, $question_id]);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getStudentAttempts: " . $e->getMessage());
            return [];
        }
    }
    
    public function saveAttempt($user_id, $question_id, $code, $language_id, $attempt_number) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                INSERT INTO student_attempts 
                (user_id, question_id, code_submitted, language_id, attempt_number) 
                VALUES (?, ?, ?, ?, ?)
            ");
            $stmt->execute([$user_id, $question_id, $code, $language_id, $attempt_number]);
            return $conn->lastInsertId();
        } catch (PDOException $e) {
            error_log("Database error in saveAttempt: " . $e->getMessage());
            return false;
        }
    }
    
    public function saveTestResults($attempt_id, $test_results) {
        global $conn;
        try {
            foreach ($test_results as $result) {
                $stmt = $conn->prepare("
                    INSERT INTO test_case_results 
                    (attempt_id, test_case_id, actual_output, is_passed, execution_time) 
                    VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->execute([
                    $attempt_id,
                    $result['test_case_id'],
                    $result['actual_output'],
                    $result['is_passed'] ? 1 : 0,
                    $result['execution_time']
                ]);
            }
            return true;
        } catch (PDOException $e) {
            error_log("Database error in saveTestResults: " . $e->getMessage());
            return false;
        }
    }
    
    public function calculateMarks($question_id, $passed_cases, $total_cases) {
        global $conn;
        try {
            // Get question details
            $stmt = $conn->prepare("SELECT marks FROM questions WHERE id = ?");
            $stmt->execute([$question_id]);
            $question = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$question) return 0;
            
            // Calculate marks based on passed test cases percentage
            $percentage = ($passed_cases / $total_cases) * 100;
            $marks_obtained = ($percentage / 100) * $question['marks'];
            
            return round($marks_obtained, 2);
        } catch (PDOException $e) {
            error_log("Database error in calculateMarks: " . $e->getMessage());
            return 0;
        }
    }
    
    // ========== MISSING METHODS THAT NEED TO BE ADDED ==========
    
    /**
     * Get the best marks obtained by a user for a specific question
     */
    public function getQuestionBestMarks($user_id, $question_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT MAX(marks_obtained) as best_marks 
                FROM question_attempts 
                WHERE user_id = ? AND question_id = ?
            ");
            $stmt->execute([$user_id, $question_id]);
            $result = $stmt->fetch();
            return $result['best_marks'] ?? 0;
        } catch (PDOException $e) {
            error_log("Database error in getQuestionBestMarks: " . $e->getMessage());
            return 0;
        }
    }
    
    /**
     * Get exam progress for a user
     */
    public function getExamProgress($user_id, $exam_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT 
                    COUNT(DISTINCT q.id) as total_questions,
                    COUNT(DISTINCT qa.question_id) as attempted_questions,
                    COALESCE(SUM(qa.best_marks), 0) as total_marks_obtained,
                    COALESCE(SUM(q.marks), 0) as total_possible_marks
                FROM questions q
                LEFT JOIN (
                    SELECT question_id, MAX(marks_obtained) as best_marks
                    FROM question_attempts
                    WHERE user_id = ?
                    GROUP BY question_id
                ) qa ON q.id = qa.question_id
                WHERE q.exam_id = ?
            ");
            $stmt->execute([$user_id, $exam_id]);
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getExamProgress: " . $e->getMessage());
            return null;
        }
    }
    
    /**
     * Get all submissions for a user (for submissions page)
     */
    public function getUserSubmissions($user_id, $limit = 10, $offset = 0, $search = '') {
        global $conn;
        try {
            $sql = "
                SELECT 
                    sa.*, 
                    q.title as question_title,
                    e.title as exam_title,
                    l.name as language_name,
                    qa.marks_obtained
                FROM student_attempts sa
                JOIN questions q ON sa.question_id = q.id
                JOIN exams e ON q.exam_id = e.id
                JOIN languages l ON sa.language_id = l.id
                LEFT JOIN question_attempts qa ON sa.id = qa.attempt_id
                WHERE sa.user_id = ?
            ";
            
            $params = [$user_id];
            
            if (!empty($search)) {
                $sql .= " AND (q.title LIKE ? OR e.title LIKE ? OR l.name LIKE ?)";
                $searchTerm = "%$search%";
                $params[] = $searchTerm;
                $params[] = $searchTerm;
                $params[] = $searchTerm;
            }
            
            $sql .= " ORDER BY sa.submission_time DESC LIMIT ? OFFSET ?";
            $params[] = $limit;
            $params[] = $offset;
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getUserSubmissions: " . $e->getMessage());
            return [];
        }
    }
    
    /**
     * Count total submissions for a user (for pagination)
     */
    public function countUserSubmissions($user_id, $search = '') {
        global $conn;
        try {
            $sql = "
                SELECT COUNT(*) as total
                FROM student_attempts sa
                JOIN questions q ON sa.question_id = q.id
                JOIN exams e ON q.exam_id = e.id
                JOIN languages l ON sa.language_id = l.id
                WHERE sa.user_id = ?
            ";
            
            $params = [$user_id];
            
            if (!empty($search)) {
                $sql .= " AND (q.title LIKE ? OR e.title LIKE ? OR l.name LIKE ?)";
                $searchTerm = "%$search%";
                $params[] = $searchTerm;
                $params[] = $searchTerm;
                $params[] = $searchTerm;
            }
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            return $stmt->fetch()['total'];
        } catch (PDOException $e) {
            error_log("Database error in countUserSubmissions: " . $e->getMessage());
            return 0;
        }
    }
    
    /**
     * Get detailed results for a specific attempt
     */
    public function getAttemptDetails($attempt_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT 
                    sa.*,
                    q.title as question_title,
                    q.marks as question_marks,
                    e.title as exam_title,
                    l.name as language_name
                FROM student_attempts sa
                JOIN questions q ON sa.question_id = q.id
                JOIN exams e ON q.exam_id = e.id
                JOIN languages l ON sa.language_id = l.id
                WHERE sa.id = ?
            ");
            $stmt->execute([$attempt_id]);
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getAttemptDetails: " . $e->getMessage());
            return null;
        }
    }
    
    /**
     * Get test case results for an attempt
     */
    public function getAttemptTestResults($attempt_id) {
        global $conn;
        try {
            $stmt = $conn->prepare("
                SELECT 
                    tcr.*,
                    tc.input_data,
                    tc.expected_output,
                    tc.is_hidden,
                    tc.marks as case_marks
                FROM test_case_results tcr
                JOIN test_cases tc ON tcr.test_case_id = tc.id
                WHERE tcr.attempt_id = ?
                ORDER BY tc.id
            ");
            $stmt->execute([$attempt_id]);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getAttemptTestResults: " . $e->getMessage());
            return [];
        }
    }
}
?>