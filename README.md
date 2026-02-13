# Online Coding Platform & Secure Exam System

A professional, high-security web application designed for conducting automated coding assessments. This platform provides a seamless "whitish" professional interface for students while maintaining strict academic integrity through advanced proctoring features.

## 🚀 Key Features

* **Secure IDE**: Integrated CodeMirror editor with support for C and Python 3.
* **Real-time Execution**: Leverages the Piston API for instant code compilation and execution.
* **Advanced Proctoring**:
    * **Fullscreen Enforcement**: Exam auto-submits if the user exits fullscreen mode.
    * **Tab-Switch Detection**: Automatic submission if the user switches browser tabs or windows.
    * **Anti-Cheat**: Context menu (right-click) and common keyboard shortcuts are disabled.
* **Responsive UI**: Optimized split-screen layout for both Desktop and Mobile devices.
* **Auto-Grading**: Instant marking for MCQs and server-side output verification for coding tasks (5 marks per task).

## 🛠️ Technical Stack

* **Backend**: PHP 8.x
* **Database**: MySQL (Dual-database sync for student records and exam data)
* **Frontend**: Bootstrap 5, JavaScript (ES6+), Animate.css
* **Editor**: CodeMirror 5
* **API**: [Piston API](https://emkc.org/api/v2/piston/execute)

## 📂 Project Structure

* `/admin`: Dashboard and Result Management.
* `/user`: Student Exam Interface and Submission logic.
* `/includes`: Database connection, authentication, and core API functions.
* `/sql`: Database schema files (`coding.sql`).

## ⚙️ Installation

1.  Clone the repository:
    ```bash
    git clone [https://github.com/yourusername/coding-exam-platform.git](https://github.com/yourusername/coding-exam-platform.git)
    ```
2.  Import `coding.sql` and your student database into your MySQL server.
3.  Configure your database credentials in `includes/auth.php` or `config.php`.
4.  Ensure your server has an active internet connection to reach the Piston API for code execution.

## 🔒 Security Notice
The proctoring engine uses the `Visibility API` and `Fullscreen API`. For best results, students should use modern browsers like Chrome or Edge and disable system notifications.

---
**Developed as a Final Year Project for Batch 2025-29.**
