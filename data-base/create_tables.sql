
CREATE TABLE "system_user" (
"id" UUID PRIMARY KEY,
"login" VARCHAR(30) NOT NULL,
"hashed_password" VARCHAR(60) NOT NULL,
"role" system_role NOT NULL,
"personId" UUID NOT NULL
);

INSERT INTO "system_user" (id, login, hashed_password, "role", "personId")
VALUES (uuid_generate_v4(), 'admin', '228', 'admin', uuid_generate_v4());

SELECT EXISTS(
            SELECT * FROM "system_user"
            WHERE "system_user"."id" = 'efa31b50-238a-4673-b36f-b70ed6563aa7');

/*
	student
*/
CREATE TABLE IF NOT EXISTS "student" (
	"id" UUID PRIMARY KEY,
	"name" varchar(50) NOT NULL,
	"surname" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL,
	"birthday" date NOT NULL,
	"passport" varchar(10) NOT NULL,
	"phone_number" varchar(20) NOT NULL
);

/*
	feedback
*/
CREATE TABLE IF NOT EXISTS "feedback" (
	"id" UUID PRIMARY KEY ,
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"feedback_text" TEXT,
	"date" timestamp NOT NULL
);

/*
	student_status
*/
CREATE TABLE IF NOT EXISTS "student_status" (
	"id" UUID PRIMARY KEY ,
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"student_status" student_status_type NOT NULL ,
	"status_date" date NOT NULL
);

/*
	student_group
*/
CREATE TABLE IF NOT EXISTS "student_group" (
	"id" UUID PRIMARY KEY ,
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"group_id" UUID NOT NULL REFERENCES "group"("id"),
	"start_in_group_date" date NOT NULL,
	"end_in_group_date" date
);


/*
	teacher
*/
CREATE TABLE  IF NOT EXISTS "teacher" (
	"id" UUID PRIMARY KEY,
	"name" varchar(50) NOT NULL,
	"surname" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL,
	"birthday" date NOT NULL,
	"passport" varchar(10) NOT NULL,
	"phone_number" varchar(20) NOT NULL,
	"academic_degree" academic_degree_type NOT NULL 
);

/*
	teacher status
*/
CREATE TABLE IF NOT EXISTS "teacher_status" (
	"id" UUID PRIMARY KEY ,
	 "teacher_id" UUID NOT NULL REFERENCES "teacher"("id"),
	"status_start_date" date NOT NULL,
	"status_end_date" date 
);

/*
	subject
*/
CREATE TABLE  "subject" (
	"id" UUID PRIMARY KEY ,
	"name" varchar(100)
);

/*
	teacher subject
*/
CREATE TABLE  "teacher_subject" (
	 "teacher_id" UUID NOT NULL REFERENCES "teacher"("id"),
	 "subject_id" UUID NOT NULL REFERENCES "subject"("id"),
	 PRIMARY KEY ( "teacher_id", "subject_id")
);

/*
	classroom
*/
CREATE TABLE "classroom" (
	"id" UUID PRIMARY KEY ,
	"name" varchar(60) NOT NULL ,
	"capacity" SMALLINT,
	"is_working" bool NOT NULL
);

/*
	lesson
*/
CREATE TABLE  "lesson" (
	"id" UUID PRIMARY KEY ,
	"teacher_subject_id" UUID NOT NULL REFERENCES "teacher_subject"("id"),
	"classroom_id" UUID  REFERENCES "classroom"("id"),
	"start_date" timestamp  NOT NULL,
	"end_date" timestamp NOT NULL,
	"lesson_type" lesson_type NOT NULL  
);

/*
	attendance
*/
CREATE TABLE  "attendance" (
	"id" UUID PRIMARY KEY ,
	"lesson_id" UUID NOT NULL REFERENCES "lesson"("id"),
	"student_id" UUID NOT NULL REFERENCES "student"("id"), 
	"is_attendant" bool NOT NULL 
);

/*
	mark
*/
CREATE TABLE  "mark" (
	"id" UUID PRIMARY KEY ,
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"lesson_id" UUID NOT NULL REFERENCES "lesson"("id"),
	"mark_value"  SMALLINT NOT NULL
);

/*
	dean
*/
CREATE TABLE "dean" (
	"id" UUID PRIMARY KEY,
	"name" varchar(50) NOT NULL,
	"surname" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL,
	"birthday" date NOT NULL,
	"passport" varchar(10) NOT NULL,
	"phone_number" varchar(20) NOT NULL
);

/*
	dean_status
*/
CREATE TABLE "dean_status" (
	"id" UUID PRIMARY KEY,
	 "dean_id" UUID NOT NULL REFERENCES "dean"("id"),
	"institute_id" UUID NOT NULL REFERENCES "institute"("id"),
	"work_start_date" date NOT NULL,
	"work_end_date" date 
);

/*
	institute
*/
CREATE TABLE "institute" (
	"id" UUID PRIMARY KEY,
	"name" varchar(100),
	 "dean_id" UUID NOT NULL REFERENCES "dean"("id")
);

/*
	direction
*/
CREATE TABLE "direction" (
	"id" UUID PRIMARY KEY ,
	"name" varchar (50) NOT NULL,
	"direction_type" direction_type  NOT NULL ,
	 "institute_id" UUID NOT NULL REFERENCES "institute"("id")
);

CREATE TABLE "studying_year"(
	"id" UUID PRIMARY KEY,
	"year_number" varchar(9) NOT NULL,
	"semestr_type" semestr_type NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"start_session_date" date NOT NULL,
	"end_session_date" date NOT NULL,
);
/*
	studying plan
*/
CREATE TABLE "studying_plan" (
	"id" UUID PRIMARY KEY ,
	"direction_id" UUID NOT NULL REFERENCES "direction"("id"),
	"start_year" UUID NOT NULL REFERENCES "studying_year"("id")
);

/*
	semestr plan
*/
CREATE TABLE "semestr_plan" (
	"id" UUID PRIMARY KEY ,
	"studying_plan_id" UUID NOT NULL REFERENCES "studying_plan"("id"),
	"semestr" SMALLINT NOT NULL
);

/*
	subject plan
*/
CREATE TABLE "subject_plan" (
	"id" UUID PRIMARY KEY ,
	 "semestr_plan_id" UUID NOT NULL REFERENCES "semestr_plan"("id"),
	 "subject" UUID NOT NULL REFERENCES "subject"("id"),
	"lectures_number" SMALLINT NOT NULL, 
	"practices_number" SMALLINT NOT NULL,
	"assesment_type" assessment_type NOT NULL
);

/*
	group
*/
CREATE TABLE "group" (
	"id" UUID PRIMARY KEY ,
	 "direction_id" UUID NOT NULL REFERENCES "direction"("id"),
	"semestr_number" SMALLINT NOT NULL,
	"code_number" VARCHAR(5) NOT NULL,
	"studying_plan_id" UUID NOT NULL REFERENCES "studying_plan"("id")
);

/*
	group_lesson
*/
CREATE TABLE "group_lesson" (
	"id" UUID PRIMARY KEY ,
	 "group_id"  UUID NOT NULL REFERENCES "group"("id"),
	 "lesson_id"  UUID NOT NULL REFERENCES "lesson"("id")
);

/*
	extra_classes
*/
CREATE TABLE "extra_classes" (
	"id" UUID PRIMARY KEY ,
	"teacher_id" UUID NOT NULL REFERENCES "teacher"("id"),
	"subject_id" UUID NOT NULL REFERENCES "subject"("id"),
	"start_date" timestamp NOT NULL,
	"end_date" timestamp NOT NULL,
	"classroom_id" UUID NOT NULL REFERENCES "classroom"("id")
);

/*
	student_extra_classes
*/
CREATE TABLE "student_extra_classes" (
	"id" UUID PRIMARY KEY ,
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"extra_classes_id"  UUID NOT NULL REFERENCES "extra_classes"("id")
);


/*
	rector
*/
CREATE TABLE "rector" (
	"id" UUID PRIMARY KEY,
	"name" varchar(50) NOT NULL,
	"surname" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL,
	"birthday" date NOT NULL,
	"passport" varchar(10) NOT NULL,
	"phone_number" varchar(20) NOT NULL
);

CREATE TABLE "rector_status" (
	"id" UUID PRIMARY KEY,
	"rector_id" UUID NOT NULL REFERENCES "rector"("id"),
	"start_work_date" date NOT NULL,
	"end_work_date" date
);


CREATE TABLE "attendance" (
	"id" UUID PRIMARY KEY,
	"lesson_id" UUID NOT NULL REFERENCES "lesson"("id"),
	"student_id" UUID NOT NULL REFERENCES "student"("id"),
	"attended" bool NOT NULL
);




