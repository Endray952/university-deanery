CREATE TYPE student_status_type AS ENUM ('enrolled', 'graduated', 'expelled', 'academic_leave');

CREATE TYPE direction_type AS ENUM ('baccalaureate', 'magistracy');

CREATE TYPE lesson_type AS ENUM ('practice','lecture','credit','exam');

CREATE TYPE assessment_type AS ENUM ('exam','credit','credit_with_mark');

CREATE TYPE academic_degree_type AS ENUM ('assistant','teacher','senior teacher','docent','professor');

CREATE TYPE semestr_type AS ENUM ('autumn','spring');

CREATE TYPE system_role AS ENUM ('student', 'teacher', 'dean', 'rector', 'admin');


ALTER TYPE student_status_type RENAME VALUE 'studying' TO 'enrolled';