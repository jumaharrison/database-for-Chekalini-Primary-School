# database-for-Chekalini-Primary-School

-- Create database
CREATE DATABASE IF NOT EXISTS chekalini_primary;
USE chekalini_primary;

-- 1. Guardians Table
CREATE TABLE guardians (
    guardian_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    relationship ENUM('Father', 'Mother', 'Guardian') NOT NULL
);

-- 2. Teachers Table
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20) UNIQUE,
    hire_date DATE NOT NULL
);

-- 3. Subjects Table
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Classes Table
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(20) NOT NULL UNIQUE,
    class_teacher_id INT UNIQUE,  -- Each class has one teacher (1:1)
    FOREIGN KEY (class_teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 5. Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    class_id INT NOT NULL,
    guardian_id INT NOT NULL,
    admission_date DATE NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 6. Terms Table
CREATE TABLE terms (
    term_id INT AUTO_INCREMENT PRIMARY KEY,
    academic_year VARCHAR(10) NOT NULL,
    term_name ENUM('Term 1', 'Term 2', 'Term 3') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    UNIQUE (academic_year, term_name)
);

-- 7. Marks Table (Join Table for Students ↔ Subjects)
CREATE TABLE marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    term_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) CHECK (marks_obtained >= 0 AND marks_obtained <= 100),
    exam_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (term_id) REFERENCES terms(term_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (student_id, subject_id, term_id) -- Prevent duplicate entries
);

-- 8. Attendance Table
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (student_id, date) -- One attendance record per day per student
);

-- 9. Teacher_Subject Table (M:N between Teachers and Subjects)
CREATE TABLE teacher_subject (
    teacher_id INT NOT NULL,
    subject_id INT NOT NULL,
    PRIMARY KEY (teacher_id, subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
