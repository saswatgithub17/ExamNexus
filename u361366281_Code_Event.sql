-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 13, 2026 at 03:53 AM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u361366281_Code_Event`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `is_super_admin` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `email`, `full_name`, `is_super_admin`, `created_at`) VALUES
(1, 'Admin', '$2y$10$D7pDwOwnnIqJ.yis/SZeyulFTMH5pi4eB623LQMqZ7q39t3z0klOO', 'ananta@codeproject.com', 'Admin', 1, '2025-09-24 17:01:40');

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `total_marks` int(11) DEFAULT 0,
  `duration_minutes` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`id`, `title`, `description`, `total_marks`, `duration_minutes`, `is_active`, `created_at`) VALUES
(1, 'Coding Challenge 2025', 'BCA/BSc Final Year Coding Assessment', 50, 60, 1, '2026-02-12 11:31:22');

-- --------------------------------------------------------

--
-- Table structure for table `exam_results`
--

CREATE TABLE `exam_results` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `total_marks_obtained` int(11) DEFAULT 0,
  `percentage` decimal(5,2) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL,
  `is_completed` tinyint(1) DEFAULT 0,
  `tab_switches` int(11) DEFAULT 0,
  `proctoring_violation` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `exam_sessions`
--

CREATE TABLE `exam_sessions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `end_time` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `judge0_id` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `name`, `judge0_id`, `is_active`) VALUES
(1, 'C', 50, 1),
(2, 'C++', 54, 1),
(3, 'Java', 62, 1),
(4, 'Python', 71, 1),
(5, 'JavaScript', 63, 1),
(6, 'Ruby', 72, 1),
(7, 'Go', 60, 1),
(8, 'PHP', 68, 1),
(9, 'Rust', 73, 1),
(10, 'TypeScript', 74, 1);

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `language_id` int(11) DEFAULT NULL,
  `starter_code` text DEFAULT NULL,
  `max_attempts` int(11) DEFAULT 3,
  `marks` int(11) DEFAULT 10,
  `display_order` int(11) DEFAULT NULL,
  `is_passed` tinyint(1) DEFAULT 0,
  `section` char(1) NOT NULL DEFAULT 'A',
  `type` enum('mcq','coding') NOT NULL DEFAULT 'mcq',
  `option_a` text DEFAULT NULL,
  `option_b` text DEFAULT NULL,
  `option_c` text DEFAULT NULL,
  `option_d` text DEFAULT NULL,
  `correct_option` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `exam_id`, `title`, `description`, `language_id`, `starter_code`, `max_attempts`, `marks`, `display_order`, `is_passed`, `section`, `type`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`) VALUES
(53, 1, 'C Coding', 'Write a C program to find the largest element in an array of 5 integers.', 1, NULL, 3, 5, NULL, 0, 'F', 'coding', '1 5 3 9 2', NULL, NULL, NULL, '9'),
(54, 1, 'Python Coding', 'Write a Python program using list comprehension to create a list of even numbers from 0 to 20.', 4, NULL, 3, 5, NULL, 0, 'F', 'coding', '', NULL, NULL, NULL, '['),
(55, 1, 'CE1', 'Which header file is required for printf() in C?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'stdlib.h', 'stdio.h', 'string.h', 'math.h', 'B'),
(56, 1, 'CE2', 'Which operator is used to get the address of a variable in C?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', '*', '&', '%', '#', 'B'),
(57, 1, 'CE3', 'What is the default return type of main() in C?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'int', 'void', 'char', 'float', 'A'),
(58, 1, 'CE4', 'Which loop is guaranteed to execute at least once in C?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'for', 'while', 'do-while', 'foreach', 'C'),
(59, 1, 'CE5', 'Which keyword is used to prevent modification of a variable in C?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'static', 'const', 'volatile', 'register', 'B'),
(60, 1, 'PE1', 'Which keyword is used to create a class in Python?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'class', 'define', 'object', 'struct', 'A'),
(61, 1, 'PE2', 'What is the output of: print(len(\"Python\")) ?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', '5', '6', '7', 'Error', 'B'),
(62, 1, 'PE3', 'Which data type is immutable in Python?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', 'List', 'Dictionary', 'Set', 'Tuple', 'D'),
(63, 1, 'PE4', 'Which operator is used for floor division in Python?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', '/', '//', '%', '**', 'B'),
(64, 1, 'PE5', 'What will print(type(10)) return?', NULL, NULL, 3, 1, NULL, 0, 'A', 'mcq', '<class int>', '<class \"int\">', 'int', 'integer', 'B'),
(65, 1, 'QB11', 'What is the index of the last element in an array of size n in C?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'n', 'n-1', 'n+1', '0', 'B'),
(66, 1, 'QB12', 'What does the expression *(arr + 2) represent in C?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'Address of arr[2]', 'Value of arr[2]', 'Third element address', 'Syntax error', 'B'),
(67, 1, 'QB13', 'Which of the following is correct for declaring an integer pointer?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'int ptr;', 'int *ptr;', 'pointer int ptr;', '*int ptr;', 'B'),
(68, 1, 'QB14', 'What is the base address of an array?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'Address of last element', 'Address of first element', 'Address of middle element', 'Null address', 'B'),
(69, 1, 'QB15', 'If int *p; and p = &x;, what does *p give?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'Address of x', 'Value of x', 'Pointer size', 'Error', 'B'),
(70, 1, 'QB16', 'Which Python collection does NOT allow duplicate values?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'List', 'Tuple', 'Set', 'Dictionary', 'C'),
(71, 1, 'QB17', 'Which method is used to add an element to a Python set?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'append()', 'add()', 'insert()', 'push()', 'B'),
(72, 1, 'QB18', 'How do you access value 5 from list x = [1, 3, 5, 7]?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'x[2]', 'x[3]', 'x(2)', 'x{2}', 'A'),
(73, 1, 'QB19', 'Which collection stores data in key-value pairs?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', 'List', 'Tuple', 'Set', 'Dictionary', 'D'),
(74, 1, 'QB20', 'What is the output of: len({1,2,2,3}) ?', NULL, NULL, 3, 1, NULL, 0, 'B', 'mcq', '4', '3', '2', 'Error', 'B'),
(75, 1, 'QC21', 'What is the default return type of a function in C if not specified?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'void', 'float', 'int', 'double', 'C'),
(76, 1, 'QC22', 'Which keyword is used to declare a function before its definition in C?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'define', 'prototype', 'declare', 'extern', 'D'),
(77, 1, 'QC23', 'What is function overloading in C?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'Multiple functions with same name but different parameters', 'Calling function inside another function', 'Returning multiple values', 'C does not support function overloading', 'D'),
(78, 1, 'QC24', 'What will happen if return statement is missing in a non-void C function?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'Compile error', 'Program runs normally', 'Undefined behavior', 'Runtime error always', 'C'),
(79, 1, 'QC25', 'Which allows a function to modify original variables?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'Call by value', 'Call by reference using pointers', 'Static variables', 'Global variables only', 'B'),
(80, 1, 'QC26', 'What is the correct syntax to define a function in Python?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'function myFunc():', 'def myFunc():', 'define myFunc():', 'func myFunc():', 'B'),
(81, 1, 'QC27', 'What is the output of: def f(): return 5\\nprint(f())', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', '5', 'None', 'Error', 'Function object', 'A'),
(82, 1, 'QC28', 'What is a lambda function in Python?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'Function with no name', 'Function with multiple returns', 'Function without parameters', 'Built-in function only', 'A'),
(83, 1, 'QC29', 'What will be the output?\\ndef f(a, b=2): return a*b\\nprint(f(3))', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', '6', '5', 'Error', '3', 'A'),
(84, 1, 'QC30', 'Which keyword is used to return a value from a function in Python?', NULL, NULL, 3, 1, NULL, 0, 'C', 'mcq', 'output', 'return', 'break', 'yield', 'B'),
(85, 1, 'QD31', 'Which function is used to open a file in C?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'fopen()', 'open()', 'fileopen()', 'create()', 'A'),
(86, 1, 'QD32', 'What does the mode \"r+\" mean in fopen()?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'Read only', 'Write only', 'Read and write', 'Append only', 'C'),
(87, 1, 'QD33', 'Which function is used to close a file in C?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'close()', 'fclose()', 'endfile()', 'fileclose()', 'B'),
(88, 1, 'QD34', 'Which function writes formatted output to a file in C?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'fprintf()', 'printf()', 'write()', 'fwritechar()', 'A'),
(89, 1, 'QD35', 'What is returned by fopen() if file cannot be opened?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', '0', 'EOF', 'NULL', '-1', 'C'),
(90, 1, 'QD36', 'What is the correct syntax of a lambda function in Python?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'lambda x: x+1', 'lambda(x): x+1', 'def lambda(x):', 'function lambda(x)', 'A'),
(91, 1, 'QD37', 'What will be the output?\\nf = lambda x: x*2\\nprint(f(4))', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', '8', '4', 'Error', 'None', 'A'),
(92, 1, 'QD38', 'Lambda functions can contain how many expressions?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'One expression', 'Multiple statements', 'Loops only', 'No expressions', 'A'),
(93, 1, 'QD39', 'Which built-in function commonly uses lambda?', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', 'sort() with key', 'print()', 'input()', 'type()', 'A'),
(94, 1, 'QD40', 'What will be the output?\\nprint((lambda a,b: a+b)(3,5))', NULL, NULL, 3, 1, NULL, 0, 'D', 'mcq', '35', '8', 'Error', 'None', 'B'),
(95, 1, 'C Array Sum', 'Write a C program that takes an array of 5 integers as input and calculates the sum of all elements. Your program must print the final sum as a single integer.', 1, '#Write Your Code Here.....', 3, 5, NULL, 0, 'E', 'coding', '10 20 30 40 50', NULL, NULL, NULL, '150'),
(96, 1, 'Py Squares', 'Write a Python program that uses list comprehension to create a list containing the squares of numbers from 1 to 5. The output must be the list in standard Python format.', 2, '/*Write Your Code Here.....*/', 3, 5, NULL, 0, 'E', 'coding', '', NULL, NULL, NULL, '[1,4,9,16,25]');

-- --------------------------------------------------------

--
-- Table structure for table `question_attempts`
--

CREATE TABLE `question_attempts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `attempt_id` int(11) DEFAULT NULL,
  `marks_obtained` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `question_attempts`
--

INSERT INTO `question_attempts` (`id`, `user_id`, `question_id`, `attempt_id`, `marks_obtained`, `created_at`) VALUES
(42, 7, 57, NULL, 1.00, '2026-02-12 18:30:38'),
(43, 7, 56, NULL, 0.00, '2026-02-12 18:30:38'),
(44, 7, 64, NULL, 1.00, '2026-02-12 18:30:38'),
(45, 7, 58, NULL, 0.00, '2026-02-12 18:30:38'),
(46, 7, 77, NULL, 1.00, '2026-02-12 18:30:38');

-- --------------------------------------------------------

--
-- Table structure for table `section_timer`
--

CREATE TABLE `section_timer` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `section` char(1) DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_completed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_attempts`
--

CREATE TABLE `student_attempts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `attempt_number` int(11) DEFAULT NULL,
  `code_submitted` text DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `submission_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_attempts`
--

INSERT INTO `student_attempts` (`id`, `user_id`, `question_id`, `attempt_number`, `code_submitted`, `language_id`, `submission_time`) VALUES
(28, 7, 54, 1, '', NULL, '2026-02-12 18:30:40'),
(29, 7, 53, 1, '#include<stdio.h>\r\nint main (){\r\nprintf(\"9\");\r\nreturn 0;}', NULL, '2026-02-12 18:30:41'),
(30, 10, 54, 1, 'print(\"[\")', NULL, '2026-02-12 18:36:58'),
(31, 10, 53, 1, '', NULL, '2026-02-12 18:36:59'),
(32, 22, 54, 1, '', NULL, '2026-02-12 18:38:10'),
(33, 22, 53, 1, '', NULL, '2026-02-12 18:38:11'),
(34, 23, 95, 1, '#include <stdio.h>\r\n\r\nint main() {\r\n    int arr[5], sum = 0;\r\n    for(int i=0; i<5; i++) {\r\n        scanf(\"%d\", &arr[i]);\r\n    }\r\n    // Write your logic here\r\n\r\n    return 0;\r\n}', NULL, '2026-02-12 18:51:56'),
(35, 23, 54, 1, '', NULL, '2026-02-12 18:51:57'),
(36, 23, 96, 1, '# Use list comprehension to generate squares of 1 to 5\r\n# Expected output format: [1, 4, 9, 16, 25]\r\n', NULL, '2026-02-12 18:51:58'),
(37, 23, 53, 1, '', NULL, '2026-02-12 18:51:59'),
(38, 10, 95, 1, 'put here....', NULL, '2026-02-12 18:54:14'),
(39, 24, 95, 1, '', NULL, '2026-02-12 19:04:03'),
(40, 24, 54, 1, '', NULL, '2026-02-12 19:04:03'),
(41, 25, 95, 1, '#include<stdio.h>\r\nint main(){\r\n  printf(\"Hello World\");\r\n  return 0;\r\n}', NULL, '2026-02-12 19:10:16'),
(42, 25, 54, 1, '', NULL, '2026-02-12 19:10:17'),
(43, 25, 96, 1, 'put here....', NULL, '2026-02-12 19:10:18'),
(44, 25, 53, 1, '', NULL, '2026-02-12 19:10:19'),
(45, NULL, 95, NULL, 'put here....', NULL, '2026-02-12 19:36:59'),
(46, NULL, 96, NULL, 'print(\"[\")', NULL, '2026-02-12 19:38:35'),
(47, NULL, 95, NULL, '#include<stdio.h>\r\nint main(){\r\n  printf(\"1\");\r\n  return 0;\r\n}', NULL, '2026-02-12 19:38:36'),
(48, 22, 96, NULL, 'put here....', NULL, '2026-02-12 19:51:38'),
(49, 22, 95, NULL, 'put here....', NULL, '2026-02-12 19:51:39'),
(50, NULL, 96, NULL, 'print(\"28394\")', NULL, '2026-02-12 20:06:32'),
(51, NULL, 96, NULL, 'print(\"[1,4,9,16,25]\")', NULL, '2026-02-12 20:06:42'),
(52, NULL, 95, NULL, '150', NULL, '2026-02-12 20:06:43'),
(53, 26, 96, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:20:33'),
(54, 26, 95, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:20:34'),
(55, 27, 96, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:21:42'),
(56, 27, 95, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:21:43'),
(57, 28, 96, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:22:56'),
(58, 28, 95, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:22:57'),
(59, 27, 96, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:25:15'),
(60, 27, 95, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:25:16'),
(61, 28, 96, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:25:22'),
(62, 28, 95, NULL, 'Write Your Code Here.....', NULL, '2026-02-12 20:25:23'),
(63, 12, 96, NULL, 'print(\"[1,4,9,16,25]\")', NULL, '2026-02-13 03:31:24'),
(64, 12, 95, NULL, '#Write Your Code Here.....', NULL, '2026-02-13 03:31:25'),
(65, 29, 96, NULL, 'PRINT(\"HELLO WORLD\")', NULL, '2026-02-13 03:51:44'),
(66, 29, 95, NULL, '#Write Your Code Here.....', NULL, '2026-02-13 03:51:45');

-- --------------------------------------------------------

--
-- Table structure for table `submissions`
--

CREATE TABLE `submissions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `code` text NOT NULL,
  `submission_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL,
  `memory_usage` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `submissions`
--

INSERT INTO `submissions` (`id`, `user_id`, `language_id`, `code`, `submission_time`, `status`, `execution_time`, `memory_usage`) VALUES
(13, 1, 4, 'print(\"Hello, World!\")', '2025-05-11 07:41:37', 'Success', 0, NULL),
(14, 1, 2, '#include<iostream>\r\nusing namespace std;\r\nint main(){\r\nint a;\r\ncout<< \"Enter a Number\";\r\ncin>>a;\r\ncout<<\"The Entered number is :\"<<a;\r\nreturn 0;\r\n}', '2025-05-11 07:44:00', 'Success', 0, NULL),
(15, 1, 2, '#include <iostream>\\n\\nint main() {\\n    std::cout << \"Hello, World!\" << std::endl;\\n    return 0;\\n}', '2025-05-11 07:44:37', 'Error', 0, NULL),
(16, 1, 5, 'console.log(\"Hello, World!\");', '2025-05-11 07:45:12', 'Success', 0, NULL),
(17, 1, 4, 'print(\"Hello, World!\")', '2025-05-11 07:53:37', 'Success', 0, NULL),
(18, 1, 4, 'a = input(\"Enter a number\")\r\nprint(a)', '2025-05-11 07:54:28', 'Success', 0, NULL),
(19, 1, 1, '#include <stdio.h>\r\nint main() {   \r\n    int number;\r\n   \r\n    printf(\"Enter an integer: \");  \r\n    \r\n    // reads and stores input\r\n    scanf(\"%d\", &number);\r\n\r\n    // displays output\r\n    printf(\"You entered: %d\", number);\r\n    \r\n    return 0;\r\n}\r\n', '2025-05-11 07:55:07', 'Success', 0, NULL),
(20, 1, 4, 'print(\"Hello, World!\")', '2025-05-11 07:55:15', 'Success', 0, NULL),
(21, 1, 1, '#include <stdio.h>\r\nint main() {   \r\n    int number;\r\n   \r\n    printf(\"Enter an integer: \");  \r\n    \r\n    // reads and stores input\r\n    scanf(\"%d\", &number);\r\n\r\n    // displays output\r\n    printf(\"You entered: %d\", number);\r\n    \r\n    return 0;\r\n}\r\n', '2025-05-11 07:55:35', 'Success', 0, NULL),
(22, 1, 3, 'public class Main {\\n    public static void main(String[] args) {\\n        System.out.println(\"Hello, World!\");\\n    }\\n}', '2025-05-11 07:56:20', 'Error', 0, NULL),
(23, 1, 1, '#include <stdio.h>\r\nint main() {    \r\n\r\n    int number1, number2, sum;\r\n    \r\n    printf(\"Enter two integers: \");\r\n    scanf(\"%d %d\", &number1, &number2);\r\n\r\n    // calculate the sum\r\n    sum = number1 + number2;      \r\n    \r\n    printf(\"%d + %d = %d\", number1, number2, sum);\r\n    return 0;\r\n}\r\n', '2025-05-11 07:56:58', 'Success', 0, NULL),
(24, 1, 1, '#include <stdio.h>\r\nint main() {\r\n  int n, reversed = 0, remainder, original;\r\n    printf(\"Enter an integer: \");\r\n    scanf(\"%d\", &n);\r\n    original = n;\r\n\r\n    // reversed integer is stored in reversed variable\r\n    while (n != 0) {\r\n        remainder = n % 10;\r\n        reversed = reversed * 10 + remainder;\r\n        n /= 10;\r\n    }\r\n\r\n    // palindrome if orignal and reversed are equal\r\n    if (original == reversed)\r\n        printf(\"%d is a palindrome.\", original);\r\n    else\r\n        printf(\"%d is not a palindrome.\", original);\r\n\r\n    return 0;\r\n}', '2025-05-24 13:49:57', 'Success', 0, NULL),
(25, 1, 4, '#include <stdio.h>\r\nint main() {    \r\n\r\n    int number1, number2, sum;\r\n    \r\n    printf(\"Enter two integers: \");\r\n    scanf(\"%d %d\", &number1, &number2);\r\n\r\n    // calculate the sum\r\n    sum = number1 + number2;      \r\n    \r\n    printf(\"%d + %d = %d\", number1, number2, sum);\r\n    return 0;\r\n}\r\n', '2025-05-24 13:50:51', 'Error', 0, NULL),
(26, 1, 1, '#include <stdio.h>\r\nint main() {    \r\n\r\n    int number1, number2, sum;\r\n    \r\n    printf(\"Enter two integers: \");\r\n    scanf(\"%d %d\", &number1, &number2);\r\n\r\n    // calculate the sum\r\n    sum = number1 + number2;      \r\n    \r\n    printf(\"%d + %d = %d\", number1, number2, sum);\r\n    return 0;\r\n}\r\n', '2025-05-24 13:51:02', 'Success', 0, NULL),
(27, 1, 1, '#include <stdio.h>\r\nint main() {\r\n    char c;\r\n    int lowercase_vowel, uppercase_vowel;\r\n    printf(\"Enter an alphabet: \");\r\n    scanf(\"%c\", &c);\r\n\r\n    // evaluates to 1 if variable c is a lowercase vowel\r\n    lowercase_vowel = (c == \'a\' || c == \'e\' || c == \'i\' || c == \'o\' || c == \'u\');\r\n\r\n    // evaluates to 1 if variable c is a uppercase vowel\r\n    uppercase_vowel = (c == \'A\' || c == \'E\' || c == \'I\' || c == \'O\' || c == \'U\');\r\n\r\n    // evaluates to 1 (true) if c is a vowel\r\n    if (lowercase_vowel || uppercase_vowel)\r\n        printf(\"%c is a vowel.\", c);\r\n    else\r\n        printf(\"%c is a consonant.\", c);\r\n    return 0;\r\n}\r\n', '2025-05-24 13:52:46', 'Success', 0, NULL),
(28, 1, 1, '#include <stdio.h>\r\nint main() {\r\n    char c;\r\n    for (c = \'A\'; c <= \'Z\'; ++c)\r\n        printf(\"%c \", c);\r\n    return 0;\r\n}\r\n', '2025-05-24 13:53:28', 'Success', 0, NULL),
(29, 1, 1, '#include <stdio.h>\r\nint main() {\r\n    char c;\r\n    printf(\"Enter u to display uppercase alphabets.\\n\");\r\n    printf(\"Enter l to display lowercase alphabets. \\n\");\r\n    scanf(\"%c\", &c);\r\n\r\n    if (c == \'U\' || c == \'u\') {\r\n        for (c = \'A\'; c <= \'Z\'; ++c)\r\n            printf(\"%c \", c);\r\n    } else if (c == \'L\' || c == \'l\') {\r\n        for (c = \'a\'; c <= \'z\'; ++c)\r\n            printf(\"%c \", c);\r\n    } else {\r\n        printf(\"Error! You entered an invalid character.\");\r\n    }\r\n\r\n    return 0;\r\n}\r\n\r\n', '2025-05-24 13:54:10', 'Success', 0, NULL),
(30, 1, 1, '#include <stdio.h>\r\n\r\nint main() {\r\n\r\n  char op;\r\n  double first, second;\r\n  printf(\"Enter an operator (+, -, *, /): \");\r\n  scanf(\"%c\", &op);\r\n  printf(\"Enter two operands: \");\r\n  scanf(\"%lf %lf\", &first, &second);\r\n\r\n  switch (op) {\r\n    case \'+\':\r\n      printf(\"%.1lf + %.1lf = %.1lf\", first, second, first + second);\r\n      break;\r\n    case \'-\':\r\n      printf(\"%.1lf - %.1lf = %.1lf\", first, second, first - second);\r\n      break;\r\n    case \'*\':\r\n      printf(\"%.1lf * %.1lf = %.1lf\", first, second, first * second);\r\n      break;\r\n    case \'/\':\r\n      printf(\"%.1lf / %.1lf = %.1lf\", first, second, first / second);\r\n      break;\r\n    // operator doesn\'t match any case constant\r\n    default:\r\n      printf(\"Error! operator is not correct\");\r\n  }\r\n\r\n  return 0;\r\n}\r\n', '2025-05-24 13:55:29', 'Success', 0, NULL),
(31, 1, 2, '// C++ program to check if the number is even\r\n// or odd using modulo operator\r\n#include <bits/stdc++.h>\r\nusing namespace std;\r\n\r\nint main() {\r\n    int n = 11;\r\n\r\n    // If n is completely divisible by 2\r\n    if (n % 2 == 0)\r\n        cout << \"Even\";\r\n\r\n    // If n is NOT completely divisible by 2\r\n    else\r\n        cout << \"Odd\";\r\n    return 0;\r\n}', '2025-06-01 14:59:53', 'Success', 0, NULL),
(32, 1, 3, 'import java.util.Scanner;\r\nclass SwapNumbers\r\n{\r\npublic static void main(String args[])\r\n{\r\nint z, y, temp;\r\nSystem.out.println(\"Enter z and y\");\r\nScanner sct = new Scanner(System.in);   //User inputs two numbers\r\nz = sct.nextInt();   //User inputs two numbers\r\ny = sct.nextInt();\r\nSystem.out.println(\"Before Swapping\\nz = \"+z+\"\\ny = \"+y);\r\ntemp = z;   //Swapping is done\r\nz = y;\r\ny = temp;\r\nSystem.out.println(\"After Swapping\\nz = \"+z+\"\\ny = \"+y);\r\n}\r\n}', '2025-06-01 15:00:44', 'Error', 0, NULL),
(33, 1, 3, 'import java.util.Scanner;\r\n\r\npublic class HelloWorld {\r\n\r\n    public static void main(String[] args) {\r\n\r\n        // Creates a reader instance which takes\r\n        // input from standard input - keyboard\r\n        Scanner reader = new Scanner(System.in);\r\n        System.out.print(\"Enter a number: \");\r\n\r\n        // nextInt() reads the next integer from the keyboard\r\n        int number = reader.nextInt();\r\n\r\n        // println() prints the following line to the output screen\r\n        System.out.println(\"You entered: \" + number);\r\n    }\r\n}', '2025-06-01 15:01:21', 'Error', 0, NULL),
(34, 1, 4, 'if 5 > 2:\r\n print(\"Five is greater than two!\") \r\nif 5 > 2:\r\n        print(\"Five is greater than two!\") ', '2025-06-01 15:04:14', 'Success', 0, NULL),
(35, 1, 2, '// Your First C++ Program\r\n\r\n#include <iostream>\r\n\r\nint main() {\r\n    std::cout << \"Hello World!\";\r\n    return 0;\r\n}\r\n', '2025-06-02 09:11:36', 'Success', 0, NULL),
(36, 1, 2, '#include <iostream>\r\nusing namespace std;\r\n\r\nint main() {\r\n\r\n  int first_number, second_number, sum;\r\n    \r\n  cout << \"Enter two integers: \";\r\n  cin >> first_number >> second_number;\r\n\r\n  // sum of two numbers in stored in variable sumOfTwoNumbers\r\n  sum = first_number + second_number;\r\n\r\n  // prints sum \r\n  cout << first_number << \" + \" <<  second_number << \" = \" << sum;     \r\n\r\n  return 0;\r\n}', '2025-06-02 09:19:35', 'Success', 0, NULL),
(37, 1, 2, '#include <iostream>\r\nusing namespace std;\r\n\r\nint main() {\r\n\r\n  int first_number, second_number, sum;\r\n    \r\n  cout << \"Enter two integers: \";\r\n  cin >> first_number >> second_number;\r\n\r\n  // sum of two numbers in stored in variable sumOfTwoNumbers\r\n  sum = first_number + second_number;\r\n\r\n  // prints sum \r\n  cout << first_number << \" + \" <<  second_number << \" = \" << sum;     \r\n\r\n  return 0;\r\n}', '2025-06-02 15:20:00', 'Success', 0, NULL),
(38, 1, 4, 'print(\"Hello, World!\")', '2025-09-10 05:12:08', 'Success', 0, NULL),
(39, 1, 4, 'a = 10\r\nprint(a)', '2025-09-10 05:12:38', 'Success', 0, NULL),
(40, 1, 4, 'a = int(input(\"Enter a number:\"))\r\nprint(a)', '2025-09-10 05:14:27', 'Success', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `test_cases`
--

CREATE TABLE `test_cases` (
  `id` int(11) NOT NULL,
  `question_id` int(11) DEFAULT NULL,
  `input_data` text DEFAULT NULL,
  `expected_output` text DEFAULT NULL,
  `is_hidden` tinyint(1) DEFAULT 0,
  `marks` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `test_case_results`
--

CREATE TABLE `test_case_results` (
  `id` int(11) NOT NULL,
  `attempt_id` int(11) DEFAULT NULL,
  `test_case_id` int(11) DEFAULT NULL,
  `actual_output` text DEFAULT NULL,
  `is_passed` tinyint(1) DEFAULT 0,
  `execution_time` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `created_at`, `is_active`) VALUES
(1, 'ananta111', 'ogbitu25@gmail.com', '$2y$10$.GmPgfRl0gwqrFibttAwiOx9eAxXbpzvNWZe2hpd8vIvFqdnM0oYK', 'ANANTA KISHORE', '2025-05-03 10:01:18', 1),
(4, '03BSC2530', '', '$2y$10$Z8zWb/jfg8l1etEKCayZ8OxYgV2WZ3D/bbnxzVcngfnrPqEFV8lyu', 'SOUMYA RANJAN SAHU', '2026-02-12 13:39:54', 1),
(7, '03BCA2555', '03BCA2555@ocp.local', '$2y$10$Tew3WtKbzFdyjqiB9rIJ.OVBw65pi/QNR.0gJ0mg9ASp6HsTX9cQe', 'SAHIL SETHA', '2026-02-12 14:11:18', 1),
(8, '03BCA2558', '03BCA2558@ocp.local', '$2y$10$wlB1IxFfU2gpKJA5l8/9uuFJlKP0Lzl.aOn5SMtnDX.AbhyJ3S4VO', 'PRIYADARSHINI GARNAYAK', '2026-02-12 14:22:33', 1),
(9, '03BCA2530', '03BCA2530@exam.ocp', '$2y$10$cM89gZ8JIZa61brfZOOif.cmUMHlainBbQ0cPbfZSlR8.otRYskUm', 'ANANTA SWAIN', '2026-02-12 15:11:54', 1),
(10, '03BCA2501', '03BCA2501@exam.ocp', '$2y$10$nYuV5F8bu.aPw82FULejNe5cPUfLPdvgFX4W1xxtnLye2TBGnIB.K', 'PRATIK PRIYABRATA SAHU', '2026-02-12 16:41:56', 1),
(11, '03BSC2501', '03BSC2501@exam.ocp', '$2y$10$IClcCjcIFKVgThSBw5kr/e7smr/cDgfwG0/9JbceHn2sb5L1dcPoq', 'DEBJANI TRIPATHY', '2026-02-12 17:01:45', 1),
(12, '03BCA2517', '03BCA2517@exam.ocp', '$2y$10$g8L5O0N6m2XKGPrxFzld.e7zipwraFTs.XmHu781l939SlVXCjvCm', 'AJODHYA BISWAL', '2026-02-12 17:17:05', 1),
(13, '03BSC2505', '03BSC2505@exam.ocp', '$2y$10$YmQu.8fLe76Ef0Yv3r57/.RtLQDYGFnAJjxn3jRJwXN6ED6pcmNd6', 'SUBHASHREE PATTANAIK', '2026-02-12 17:22:22', 1),
(14, '03BSC2506', '03BSC2506@exam.ocp', '$2y$10$Pq/Wpl4TsDwCHZ.UUr0OL.2lHR12I8OlZwIVq0O2hTYHf4nmfRJji', 'AMLESH KUMAR SWAIN', '2026-02-12 17:23:44', 1),
(15, '03BSC2519', '03BSC2519@exam.ocp', '$2y$10$v6c1P0N/FIyGHiK95XnNreq/6egRKdDLwHlSpwYj.CBA0l8SXlroO', 'RATNAPRABHA BEHERA', '2026-02-12 17:52:42', 1),
(22, '03BCA2502', '03BCA2502@exam.ocp', '$2y$10$UBRVpYalGehyqKMkaGwyOuZUSQ3RfnL7QDRNxgBEEuuBmt02fR2d6', 'CHINMAYEE PRIYADARSINI DAS', '2026-02-12 18:38:09', 1),
(23, '03BSC2555', '03BSC2555@exam.ocp', '$2y$10$TLy2utZDD17bkklvBsFqHen17gUVMPj7IwCiaTN/avWqBquPUxdPW', 'JAYASHREE PATTNAYAK', '2026-02-12 18:51:55', 1),
(24, '03BSC2533', '03BSC2533@exam.ocp', '$2y$10$wwlrelW9mqQbfhMU6thIeOz2pyPj4gaNm7nyh125mj0zpjp.faCY6', 'SMRUTI PRAGYAN UPADHYAY', '2026-02-12 19:04:01', 1),
(25, '03BSC2561', '03BSC2561@exam.ocp', '$2y$10$8TRZYUTiCbXtHBiniEYmkO957yXRMqeDSh8/P3B7PxvtqKpUyD9u6', 'SUBHRAKANTA PATRA', '2026-02-12 19:10:15', 1),
(26, '03BSC2511', '03BSC2511@exam.ocp', '$2y$10$ojtmjzxyFuXsHD3LQts2r.j8QldvA42lOAMnFQMYzaerhebxgLmly', 'JASMINE JAYALAXMI', '2026-02-12 20:20:31', 1),
(27, '03BSC2527', '03BSC2527@exam.ocp', '$2y$10$4MzAFDooZIC.V7jXi5oadeXRuL3h2uomXVlz8ho6uaCgR0UptXXA2', 'PUJARANI SAHOO', '2026-02-12 20:21:41', 1),
(28, '03BCA2507', '03BCA2507@exam.ocp', '$2y$10$RWItl2DQ6sZL0OO9it8G.OlEe2lNUjyGzQjpXJ/xkcumPLWrBx6kG', 'SMRUTI ROUT', '2026-02-12 20:22:56', 1),
(29, '03BSC2551', '03BSC2551@exam.ocp', '$2y$10$Grv8tGRcjvJgKbzWRE0YFuCp50WFb0YmLJnQGUY2acz8NdplmLS8i', 'JAYASHREE PATI', '2026-02-13 03:51:42', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `exam_results`
--
ALTER TABLE `exam_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `exam_id` (`exam_id`);

--
-- Indexes for table `exam_sessions`
--
ALTER TABLE `exam_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_exam_session` (`user_id`,`exam_id`),
  ADD KEY `exam_id` (`exam_id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `language_id` (`language_id`);

--
-- Indexes for table `question_attempts`
--
ALTER TABLE `question_attempts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_question_attempt` (`user_id`,`question_id`,`attempt_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `attempt_id` (`attempt_id`);

--
-- Indexes for table `section_timer`
--
ALTER TABLE `section_timer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student_attempts`
--
ALTER TABLE `student_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `language_id` (`language_id`);

--
-- Indexes for table `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `language_id` (`language_id`);

--
-- Indexes for table `test_cases`
--
ALTER TABLE `test_cases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `test_case_results`
--
ALTER TABLE `test_case_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attempt_id` (`attempt_id`),
  ADD KEY `test_case_id` (`test_case_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `exam_results`
--
ALTER TABLE `exam_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exam_sessions`
--
ALTER TABLE `exam_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `question_attempts`
--
ALTER TABLE `question_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `section_timer`
--
ALTER TABLE `section_timer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_attempts`
--
ALTER TABLE `student_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `submissions`
--
ALTER TABLE `submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `test_cases`
--
ALTER TABLE `test_cases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `test_case_results`
--
ALTER TABLE `test_case_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `exam_results`
--
ALTER TABLE `exam_results`
  ADD CONSTRAINT `exam_results_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `exam_results_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`);

--
-- Constraints for table `exam_sessions`
--
ALTER TABLE `exam_sessions`
  ADD CONSTRAINT `exam_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `exam_sessions_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`),
  ADD CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`);

--
-- Constraints for table `question_attempts`
--
ALTER TABLE `question_attempts`
  ADD CONSTRAINT `question_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `question_attempts_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  ADD CONSTRAINT `question_attempts_ibfk_3` FOREIGN KEY (`attempt_id`) REFERENCES `student_attempts` (`id`);

--
-- Constraints for table `student_attempts`
--
ALTER TABLE `student_attempts`
  ADD CONSTRAINT `student_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `student_attempts_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  ADD CONSTRAINT `student_attempts_ibfk_3` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`);

--
-- Constraints for table `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `submissions_ibfk_3` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`);

--
-- Constraints for table `test_cases`
--
ALTER TABLE `test_cases`
  ADD CONSTRAINT `test_cases_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`);

--
-- Constraints for table `test_case_results`
--
ALTER TABLE `test_case_results`
  ADD CONSTRAINT `test_case_results_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `student_attempts` (`id`),
  ADD CONSTRAINT `test_case_results_ibfk_2` FOREIGN KEY (`test_case_id`) REFERENCES `test_cases` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
