PGDMP     1                    z            postgres    15.1    15.1 ~    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    5    postgres    DATABASE     |   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3557                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false            �           0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2                        3079    16415 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    3            �           1247    16490    academic_degree_type    TYPE     �   CREATE TYPE public.academic_degree_type AS ENUM (
    'assistant',
    'teacher',
    'senior teacher',
    'docent',
    'professor'
);
 '   DROP TYPE public.academic_degree_type;
       public          postgres    false            �           1247    16482    assessment_type    TYPE     a   CREATE TYPE public.assessment_type AS ENUM (
    'exam',
    'credit',
    'credit_with_mark'
);
 "   DROP TYPE public.assessment_type;
       public          postgres    false                       1247    16466    direction_type    TYPE     U   CREATE TYPE public.direction_type AS ENUM (
    'baccalaureate',
    'magistracy'
);
 !   DROP TYPE public.direction_type;
       public          postgres    false            �           1247    16472    lesson_type    TYPE     d   CREATE TYPE public.lesson_type AS ENUM (
    'practice',
    'lecture',
    'credit',
    'exam'
);
    DROP TYPE public.lesson_type;
       public          postgres    false            �           1247    19741    semestr_type    TYPE     H   CREATE TYPE public.semestr_type AS ENUM (
    'autumn',
    'spring'
);
    DROP TYPE public.semestr_type;
       public          postgres    false            y           1247    16446    student_status_type    TYPE     z   CREATE TYPE public.student_status_type AS ENUM (
    'enrolled',
    'graduated',
    'expelled',
    'academic_leave'
);
 &   DROP TYPE public.student_status_type;
       public          postgres    false            �           1247    19861    system_role    TYPE     p   CREATE TYPE public.system_role AS ENUM (
    'student',
    'teacher',
    'dean',
    'rector',
    'admin'
);
    DROP TYPE public.system_role;
       public          postgres    false                       1255    19900 y   create_student(character varying, character varying, character varying, date, character varying, character varying, uuid)    FUNCTION       CREATE FUNCTION public.create_student(name character varying, surname character varying, email character varying, birthday date, passport character varying, phone_number character varying, group_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
DECLARE
  id UUID;
BEGIN
	id = gen_random_uuid();
    INSERT INTO student (id, "name", surname, email, birthday, passport, phone_number) 
    VALUES (id,$1,$2,$3,$4,$5,$6);
   
   	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), id, $7, CURRENT_DATE, null);
   
   INSERT INTO student_status  (id, student_id, student_status, status_date)
   VALUES (gen_random_uuid(), id, 'enrolled', CURRENT_TIMESTAMP);
  
   	RETURN id;
END
$_$;
 �   DROP FUNCTION public.create_student(name character varying, surname character varying, email character varying, birthday date, passport character varying, phone_number character varying, group_id uuid);
       public          postgres    false                       1255    19928    enroll_student(uuid, uuid)    FUNCTION       CREATE FUNCTION public.enroll_student(student_id uuid, group_id uuid, OUT enrolled_student_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), $1, $2, CURRENT_DATE, null);
   
   INSERT INTO student_status  (id, student_id, student_status, status_date)
   VALUES (gen_random_uuid(), $1, 'enrolled', CURRENT_TIMESTAMP)
   RETURNING student_status.student_id INTO "enrolled_student_id";
END
$_$;
 c   DROP FUNCTION public.enroll_student(student_id uuid, group_id uuid, OUT enrolled_student_id uuid);
       public          postgres    false            
           1255    19926    expell_student(uuid)    FUNCTION     \  CREATE FUNCTION public.expell_student(student_id uuid, OUT expelled_student_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
DECLARE
  last_student_group_id UUID;
BEGIN
	INSERT INTO student_status (id, student_id, student_status, status_date)
	VALUES (gen_random_uuid(), $1, 'expelled', CURRENT_TIMESTAMP );
	
	last_student_group_id = get_last_student_group_id($1);

	UPDATE student_group SET 
	end_in_group_date = CURRENT_DATE 
	WHERE student_group.student_id = $1 AND student_group.id = last_student_group_id
RETURNING student_group.student_id INTO "expelled_student_id";

END
$_$;
 T   DROP FUNCTION public.expell_student(student_id uuid, OUT expelled_student_id uuid);
       public          postgres    false                       1255    24576    get_current_student_group(uuid)    FUNCTION     5  CREATE FUNCTION public.get_current_student_group(uuid) RETURNS TABLE(group_id uuid, start_in_group_date date, end_in_group_date date)
    LANGUAGE sql
    AS $_$
SELECT student_group.group_id, student_group.start_in_group_date, student_group.end_in_group_date
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  AND student_group.end_in_group_date IS NULL
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date
$_$;
 6   DROP FUNCTION public.get_current_student_group(uuid);
       public          postgres    false                       1255    24577 "   get_current_student_group_id(uuid)    FUNCTION     �  CREATE FUNCTION public.get_current_student_group_id(uuid) RETURNS uuid
    LANGUAGE sql
    AS $_$
SELECT student_group.id
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  AND student_group.end_in_group_date IS NULL
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date;
$_$;
 9   DROP FUNCTION public.get_current_student_group_id(uuid);
       public          postgres    false                       1255    19890    get_last_student_group(uuid)    FUNCTION       CREATE FUNCTION public.get_last_student_group(uuid) RETURNS TABLE(group_id uuid, start_in_group_date date, end_in_group_date date)
    LANGUAGE sql
    AS $_$
SELECT student_group.group_id, student_group.start_in_group_date, student_group.end_in_group_date
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date
$_$;
 3   DROP FUNCTION public.get_last_student_group(uuid);
       public          postgres    false            	           1255    19925    get_last_student_group_id(uuid)    FUNCTION       CREATE FUNCTION public.get_last_student_group_id(uuid) RETURNS uuid
    LANGUAGE sql
    AS $_$
SELECT student_group.id
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date;
$_$;
 6   DROP FUNCTION public.get_last_student_group_id(uuid);
       public          postgres    false                       1255    19933    get_last_student_status(uuid)    FUNCTION     �  CREATE FUNCTION public.get_last_student_status(uuid) RETURNS TABLE(student_status public.student_status_type, status_date timestamp without time zone)
    LANGUAGE sql
    AS $_$
SELECT "student_status" student_status_type, status_date timestamp
FROM student 
JOIN student_status 
ON student.id = student_status.student_id 
WHERE student.id = $1 
ORDER BY status_date DESC
LIMIT 1
$_$;
 4   DROP FUNCTION public.get_last_student_status(uuid);
       public          postgres    false    889                       1255    19924    get_sem_by_date(date)    FUNCTION     �  CREATE FUNCTION public.get_sem_by_date(date) RETURNS TABLE(studying_year_id uuid, year_number character varying, semestr_type public.semestr_type, start_date date, end_date date)
    LANGUAGE sql
    AS $_$
SELECT
	studying_year.id,
	studying_year.year_number,
	studying_year.semestr_type,
	studying_year.start_date,
	studying_year.end_date
FROM
	studying_year
WHERE
	$1 BETWEEN studying_year.start_date AND studying_year.end_date
$_$;
 ,   DROP FUNCTION public.get_sem_by_date(date);
       public          postgres    false    931                       1255    19894    get_semestr_groups(date)    FUNCTION     /  CREATE FUNCTION public.get_semestr_groups(date) RETURNS TABLE(group_id uuid, code_number character varying, studying_plan_id uuid, semestr_number integer)
    LANGUAGE sql
    AS $_$
SELECT "group".id AS group_id ,
"group".code_number ,
"group".studying_plan_id ,
"group".semestr_number 
FROM "group"
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
CROSS JOIN get_sem_by_date($1) AS current_sem
JOIN studying_year 
ON studying_plan.start_year = studying_year.id
WHERE 
	(
		date_part('year', current_sem.start_date) - 
		date_part('year', studying_year.start_date) = 
		"group".semestr_number /2) 
	AND 
	(
		(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) 
		OR 
		(studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0)
	);
$_$;
 /   DROP FUNCTION public.get_semestr_groups(date);
       public          postgres    false                       1255    24578    transfer_student(uuid, uuid)    FUNCTION     �  CREATE FUNCTION public.transfer_student(student_id uuid, group_id uuid, OUT enrolled_student_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
	UPDATE student_group  SET 
	end_in_group_date = current_date
	WHERE student_group.id = get_current_student_group_id($1);
	
	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), $1, $2, CURRENT_DATE, null)
   	RETURNING $1 INTO "enrolled_student_id";
END
$_$;
 e   DROP FUNCTION public.transfer_student(student_id uuid, group_id uuid, OUT enrolled_student_id uuid);
       public          postgres    false            �            1259    19190 	   classroom    TABLE     �   CREATE TABLE public.classroom (
    id uuid NOT NULL,
    name character varying(60) NOT NULL,
    capacity smallint,
    is_working boolean NOT NULL
);
    DROP TABLE public.classroom;
       public         heap    postgres    false            �            1259    19250    dean    TABLE     -  CREATE TABLE public.dean (
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    birthday date NOT NULL,
    passport character varying(10) NOT NULL,
    phone_number character varying(20) NOT NULL
);
    DROP TABLE public.dean;
       public         heap    postgres    false            �            1259    19429    dean_status    TABLE     �   CREATE TABLE public.dean_status (
    id uuid NOT NULL,
    dean_id uuid NOT NULL,
    institute_id uuid NOT NULL,
    work_start_date date NOT NULL,
    work_end_date date
);
    DROP TABLE public.dean_status;
       public         heap    postgres    false            �            1259    19275 	   direction    TABLE     �   CREATE TABLE public.direction (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    direction_type public.direction_type NOT NULL,
    institute_id uuid NOT NULL
);
    DROP TABLE public.direction;
       public         heap    postgres    false    895            �            1259    19705    extra_classes    TABLE        CREATE TABLE public.extra_classes (
    id uuid NOT NULL,
    teacher_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    classroom_id uuid NOT NULL
);
 !   DROP TABLE public.extra_classes;
       public         heap    postgres    false            �            1259    19133    feedback    TABLE     �   CREATE TABLE public.feedback (
    id uuid NOT NULL,
    student_id uuid NOT NULL,
    feedback_text text NOT NULL,
    date timestamp without time zone NOT NULL
);
    DROP TABLE public.feedback;
       public         heap    postgres    false            �            1259    19795    group    TABLE     �   CREATE TABLE public."group" (
    id uuid NOT NULL,
    semestr_number smallint NOT NULL,
    code_number character varying(5) NOT NULL,
    studying_plan_id uuid NOT NULL
);
    DROP TABLE public."group";
       public         heap    postgres    false            �            1259    24627    group_lesson    TABLE     t   CREATE TABLE public.group_lesson (
    id uuid NOT NULL,
    group_id uuid NOT NULL,
    lesson_id uuid NOT NULL
);
     DROP TABLE public.group_lesson;
       public         heap    postgres    false            �            1259    19265 	   institute    TABLE     t   CREATE TABLE public.institute (
    id uuid NOT NULL,
    name character varying(100),
    dean_id uuid NOT NULL
);
    DROP TABLE public.institute;
       public         heap    postgres    false            �            1259    24612    lesson    TABLE     -  CREATE TABLE public.lesson (
    id uuid NOT NULL,
    teacher_subject_id uuid NOT NULL,
    classroom_id uuid,
    start_date timestamp without time zone NOT NULL,
    lesson_type public.lesson_type NOT NULL,
    duration time without time zone DEFAULT '01:30:00'::time without time zone NOT NULL
);
    DROP TABLE public.lesson;
       public         heap    postgres    false    898            �            1259    19395    rector    TABLE     /  CREATE TABLE public.rector (
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    birthday date NOT NULL,
    passport character varying(10) NOT NULL,
    phone_number character varying(20) NOT NULL
);
    DROP TABLE public.rector;
       public         heap    postgres    false            �            1259    19400    rector_status    TABLE     �   CREATE TABLE public.rector_status (
    id uuid NOT NULL,
    rector_id uuid NOT NULL,
    start_work_date date NOT NULL,
    end_work_date date
);
 !   DROP TABLE public.rector_status;
       public         heap    postgres    false            �            1259    19770    semestr_plan    TABLE     ~   CREATE TABLE public.semestr_plan (
    id uuid NOT NULL,
    studying_plan_id uuid NOT NULL,
    semestr smallint NOT NULL
);
     DROP TABLE public.semestr_plan;
       public         heap    postgres    false            �            1259    19128    student    TABLE     0  CREATE TABLE public.student (
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    birthday date NOT NULL,
    passport character varying(10) NOT NULL,
    phone_number character varying(20) NOT NULL
);
    DROP TABLE public.student;
       public         heap    postgres    false            �            1259    19725    student_extra_classes    TABLE     �   CREATE TABLE public.student_extra_classes (
    id uuid NOT NULL,
    student_id uuid NOT NULL,
    extra_classes_id uuid NOT NULL
);
 )   DROP TABLE public.student_extra_classes;
       public         heap    postgres    false            �            1259    19840    student_group    TABLE     �   CREATE TABLE public.student_group (
    id uuid NOT NULL,
    student_id uuid NOT NULL,
    group_id uuid NOT NULL,
    start_in_group_date date NOT NULL,
    end_in_group_date date
);
 !   DROP TABLE public.student_group;
       public         heap    postgres    false            �            1259    19446    student_status    TABLE     �   CREATE TABLE public.student_status (
    id uuid NOT NULL,
    student_id uuid NOT NULL,
    student_status public.student_status_type NOT NULL,
    status_date timestamp without time zone NOT NULL
);
 "   DROP TABLE public.student_status;
       public         heap    postgres    false    889            �            1259    19755    studying_plan    TABLE     z   CREATE TABLE public.studying_plan (
    id uuid NOT NULL,
    direction_id uuid NOT NULL,
    start_year uuid NOT NULL
);
 !   DROP TABLE public.studying_plan;
       public         heap    postgres    false            �            1259    19746    studying_year    TABLE       CREATE TABLE public.studying_year (
    id uuid NOT NULL,
    year_number character varying(9) NOT NULL,
    semestr_type public.semestr_type NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    start_session_date date NOT NULL,
    end_session_date date NOT NULL
);
 !   DROP TABLE public.studying_year;
       public         heap    postgres    false    931            �            1259    19170    subject    TABLE     W   CREATE TABLE public.subject (
    id uuid NOT NULL,
    name character varying(100)
);
    DROP TABLE public.subject;
       public         heap    postgres    false            �            1259    19780    subject_plan    TABLE     �   CREATE TABLE public.subject_plan (
    id uuid NOT NULL,
    semestr_plan_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    lectures_number smallint NOT NULL,
    practices_number smallint NOT NULL,
    assesment_type public.assessment_type NOT NULL
);
     DROP TABLE public.subject_plan;
       public         heap    postgres    false    901            �            1259    19883    system_user    TABLE     �   CREATE TABLE public.system_user (
    id uuid NOT NULL,
    login character varying(30) NOT NULL,
    hashed_password character varying(60) NOT NULL,
    role public.system_role NOT NULL,
    person_id uuid NOT NULL
);
    DROP TABLE public.system_user;
       public         heap    postgres    false    946            �            1259    19511    teacher    TABLE     ^  CREATE TABLE public.teacher (
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    birthday date NOT NULL,
    passport character varying(10) NOT NULL,
    phone_number character varying(20) NOT NULL,
    is_working boolean DEFAULT true NOT NULL
);
    DROP TABLE public.teacher;
       public         heap    postgres    false            �            1259    24580    teacher_subject    TABLE     q   CREATE TABLE public.teacher_subject (
    teacher_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    id uuid
);
 #   DROP TABLE public.teacher_subject;
       public         heap    postgres    false            �          0    19190 	   classroom 
   TABLE DATA           C   COPY public.classroom (id, name, capacity, is_working) FROM stdin;
    public          postgres    false    219   �       �          0    19250    dean 
   TABLE DATA           Z   COPY public.dean (id, name, surname, email, birthday, passport, phone_number) FROM stdin;
    public          postgres    false    220   (�       �          0    19429    dean_status 
   TABLE DATA           `   COPY public.dean_status (id, dean_id, institute_id, work_start_date, work_end_date) FROM stdin;
    public          postgres    false    225   ��       �          0    19275 	   direction 
   TABLE DATA           K   COPY public.direction (id, name, direction_type, institute_id) FROM stdin;
    public          postgres    false    222   6�       �          0    19705    extra_classes 
   TABLE DATA           g   COPY public.extra_classes (id, teacher_id, subject_id, start_date, end_date, classroom_id) FROM stdin;
    public          postgres    false    228   ��       �          0    19133    feedback 
   TABLE DATA           G   COPY public.feedback (id, student_id, feedback_text, date) FROM stdin;
    public          postgres    false    217   ��       �          0    19795    group 
   TABLE DATA           T   COPY public."group" (id, semestr_number, code_number, studying_plan_id) FROM stdin;
    public          postgres    false    234   l�       �          0    24627    group_lesson 
   TABLE DATA           ?   COPY public.group_lesson (id, group_id, lesson_id) FROM stdin;
    public          postgres    false    239   ��       �          0    19265 	   institute 
   TABLE DATA           6   COPY public.institute (id, name, dean_id) FROM stdin;
    public          postgres    false    221   ��       �          0    24612    lesson 
   TABLE DATA           i   COPY public.lesson (id, teacher_subject_id, classroom_id, start_date, lesson_type, duration) FROM stdin;
    public          postgres    false    238   F�       �          0    19395    rector 
   TABLE DATA           \   COPY public.rector (id, name, surname, email, birthday, passport, phone_number) FROM stdin;
    public          postgres    false    223   �      �          0    19400    rector_status 
   TABLE DATA           V   COPY public.rector_status (id, rector_id, start_work_date, end_work_date) FROM stdin;
    public          postgres    false    224   m      �          0    19770    semestr_plan 
   TABLE DATA           E   COPY public.semestr_plan (id, studying_plan_id, semestr) FROM stdin;
    public          postgres    false    232   �      �          0    19128    student 
   TABLE DATA           ]   COPY public.student (id, name, surname, email, birthday, passport, phone_number) FROM stdin;
    public          postgres    false    216   �$      �          0    19725    student_extra_classes 
   TABLE DATA           Q   COPY public.student_extra_classes (id, student_id, extra_classes_id) FROM stdin;
    public          postgres    false    229   �,      �          0    19840    student_group 
   TABLE DATA           i   COPY public.student_group (id, student_id, group_id, start_in_group_date, end_in_group_date) FROM stdin;
    public          postgres    false    235   �9      �          0    19446    student_status 
   TABLE DATA           U   COPY public.student_status (id, student_id, student_status, status_date) FROM stdin;
    public          postgres    false    226   B      �          0    19755    studying_plan 
   TABLE DATA           E   COPY public.studying_plan (id, direction_id, start_year) FROM stdin;
    public          postgres    false    231   �K      �          0    19746    studying_year 
   TABLE DATA           �   COPY public.studying_year (id, year_number, semestr_type, start_date, end_date, start_session_date, end_session_date) FROM stdin;
    public          postgres    false    230   N      �          0    19170    subject 
   TABLE DATA           +   COPY public.subject (id, name) FROM stdin;
    public          postgres    false    218   
O      �          0    19780    subject_plan 
   TABLE DATA           z   COPY public.subject_plan (id, semestr_plan_id, subject_id, lectures_number, practices_number, assesment_type) FROM stdin;
    public          postgres    false    233   �P      �          0    19883    system_user 
   TABLE DATA           R   COPY public.system_user (id, login, hashed_password, role, person_id) FROM stdin;
    public          postgres    false    236   �      �          0    19511    teacher 
   TABLE DATA           i   COPY public.teacher (id, name, surname, email, birthday, passport, phone_number, is_working) FROM stdin;
    public          postgres    false    227   ��      �          0    24580    teacher_subject 
   TABLE DATA           E   COPY public.teacher_subject (teacher_id, subject_id, id) FROM stdin;
    public          postgres    false    237   ��      �           2606    19194    classroom classroom_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.classroom DROP CONSTRAINT classroom_pkey;
       public            postgres    false    219            �           2606    19254    dean dean_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.dean
    ADD CONSTRAINT dean_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.dean DROP CONSTRAINT dean_pkey;
       public            postgres    false    220                       2606    19433    dean_status dean_status_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.dean_status
    ADD CONSTRAINT dean_status_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.dean_status DROP CONSTRAINT dean_status_pkey;
       public            postgres    false    225            �           2606    19279    direction direction_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.direction
    ADD CONSTRAINT direction_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.direction DROP CONSTRAINT direction_pkey;
       public            postgres    false    222                       2606    19709     extra_classes extra_classes_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.extra_classes
    ADD CONSTRAINT extra_classes_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.extra_classes DROP CONSTRAINT extra_classes_pkey;
       public            postgres    false    228            �           2606    19139    feedback feedback_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.feedback DROP CONSTRAINT feedback_pkey;
       public            postgres    false    217                       2606    24631    group_lesson group_lesson_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.group_lesson DROP CONSTRAINT group_lesson_pkey;
       public            postgres    false    239                       2606    19799    group group_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."group" DROP CONSTRAINT group_pkey;
       public            postgres    false    234            �           2606    19269    institute institute_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.institute
    ADD CONSTRAINT institute_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.institute DROP CONSTRAINT institute_pkey;
       public            postgres    false    221                       2606    24616    lesson lesson_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.lesson DROP CONSTRAINT lesson_pkey;
       public            postgres    false    238            �           2606    19399    rector rector_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.rector
    ADD CONSTRAINT rector_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.rector DROP CONSTRAINT rector_pkey;
       public            postgres    false    223            �           2606    19404     rector_status rector_status_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.rector_status
    ADD CONSTRAINT rector_status_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.rector_status DROP CONSTRAINT rector_status_pkey;
       public            postgres    false    224                       2606    19774    semestr_plan semestr_plan_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.semestr_plan
    ADD CONSTRAINT semestr_plan_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.semestr_plan DROP CONSTRAINT semestr_plan_pkey;
       public            postgres    false    232            	           2606    19729 0   student_extra_classes student_extra_classes_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.student_extra_classes
    ADD CONSTRAINT student_extra_classes_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.student_extra_classes DROP CONSTRAINT student_extra_classes_pkey;
       public            postgres    false    229                       2606    19844     student_group student_group_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.student_group DROP CONSTRAINT student_group_pkey;
       public            postgres    false    235            �           2606    19132    student student_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.student DROP CONSTRAINT student_pkey;
       public            postgres    false    216                       2606    19450 "   student_status student_status_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.student_status
    ADD CONSTRAINT student_status_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.student_status DROP CONSTRAINT student_status_pkey;
       public            postgres    false    226                       2606    19759     studying_plan studying_plan_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.studying_plan
    ADD CONSTRAINT studying_plan_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.studying_plan DROP CONSTRAINT studying_plan_pkey;
       public            postgres    false    231                       2606    19750     studying_year studying_year_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.studying_year
    ADD CONSTRAINT studying_year_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.studying_year DROP CONSTRAINT studying_year_pkey;
       public            postgres    false    230            �           2606    19174    subject subject_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.subject DROP CONSTRAINT subject_pkey;
       public            postgres    false    218                       2606    19784    subject_plan subject_plan_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.subject_plan
    ADD CONSTRAINT subject_plan_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.subject_plan DROP CONSTRAINT subject_plan_pkey;
       public            postgres    false    233                       2606    19887    system_user system_user_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.system_user
    ADD CONSTRAINT system_user_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.system_user DROP CONSTRAINT system_user_pkey;
       public            postgres    false    236                       2606    19515    teacher teacher_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.teacher DROP CONSTRAINT teacher_pkey;
       public            postgres    false    227                       2606    24611 &   teacher_subject teacher_subject_id_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_id_key UNIQUE (id);
 P   ALTER TABLE ONLY public.teacher_subject DROP CONSTRAINT teacher_subject_id_key;
       public            postgres    false    237                       2606    24584 $   teacher_subject teacher_subject_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_pkey PRIMARY KEY (teacher_id, subject_id);
 N   ALTER TABLE ONLY public.teacher_subject DROP CONSTRAINT teacher_subject_pkey;
       public            postgres    false    237    237            $           2606    19434 $   dean_status dean_status_dean_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dean_status
    ADD CONSTRAINT dean_status_dean_id_fkey FOREIGN KEY (dean_id) REFERENCES public.dean(id);
 N   ALTER TABLE ONLY public.dean_status DROP CONSTRAINT dean_status_dean_id_fkey;
       public          postgres    false    225    3319    220            %           2606    19439 )   dean_status dean_status_institute_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dean_status
    ADD CONSTRAINT dean_status_institute_id_fkey FOREIGN KEY (institute_id) REFERENCES public.institute(id);
 S   ALTER TABLE ONLY public.dean_status DROP CONSTRAINT dean_status_institute_id_fkey;
       public          postgres    false    225    3321    221            "           2606    19280 %   direction direction_institute_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.direction
    ADD CONSTRAINT direction_institute_id_fkey FOREIGN KEY (institute_id) REFERENCES public.institute(id);
 O   ALTER TABLE ONLY public.direction DROP CONSTRAINT direction_institute_id_fkey;
       public          postgres    false    3321    222    221            '           2606    19720 -   extra_classes extra_classes_classroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.extra_classes
    ADD CONSTRAINT extra_classes_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id);
 W   ALTER TABLE ONLY public.extra_classes DROP CONSTRAINT extra_classes_classroom_id_fkey;
       public          postgres    false    219    228    3317            (           2606    19715 +   extra_classes extra_classes_subject_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.extra_classes
    ADD CONSTRAINT extra_classes_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);
 U   ALTER TABLE ONLY public.extra_classes DROP CONSTRAINT extra_classes_subject_id_fkey;
       public          postgres    false    218    3315    228            )           2606    19710 +   extra_classes extra_classes_teacher_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.extra_classes
    ADD CONSTRAINT extra_classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);
 U   ALTER TABLE ONLY public.extra_classes DROP CONSTRAINT extra_classes_teacher_id_fkey;
       public          postgres    false    228    227    3333                        2606    19140 !   feedback feedback_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);
 K   ALTER TABLE ONLY public.feedback DROP CONSTRAINT feedback_student_id_fkey;
       public          postgres    false    217    216    3311            8           2606    24632 '   group_lesson group_lesson_group_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(id);
 Q   ALTER TABLE ONLY public.group_lesson DROP CONSTRAINT group_lesson_group_id_fkey;
       public          postgres    false    234    239    3347            9           2606    24637 (   group_lesson group_lesson_lesson_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id);
 R   ALTER TABLE ONLY public.group_lesson DROP CONSTRAINT group_lesson_lesson_id_fkey;
       public          postgres    false    239    3357    238            1           2606    19805 !   group group_studying_plan_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_studying_plan_id_fkey FOREIGN KEY (studying_plan_id) REFERENCES public.studying_plan(id);
 M   ALTER TABLE ONLY public."group" DROP CONSTRAINT group_studying_plan_id_fkey;
       public          postgres    false    234    231    3341            !           2606    19270     institute institute_dean_id_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.institute
    ADD CONSTRAINT institute_dean_id_fkey FOREIGN KEY (dean_id) REFERENCES public.dean(id);
 J   ALTER TABLE ONLY public.institute DROP CONSTRAINT institute_dean_id_fkey;
       public          postgres    false    220    3319    221            6           2606    24622    lesson lesson_classroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id);
 I   ALTER TABLE ONLY public.lesson DROP CONSTRAINT lesson_classroom_id_fkey;
       public          postgres    false    238    219    3317            7           2606    24617 %   lesson lesson_teacher_subject_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_teacher_subject_id_fkey FOREIGN KEY (teacher_subject_id) REFERENCES public.teacher_subject(id);
 O   ALTER TABLE ONLY public.lesson DROP CONSTRAINT lesson_teacher_subject_id_fkey;
       public          postgres    false    3353    238    237            #           2606    19405 *   rector_status rector_status_rector_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rector_status
    ADD CONSTRAINT rector_status_rector_id_fkey FOREIGN KEY (rector_id) REFERENCES public.rector(id);
 T   ALTER TABLE ONLY public.rector_status DROP CONSTRAINT rector_status_rector_id_fkey;
       public          postgres    false    224    223    3325            .           2606    19775 /   semestr_plan semestr_plan_studying_plan_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.semestr_plan
    ADD CONSTRAINT semestr_plan_studying_plan_id_fkey FOREIGN KEY (studying_plan_id) REFERENCES public.studying_plan(id);
 Y   ALTER TABLE ONLY public.semestr_plan DROP CONSTRAINT semestr_plan_studying_plan_id_fkey;
       public          postgres    false    231    232    3341            *           2606    19735 A   student_extra_classes student_extra_classes_extra_classes_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_extra_classes
    ADD CONSTRAINT student_extra_classes_extra_classes_id_fkey FOREIGN KEY (extra_classes_id) REFERENCES public.extra_classes(id);
 k   ALTER TABLE ONLY public.student_extra_classes DROP CONSTRAINT student_extra_classes_extra_classes_id_fkey;
       public          postgres    false    228    3335    229            +           2606    19730 ;   student_extra_classes student_extra_classes_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_extra_classes
    ADD CONSTRAINT student_extra_classes_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);
 e   ALTER TABLE ONLY public.student_extra_classes DROP CONSTRAINT student_extra_classes_student_id_fkey;
       public          postgres    false    3311    229    216            2           2606    19850 )   student_group student_group_group_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(id);
 S   ALTER TABLE ONLY public.student_group DROP CONSTRAINT student_group_group_id_fkey;
       public          postgres    false    235    234    3347            3           2606    19845 +   student_group student_group_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);
 U   ALTER TABLE ONLY public.student_group DROP CONSTRAINT student_group_student_id_fkey;
       public          postgres    false    216    3311    235            &           2606    19451 -   student_status student_status_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_status
    ADD CONSTRAINT student_status_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);
 W   ALTER TABLE ONLY public.student_status DROP CONSTRAINT student_status_student_id_fkey;
       public          postgres    false    3311    216    226            ,           2606    19760 -   studying_plan studying_plan_direction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.studying_plan
    ADD CONSTRAINT studying_plan_direction_id_fkey FOREIGN KEY (direction_id) REFERENCES public.direction(id);
 W   ALTER TABLE ONLY public.studying_plan DROP CONSTRAINT studying_plan_direction_id_fkey;
       public          postgres    false    3323    231    222            -           2606    19765 +   studying_plan studying_plan_start_year_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.studying_plan
    ADD CONSTRAINT studying_plan_start_year_fkey FOREIGN KEY (start_year) REFERENCES public.studying_year(id);
 U   ALTER TABLE ONLY public.studying_plan DROP CONSTRAINT studying_plan_start_year_fkey;
       public          postgres    false    231    230    3339            /           2606    19785 .   subject_plan subject_plan_semestr_plan_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subject_plan
    ADD CONSTRAINT subject_plan_semestr_plan_id_fkey FOREIGN KEY (semestr_plan_id) REFERENCES public.semestr_plan(id);
 X   ALTER TABLE ONLY public.subject_plan DROP CONSTRAINT subject_plan_semestr_plan_id_fkey;
       public          postgres    false    3343    233    232            0           2606    19790 &   subject_plan subject_plan_subject_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subject_plan
    ADD CONSTRAINT subject_plan_subject_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);
 P   ALTER TABLE ONLY public.subject_plan DROP CONSTRAINT subject_plan_subject_fkey;
       public          postgres    false    233    218    3315            4           2606    24590 /   teacher_subject teacher_subject_subject_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);
 Y   ALTER TABLE ONLY public.teacher_subject DROP CONSTRAINT teacher_subject_subject_id_fkey;
       public          postgres    false    237    218    3315            5           2606    24585 /   teacher_subject teacher_subject_teacher_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);
 Y   ALTER TABLE ONLY public.teacher_subject DROP CONSTRAINT teacher_subject_teacher_id_fkey;
       public          postgres    false    3333    227    237            �   )  x�U��,9�5��x�G.����_�1UcPl �I�xĩ�;���]�Ƹ;2�uf!�b��_��GS�]��j9j�����nN��.Y����o�氪rQ��u4�U�A{�;�-$\���<�9���@�N�Ж��\�y4��^X�{�A�ne(ߔ�ֹ�wW�D1� p[�@��2�y�pY�G������5Ƌ��]��ڮ<�V��5i�q��Sx�I�~���j$�̺n8��U��!]��r�r��śs6o�U���YǾT�����g2��/��R���P𧬘��d�>����|�!��].�5�溳�î��h�B�L���¬�Y�e8xy�>�]h�BP���h��k:uL��}cR�Qo��4�F��̢�j^�3�J��?��Yuʹ�m��͵��H�):L�퇓���0�=8H��>,����gB%Fe�G�H��)�v{`�@im=�ٽ�\�_�z{f�_����׉�Q��1`P�Kaz���Ղa����>'��Dz�03��#r���EZ��,����_�hu��j7�o��/��8����4!�T�!Li�gn[����j|��}[Lk��.׋Ї������u�r���}R$Y��Iܧ�M{�ڇ|f\h�����{rܕ@���_7Y^i�>�w]'�����V�F�_v/{�IU�[Rɇ�8`gy�h�c�Y�]���;>��O���xH���l��v�I/�����Ӷ6
����iu���s��3n���٪��֐sp'��p��QD�]�~7%E�6{�ՆwB�F�<���I�������@TD.����2�Ӣ����c��8�Yd�.	B�j�ۻ�c���>�z��fS������<�z#�H&�,�õ�Lކ]\'�� �@�G��>�����T<��B!z�5�]�*�H�$ӱC�>g%Ȟy�AiTu�"�`�ۑ�y�"��*��&Zq!�u�>	7�q���y��Ʉزn�{i"?�m�m�ӺbWzAs�b`=y,l٪�^Bk�
?bl����,��7'N�d�H���*�F�a�=`Yh�r���ǳ�Wޯy�)�i�n�}��On���L:��ps�^c��h���zs=-/���s�C�1�X	��/�c�t��Cb=�t������n�H�#va����'����!6A�ip+��c���B	���h�B΅�]�t�`	�KK㖠O�m�;D�c�-�^�94~�.m!z�,�j�q�B����g\�����E�-�x^��\�z"�s�28 u�M^n���~���WT&�      �   �  x�M�=��0@k���HH�I���+�|��4iƖ�k��A���3N�b�����y�L�tv�5B=x��b�\�������mW�ʺp��۽�v/��t���790���\��vV���c����8:�ѝcL(t�B ��VxXk��e����~H�����>��v�������[[��ם��*D3-���6��<��{u�O��S� Х�����j������=�9������v�ʏ�1�y���|�m+���:�M3���u�iBC
���AMgGIG�	�,�P!�^zk��1Zˁ��;�iS�Kc�"���1-�̹��\�P���#��h��T��)�A>Rt9�1S4�P4���C��@ET�sU/k㱨g^�2��a�Y��M-���X�>�m�y2�� ��"� B ��蔒?\J`��t]���j      �   C  x���͍�1@���Bd�g�D*؋1�	a���:K #�3��&f8��l��j	�\�ǭ#S �8��|aR�5L9�t뼋��$ E��Smwј}3������3(�y�<p�f���i�(R�U���\z�Ha��q���{ξH�v�Ul;��]�������F��;ћa����ey���Z�h˼(�y2��@b`�;J��y�V(է���P����iաL'𪂝���Oמ9���Ba�h����Q�pĵ�8z>�xc$�}^2�5|�l	c����������=��7��u�mո����%ַ�ׯ���t�O      �   H  x���KN1��3���f&O߅��xlJY��x�H=0-T�q��F�R���Ŗ����?Ī�L
�u�� !4	�Y�&����R�y�?�*y�7y(�Q^K�͋}����U���V�L�@1�]��&\ul(����K�U��-+P��uk=6���c��,h�^K�I!��9��ʯ����c^wS���(ϥL�K:;���)�GU�q�B׃��!���!Em��?�l���\�f���]2��t,��o��)�{��q#�Z�&R�gUkCM�|m��Ch��}�v��HI|�;��w|J�C^��%����QjNO��5y�$      �   �  x��WKn,9\W��P����,����G萻�� ���JR���H9g[�Vt�):��^y���{�9��c�Q�N�E,���QRN�-����s�f���vܼ4��Ԧ.}U�!�BY�~P������L�����7ח�<:�%�(S-δ2���·=�7�'Y��l[�������"�\��⇳�ӻ�R�����qb6�,���3�BT�'����Y��\v�_w����oӗ7�� C�w�����{����Š�'J4n��ԝ#����ؽx�=�K�fY�q�$?�C�o�YrҸ�Ni�796E�n�n������<��S���6�|o��n5ds�����q�s���F.��̳zx�eg�8����!�
P_,�1<gâq�^�J[���Y?�z}4�`=Q�������k�O �E�����[����5�bv����l�q�5��F��y��SW�}�S�Mm]"��Z�2(&*�k��^�yXs���i�X��J�*E���hY%Ǣh��.<�� Ѵ�S8,�+���L"}��^!����.���I�p���tۏ.�.�!��qԤ>G�L{!�8� ��;�8�Iy����9v��%�nI��̅�zp[�pP��'e$�>wU�����C�m����o"�;$��<��Jͽ供��p]]� �*�D��%����yO�Ż
�2�~&J�� "�ۻ*�WC��0|�2)_��h>��5��������_#R��g�1Z;��,�E����\k9���W����׬e��e˲�z&$��@����֛Z��0�A���+����l�ku?�bյ4�l ������k�e����� #&� 
�@�����vÞ��t-��d�
h��	�=F��5�ҽ+fZ^��(�����f���L��Ѥ�������%0�J!6�aՊ��5�Q2�2� ��PMu]����c�Ya%Fz��N�XPS��7���η�������g/
}l��K��.A{�ޤ9��`׾����W�=A�~��g�-0Ҿ�%�t]h����v��2M����o�v1��	&���A�L�!^��3i���/8���ŀE\Z�[؛�9��F���`�
՜�8b�k�\�oL���A|���>|��V�L0@����
r���ظ�C@���Ye=۬dg�y����0H-4ws@bu�yD��k�_���Jg�}���<�^m�w��6�/�ռA�1�T�ч}�N;KӋ�7dwlM�g��R>�`��W� #�7�Լ�/Ї��V�D�����2h Pе���i+0`$�M�#��"�S �7��Q�<9H� �86�P���	�Ø�0��{�����
���b��d}̓߰t1���Hl����
]�t�LQӶ�3��
��s���T���*2��� >dq�������)�*�/P�̽���B��7������V;���S[��wB(v�wB�o��C��!x�9�u�h�䈠��HG�z7Ԧ�U�X2��Z�K�� �J/����g�a��b�y�������n���4/H�}잃�>����z}@�O�K�?v=.%�NĀ��C
�M` "D�+��G��EE���0pX�~U���?���� /�O���чv?��}U^��r�6��t���D��}�>�f>0� @B	�P�"9!3a-N��.���?���d����ۄ�K��TI�u��i]F�C�!�Z�0�y=��? ���8      �   �  x��W�rG</��? 3`��璪\�i;��Ĳ��ק�VYtJ���
��5�it7@齥��4N��R�}�[m�<=�y��ZpR�A�s#�)�̸jM�=�mܾ���<�v��ߜۇ��ߟ���_���zw��4?�?����?7a�@�g��ϟS�,:[�ˤ��R�%�,Ũ!�iy��:�% �.�Z�fѨ-�퉊��= )����t��(���$<����^�𱱤����#0�@�K!k��<u�ݎ@���0Z��:!�t��;��K]��tJf����<����	��ɂ�QȱgkS$�������H�<�!b)�(�R�B�֤R�qhEKۊ�& %�h��V�a�f�6{��U� |`$��#	y��wE5RXT#W�)⧲�ʛ��UL!�U)U+�T��{�V��K���w��@��Р�` �	aX.lnާy�L�=4��h�����rގp��WF�#B*".5�H�u��l�wٔk�iNC�RI;�|Nn�a���k`w����'���Q�Ϥ$#"<�����R-$�þ�#��j�:�Ia;��3[_].���*{�b#��:Ai�G[��1�|'#���>3�;��I5C��!��cyv��7��&hLHd��ۑUy$���Z"RB��%_.�;b�y(#�P�}v��R��k��(v��D�Pk�)�����Æ�|E���Kt�P�1J��l�&�uj��_؀�l���%4��%ώ�]'A��b�@$EQ#4�ZA�9d�+��fk+Rw��D�CV�FH<��|>D/�ZGI��}���(RcU���ҭ�9��&�	�'XMfԕ&7��A�a#i5�̤�@�m��2`�*ɪD+|,H^��I��F��4��B�4f���g��iؤoZ�UoxP�7@�ܑmKO�m��f�~p3z��&�6��)������ f�òԵg/؎��vhi����9onn�9J[2��Y�DAC����au���a���#_�ʚ�������B�fi���5k��[<V��s}w��m}����ӗ�C�̾�5�w�QH�6��@B��^RL�z�`��}P�e_���2*�)15f6�c�n���'k�7�[��nБ��#P��0x��������av��*�21�"H,�
��LaOH41�`̶��s��D�$�I�rb/r�#75�vͽ�dT[�=s�svZ�z~��C�?�?ޟ屬�e�]�rU
�%���N���"��       �   .  x���� !߻�p� ������i]L�cOl��2�au4m/����gwm]�`R-b��5!V� �Iozj�c�l�ل��@�3�H��g��3�Y�P{a=�K
N{n�����>��X ��2���'���HO�� �P1�� u�+��>��h�<,�1��}%��a��Z�G<,Z!g�,tHZ�<������<Cؿ"�t����Xf�!D�p{�D���[am�;�)=�S�zԕA�B ��b���"�%�>"���;ӚF�׽L�F�hѩD<5�ߟ�}� ��y�      �      x���K�9�DǊ���_��˛��%��T�9�j�U�� A���٬�qstk��������?V�!�^��=����J�.��\;#�v_�Nn���5�t�u#���<�5~ϥ;k�nq������9�Rw9��f������6s�IO�'Α�p՟�r���l���s���-�R��{��[vy��z[�[u�2����4����y�<��p����I�����O�V{���?��6��<�Y�;�/�[�Bi�fg�YO��'�en����+ę�vg��]Jb�r,��ɯ��m�vȶ�μ�����147�>��m�R�����pdWV�N�t�L�m����~3�������rZs�J3����L_�O��:Ns���~جU�,b���Ǻ���Y�Ƈjsm������pv!�뇿�b��>7pJ��3,�3sv}K���8�O�͉�B�e��G<���#�d�͋���W8)F���;��X)��q�ds#�,o�zog��<���pϜ1��P�e�R���/�0��6NC�4��t�b]l��z����1�����c��ݸi��[?���}�FN9G_\)�*Z&����=ݜK(���q@!�G?=r,V�)D�iq�Ҿ;��9wx ��5pƕc��%��vvD��׌��X�Ţ{�����V�xH��c�P7�< �5�������ݵ�g�;+��x�N����rXy�m�OI��*���4�c���[���\�OZ��=�̗Xn>�����~��~O*ۚ ��;��2&
��[ܱT��lWO�+�ԉp7㙞_5ڗv[�u;OJ8 ~�S¼����o�\K�R09˷���k���}�O�)NG���xH[n/�ǌ�?z&y��-���I�A� �ލu/P���сFb��N�z7G�.�yʵF�Ko�+6�H:��:s
ΗR	"f6vwOv�&^ȇpp���j=���I��:61��k2,�L����q�l	gw���NȮ�����3�X���*��@��Ec���A�q��G�������R{�.>&�G�<x�m#����HN��3G�}���aW7ҭ������׵��.�c}�`2�+��{������]� 3���P�<�κk�@��O��6s��$EB��5e�L��@k{db���|������͛���A�����y�W���� �9�%�S#�%���n�������rM��*q�I�<!���~9��.Ѳ��!!q��;�dgV~1pZ�9(Q�v��n���y���V(]u��X!7f��U{~K�㋻��eIve',~��r��uV|�L�2Z�A|�	�R�"I������C�wⶱP�D�=q��u����8D;�}ew뇙G!�=�d��Wb������l�<�6kO|�7Wɭ�xj�]�u8 r��d�j��s�G
Q'j�$,ڔ���p�'����%jc�*U*�I�/�z^� �O�~��&�U��2P�y`/<���G�~o�z�A��8��UB!�>r2ރ���>yS�O`q�kFb��)N�V������\�N �����@f�q��F�K���j�vژ�?��U�~���A���������k�[�~+<d�7 =�u��-�+�Fc�G�~��SD��/�oH�*s�F�\�^�z��Xr�as�1�V�-S>Q�_���v����X���j��aQ�TM��/��T+Hkx��5�
[eO^���љFf��|;���y~F�害��G����B�	ȏ�
��"����L� �)P����g�d�wɩ=�$ձLk2�D˔�)�}�$S�$�Ic���9�����N��R8H7�Md���Ȣ�xG8b� >[0�4?z���"
���;��<x|��z0n>�L�7.^�<�:�6*ݯ3K!ɖT>�3�^$]�l���0�-�%�[��3��k��\�2f�u��(7��&�x}-X#�,������_�C��lo�.��f:�^�TTP(��Y�]h��H�������@����¢p�1o�;~����������f�9Q���Y��#�S���� i'N�1��'�%X���I��
$�G����ƱXP�x5O".�L|��A�{}��=n�X�Ip-dN�p�u0c���A�����e��)����Q�Hoq��=!@��A�Г�P��U�|3�Ǜ�<11���y;h�*Y��@6�i�y�8���zOL�l !����K!�E_X���y�8��*��w��<	4�K]����:%�9K����Hh*g`�x�9����D�����0�y$<<3N�8|�D� ��,��ݷ��!��kӇPm}�8}���z������ �Dd.�ܐHi��	�s��S)��S��Ђ�M��!�ŕ�	d�����ly(M ��Q����g��k��0�:/������>�R�Q��*-��=�KV�a�Ce�y� 8(_��`�.V��c'N� �z;�GW)l�B1��v6�NO00"x�i^pNl
�S'�٭�s O����v���@K(�j0w�*,��:�*��%�K	.���i�{�1o�|���2Х��^a-풯&b�Lԕ����`�A%����}��\Y}}��F����Dܲf��o����=��]HUL�0vU@[/�R�7���n��g��զ
�˿MF��!�s~�J��[$�� �i�>�Gf���_M���9Mf߆��I�#$RJ���v�n"�M��*�HUh�}��TJ$8��EC�&��*�g˜���|g�ͅ��¾iM����'�D~���AI�&yp�]���ƫ��}l9=��R!�խZ���@,��v'\ָog��*�q�i��N'Lse�D��u�&_�`Dx6�Q���6̌��Rod6�Jt`��0�j�M�6��u�d��e_,��E��0�r*�N�̈́VW���K�-�l:�f%�0_Ƀ�˶�1&� 0H�f�Z&����R��T��Рj��)1��
���E�� �;�d��7�G�_����JB�!���L�M��l�no�{*t�X�<1k%��u(8�[M�rv�����N\Q|=W@n��m�W����r�g�0�s�h!Vyd�sh��XV8��h�jb�Q9E������� �N�M��ہ��Ě�P�r�#���o�@��*4/��#�6��}�J���ʧ��?�$�ڮ���U�ǫ�Mb �۪�����=���0'�,@nR+&K+M���
R���[��ݭ�>��;�X~p�2E����f@<���ˋ'5G"P���c�����eϞ��|��6�����w�D�(+#f���_'�q�!����:�����~J,��@�r��/=<���5�C{5���k��<��l���**Z
z&Y�yӈąA'Á�%y��O:��tD�[���ۊ��  =�]'΃F8j�洛1�"W���Z֧F�#h` �p��º%ۊ�?���di�r	NX`�Qkv�Śr�jӿ`fܵ� #3�H�u@L�� k�!ȴ�ɛ���_�eU+Na�BK�o=�.�.WQG�1�=��J���z,t�Tk#�3D���w��B0=J��=�����W��Ӝ����NI��H�z��a�����QnQ�q	��H���?�+��������ؾ5�>��ǖӺ��1d�!c���i�"��翣��T	\�u��^����G��Ԧ���'� z���7�u�S��<��|�<�*	�9�Ͷ�`���PC�z���W����5��9~��mwO�M��q`�nm֌�^Bu��+I#��xv/��8��"�1��g�v]u���c�
C�	~�<�^M�?p����`��T�jW�4���X���a� �w�/v�d"�DQ��o�Z�fyv��z)�Ur)`Ɖuu'��1��`��!3OW���U���)Vo�-�G5e���w'�P���k���P~�|����}E6�TW�{����Ƨ�J:�Zѭ+IR;??x�y��[m�QpA�k����'HeMa�ā,����|iE}�dqhmk ���iw���rR7�$�A�g��M&����A����;p��p\�<Xn�Q� �  pn_5��@���U>�l�� o�'X���s�28�Ts��r�G��l�n
�8@�U�А��S����<(�7�ud��U�8�5Ұ��B��Ro��ӟ�K~�bp�>�CSм�E�<�T|)kj�Vc���*h��v�9X��g6b�nU..o�����vg׀�n�4�uچ['i�\����d*������̸
��̑�pߒ%��9�*~���v�W�M�g��Mv� xu�+�/ �-�[��9i�H�L��׼śg~���"��v�U�{���Η `��4s��0�a��i�<�r�H�}�cEƑ^������S�&���{o�[xS>m��Q�a��t4�oǪ9��G�#�B"dr��s�D�_�8�<��^��}��B�����8��:LN���2�D}�5�7�`�� ���(v�qgy<����6dۂ?�7�����0������ӛ�\�i%����.�aY���W1O�U�gY<�̯N�3��jL��u��AN#�*��4�Iά6C#Y�/��ҭ�A�x��� �v2l���l>K<��U���WP-��RzI�#��=�ë�x���4|��S̖_C��)@�r�[`�4�^ԣVK��xe����<0� �B^�i��9�v�7��+T�����Z�y��Q���V��{��O��jHV�c�{��Ya����ê�Hb[�u��[�0�x������c$��E˟��Pݣ��U�{�c��)�qDdp����&�'�=�lwP�����r���P���fW�-t,��<>Bʥ�����%'ٙ[��E*���O�ʁ��Vg9$��G���/���5S�]��j,G�8��Ҧ�X�z�ه�l&�1m�	WYu�/U��b�8��4�jJ%rii����4W�������Ӽ��C��_� �Ԣ<��\�N��ČS��{��������Ze���V(d6<��$O4���B ,��N����@X2Ks!DI�]�Q�o����Ij8<qۊ.(�1Zg'��?��K-Y�*�F�� �M��f' GD���p����ڷz��M����?�Xs>$���ڹƍ$�Qg��Jp�S�2��5m��GE��w8U��)Y.R�Z�q��D�����$:TA���u?X����5�J�����&!2��bB5j�)��cDZX�#e�l�7����n��6��VU�����M5�1�IU�_!�k���b�}	54����2���l=�ޏӧ�-��Ud�*4Ĳn����}���#��U���? ]�ǚpI8��X4�� �Xn)|�w�ݲ�Ϝ�����L tU<������*��|g��:�(`E# l��X����T�+�/,WL>�Ys��<ڗ
���<��S�����_��;1� W��$��!�8$��Ɋ������cy������*��	MCޮ�.魳����wp�_�_-#�V�v�DN|�O�Վ�΂�*m4�mC��#Z��k㵏�^X~����XO�����V���ˌ�W�నJ��K�_�/��^��}l[�:'g��$���;MxfM!�^�̂��?E]��NW��Yf�p^��$w��.t4��5̑��j�l��?���4��誱V��0�1^Clu�<����D��ԕ[�H����!,S�>��<ϫ�T��K�b@���N22����+\t��ΰ�	H�S(�uS8#�v��'󧎯e]>?E��_��`s��*�,��F��ʼnE��8��m���X#�?�@�q�~_Sp��a��ߴ�\��I�3xM���ͣ��ouq!,�Um�LH}#͋�����)!2�F[d�
�<���Ĉ���&�}�5�xq���1b�Ț�׎�x&nX����ԅ��r��:B��[�O7C�?�u��߮"�i��XZ�ޤg��ٽd�ؚ�����T�`a�?���ɿj��W�˽.}�O��4j��1u�Ʒ��΀�c�����!�n[]��X5���#^a���jM����j��od{@F�n{�}$��T�UD�_�>���M{��WLP~�U�Ewh�V�$Q�n���T���ҹ!Ti�n}�G&f���{��嚺 ��Օ߭�;:��q�f1���jK�5��Xyx�TU��쀑�t��\����1��m�׸{�w�::�;)IM�ͻ"���k$`��+���a� ��	#ne!��n觕{���U�f��ƭ����U�h�PcJ�/�x����H*M����ʰy����iB�����zR� wW�^ʹ�}�A�8��m��I���������xND����Jg�����q���C#����~u�܋�5A�c��k�c�1�	0�k�[���ͮw$@�������*5�����UR^�_�b��,��+�t=�&���~�5�Z�� �0�G7�oR�Pծ|l�?u�
��.��@t�B�|/G�s�����y��b̨�鑏���QǠ{�U���+�|���	�.��ߐ�� ���4tDé3d��?�.�&q6�I�{s�#�C9�G������t�k��Y}���ŝ��^�5��D��i��KP��������r��//�dN"�5M�� {�	��3��� :X+��y,㐺�� �_/H�x��L{��ntW[���ׅ�c9I��g!��Em���*OCw� T��s~������=�\X����R�S��hV�8����u�G�j�J��r�>!<���KV���o5����-�ݛ��c�驰���N늫�>���n����K��J�[vԺC���D��a�'jڰ8$ť+:�z*x��#Wy����n�����R6�WQ��!��[�����!.(���1�ꍪ�.��GXG7�%ЈK��W���Qp=���"f�]U�gp")�k����c���2���Zs�ww2��2
�AZ)�r�勵^$Y�w���/�,j��g���89L~�$����a�t;�����Q#<U��jX�EΪ��}v��g!���ާ���*����]�~	�;3`	�M��l�]ӏ8MU���i'�o�������;��L��F���=��R9x�Fx�?(��^ې�����\�/�`H��Z�ӭ�$V9�?O�n�H��([��l���ӧ/E�b���uH���t-��<�1<~Y�S]� )�W�-]�����Ӝ�<N�>uI�ާ��o�0��Y#�`ʶ��Hަq:�j�ԕ�Q�(jԫ�u����dD� =�6ĿFL�fAl�Q�ˠ͚����o4�$�HjȈ0J}�ѷ �
��!��W��K�vM�L=,���u��GՐ��}'UU�� ��x����n����#A��C���r���8�Q�e~�Sh���6�Fw���ٕ�ZHD[��g"��;���!��E��T�8b]Ll,�F���3�&��K%��\9"���iv���
���4R��	$�i�� }���@�cM�Cv�ؑ��3];�3���iJ�`�#D{���/��eF��1]��om�Q?0�2��� ��jĬ&X_!�M樯�1/}�����}��O      �   �   x����1�/�9q�Ļ��ϛ�B� V@0�و�W�{���X�r��	�,��5�(U����w�.G��G����$�)��P���04��P�br���K�ţ�*���������S1H�m٤AcKM��;.�O!�?o~3�      �      x���[�lG�����&��_r,��W(膦��~}k�ё*#
<@B��d��mn�l-3s���3�+�=�PC�Z���Ʉ�]�9���ڌ��+��zO�j%��Z�Ɨ��2�~�'-����v����}��������1���1}�_������oo����+aY7��r�W�_e�v�=�km�d�wm�a���W����ܯ�R+3־��J;�<̼\cE��yU��5������\V�l���o��=b�_�{��������\+v_�i]q�v�k���3����ikxѡ��~5��U�_�krr_=��f	��,)X��{�/V�m�>g�ĺ�e��e�7K�r}]W�;҅�١���T<��r9��W*}S����|hW-��;��Sγ}��#JJW]�aY�ٍ�hs�c{�.���?�����د���m�ǿ��������ZγEv׫��X���v���8�����_��b�����n��ʮ�����ו+��tW�!�=K�OC���1\����w�6?ؒw�{�v��K�f2����6�,޻�1�M��˶�=���-�k�:�i�l���>W��M�B�Z_�xj�͕f����oS�m},����(q̖���B� *�P
f�l{�n�L�la��}4��
�]��:f��'�5{v���������X���,�բͿ��\��a�w`Y�Q����������t��>�Tf�nm�G���@��,�'�7��\���V}�DJ��q���<�kYзI����#�Sw����	#"����2���>󭱺]��3��GL�2���v����B�n[%���1���xmI��A�!�R�W^�G���`�Zj�@,>��4D���Ql�{~�5c�>״��j ������6����]������}9�ת�������'�~�_%�g��u@���N+���Kx�b� }n٦�I
q�Fz��p|��v�k��[�8@ЕkE�+�3��ILy�K�g�������w��=���O��>d��F���`S�o}���|ˆo��cmgq � �b�&0D���l
P��l���%M>Ϸ������8�s~�|�:`j�������cQ�G�`��9p��1�\{�d�����9������Am'W��G�0�7�2�vK�S_	D�D�R�J�7�f��Ogw��~���,@�ެ8d�y��/��������j�֝�"u�_�p�⽈@���V1��#�p'D��ӣ�� ��8�Þ,���sրm����#�ٮU�G�6�xS#��k��B�z]O����1y��K�+�f�ok',����H��Z&oS��,�h�^^Ԛf�ʣ/�5��7\�������bX�)�G���	CC�������%���H�>����X!��{�*g�:Mҷ��ղ�D�&�7�U��&Ȕ����Y�#�d��ů���HX�
<�~$���[ l�_+�{g��OK�Wg��]������7T���)%�^a�i�ïZZX_�f¡;4��m�2�^���D�C|]� C��8��f��e��lݨq�ΐk��ˈ0׉���i�C���K�w�6^���3��\m�J�iJ��u�;�LͲ_��dҧ�/�9DT���V�=�>r���
x'D ¥7�j`3�z)^�$(O�ѝ�8Ex㑭N}�I�(s����u�1A��_�s�xu�5S\c����x�.7D&�o���m~ǂ�R5Ր�>��;M�!�g�{]�fZB��6j_C�я�U�\�▩�C��瓜If!�4n��d�'�w?�����'�8��km9���0g������Ѝԑ-`��a���_�
��E��#f�F��n�;8r�	�1dd$��JC�+|�������MFn��ށ�L��/PB9�5`OĠ^�&q�����u�{�=ت<*>�
��ČPE࣢Y)������rZ���XD�-Hr�Eh��zg��a^Ļ�[c�t,�4u�g�������Q�;�I�q�r�� E񩃨�ha��^	ց��ӻX������f'z �2S;k]���J]D�c�Έ����H�2h?�����+��F�F���2����9�L^�M��Y0),�HS 
�ʁL_)u�� Eͽ.����0lI�;D����U늞�|��u#s$��8c�F��E���&%������EJ#�%?)�5�mV��-+-�7��V�3�s���MVDJh��ɽ��:]��$���ڙDV�K��DeWi��N��I[��1�jq��E�Ø�Ժ��,��n�����V�_B�V?���a��t��h��5�76]V:���O\~����!n��� hӣ�7Rq嚁��ۣC�X�V�,U[`K_#;��$y���`�D��Oc������7�a����ޑT>$�A8�i���=Sa	�ױWl�����wa7o�fBƱ|���q�-��DDi���l�١M��m�,��{��m�E��3ς��qw��DS�[�!XhW����ȍ+���+��2��S��TT��[Ws�j�4�������������s�j���	&ZZ���]m����r�J_�	���ǭZܶi%?�_� �C����/�`8��dU���j#����U@�����b�aJ��+`X�s�\{T���V$��|yc��GN�*hv��tF�&������x>c��ҝ8��z�8Y�A�~�}���]tE��b���c[���U�*�9���	B�=���t5�R�{�c�?��qX CB�'��WZ�`���ɏ�^�Эd���yC'�W �X3�;�|�y�AC!�C�,2�4Y�mIa{���p+�"!��?L�+�8����eǕ�A�i�M�՜��g6�b|~ط���~�c^^�9�� �Iec_$�ȟk-�K%��#��_�I#.c@;*�ذW��Cj��o�����mOwE�?�"lK���s�`����U.�Ԏ2�֊?�}`�"��!@Pf\�(%�m(k�f�6�i ?D8��]��U )��|E�H˻"I�CrKQ����+�7dY!�2e�?<�O��5��! ��}�x5rt�p_s��I�l V���vQ!�L���������h��7�Ur�e�� 2y�����D���	k�a)�)��~(����v���`cX���./��˨���C6�my�a7�8�����"&�6��G呖�'4 �� t��[��۔id��:�]|���ia�'3�PN$�Ⱦ��/�? �˒�F��Yo��L���V��l^��O����Ž]�|��� �:��}���l��Ĥe���] ��a��{��r��ú|�fn\RyV�Q;4q�]���ݠ>2�f��Ϣ[R�Y ��H�o����%>$���zv�OEq�n"A���L>��8��[L��u�=|(ר��Q��S�	M�&���:����e�ة�VxX�2g�q�L�Ma��+���]0�mq�#�u���w���Fbx����C&�ZV�K���=�%'�Ϝ�}an��S� ��/�X�7^��n&ǹ@!�h�<3�E����ZWE9Q%*�륺y�U?A�x7��w������`�P�CnKE]ysq�&Q�cl����|��7�~�b1��j��&UC��"�*�TO�0�(�8�Ӟ��F�e�b	By0��֯Z|*���~[K-�z��#��ȅ@���K�1�I�@�6�Q�;�I�sI�j ��-M����Z�AOejn5�w�o%D��?6�㎶q:_��r���h(z�:$~������ҭ{,��]u�خWM
ş-^���p��D�la���1.��ZE�lc��>���n�� :�+c���
ڙ��h(ɔ��n�[���E�ݞNc�)�3�:�HL2K�:)��~NJUMp��E�e���s�ɉ�$�_{��;&��i��L"��Iw'x�s��w`�;0~�kxR-k�Y��EQ[�~P~(*�����~���UicDd0|S��QC}N3�Ng�-4���ɾ�>�mm5��	y�(1�k;��f�QΊ[m{�*^0z �*"�k:��XnW��o�l��!X�7�aO�kt    ��v�ޅ�ѕ�G�G��S��Z�ʈ���\ߩ것S%V���sd<��y�P�,Uc[�</f���mSi�g�p�W��(�"�#�� �,��k@F��舗*L6���٤���ER'U!b}���w��T��R?,�[�&j^6�3��?E����nuƟ�o�vTb	h�zM�J���*q��a��9�CK��힟�R+�Cl�MF��}�[�`8�T����n}���n���h���"��+w��"�Ȯ�����-��Ϫ�	�rg����tءW����v��&��c6��ğ�0f��5�F˓�=i-��[��ˇ<��ZM��H��ֻ��ɘ\�Q�Л�V�n����0���ăb �Q9h[���%�ۇ���2A5�{p��~�L�E���:?�%�+��2}%D�u��8�TC�Ϙ��_�C5m�e�Ƀ_X#N�U���Y�G�g��X�Y��qϭ�: h����_"�^��Q��4��Hxf[Ixs�@7~�[�=�Q������v�_T��9潒�m�/�
�rR<�us/ՇA�����B�z�7s�{N�����(�餛���tω���r$�'R*d%4��Z#��Gf�z�V�	���\�@�q�w��L*?r��
�d\ܪ�X�ߏ��*?K"�.O�؃��	c�y�e�f����13]�#6�n��m�|�_��&z�^xE���_�dCj,U�t;��M~'��Ɏ���9�zc��K�y3#e�SΕ4�B|5U�U�B��v.�,�3-1����4X��\�[#�r�E��Ȯ�cB�v8��Q/X�5j>I\��3��afW᎕љ{�è�H����όU�FՓr�a!c4*�z��b��f�-.�t����H��K�����i�y)��8��_���1���2�:d�&sX�!e�����m)U���Nށi��B�EsWѱAY@Nw�{��# � ⃁��k�@gC��
�	ݨ�I�C��Ə� #��(O��m�i�ȂfUb��>�`��s�/s�W� =����I����Y�%H�xM�LA]N,v:��=XYL5�� _Y�.a�#���7ԣ��e����� %sQ���>��C �v�(��k,�TF_�U�tY=���b��ۥ{Q���ޕa*
sA��'܍��v �;^���������G�ǻV�eFߺ�'0��!!2��0��b�?�P��C�=�(��z~��= �ӷ�k������'����x�������Ƭ��2$5������t�ð5�_g�x|�������[I����P��P�3�=Rq��%�A��v#2�7�Ȩ#����y��k&�fX�O�Qb��aa�3�)���a?��=����n�>\x=��gL_;'5�r�!EMt)x�I��,O��,70�3RH?��7�B\%Ir��~�d�Z�e�Y��>Y��W"��w5�J�����p�5%~`�d^&~�?��g�ω�۳ v?g��d�NU�5���ӁDkv?<�uΛo~�4C�E��,W�Tw��@���Iܾd��8;�j��x(w�He��!���4Dٷ,��T�ip\�'d)��	g�����V��X���f�kP{ۢ1FWև��+,�$��� �m>=��\W�����Ѿ'�>��@�Ԃ���		������Ҟ�]��A�t�7�l>��?��l�Sk��	2�λ�v�����.�bjŵ��y�b�.��1]�+��+tݹ�o�`�9��|p�<��|��!���Qj�va^B?�A��J1�w�{6�W��P��̣��������!���ٽYI�1�ۜ�'O�[�[�wm�`����5��G����/<?3�;֟UE>`���^]����&�ȹF�&C�>`�z���Y��f}p��ݮ�Ň}w���������8bM;��j���a]�|L1�y'�c$��_��6�}�k)чz�I`�2-^���*5�N1�Rw_����aI��r���=��aT<,�	w��5��}����!J���B������kXP��

���y�~��ϛ�U�H��"Z��R���TKG��~E�]���#Q�
�����0Y�[O�>�P��A}o�ț��U{4A���9ᑠ�����{<���,7Y���z���jZ"� 螇��"�;;�f��a�s�����(�s���͒sH'O0�R`7�Y^�@?��р�i}�y��n������WN��I ��L�{B�9��%a����K����uF� S�X��+O���Ĺ�:��쬸�ۃ\~s�ǃ�K�<�Ƞ"de�0�Np���n?�O�Қg��V�*#�ݫ��B:�_p� s��ԃ�@"|wc�^B��Q6O}���Z�޿�v]�R��y˻lu��g�R�����Q�ܕf�I؇�o@"N_xt$t�hmjЙoR�FM����b�ﲏ������ˢ����<��/�G�]Q�� �ɍ�E��މp�������ڸ܀]� �M���/[�ęx��pO��B���ySW�6��C��_94}p�]8�'�xB�:�_T���%��5�U9�_-�g��UM�na+U��]е���k$�+�ɧ�CM�����J*:�p��X!�����%M.N�E(	�C������ޝ�[��E�;>r(p4%��4����^K,��3&񁱞B�(^���g;
^�!��2# �%*��w��6����F��'o�Ҝ�}ߜ��v�S�i?�t��-��G��c#�pv����s�	������Y$�7䶢��Hؐ���9�2r/��f��V�}�Z>�F���*e���}w�p��.�Y�˾���| ]�.���CH@��a}�s�xB\�����"q��� Uԙ�?���=���?�����A��>��w c
������5�pV"��ԫ�G�X�ς �ϰ&�L-��!�"���>����(�����E �rof!Fԥ�I����Ś��`�$H�9�;?W���t����X�F�Y�l�C]m<���G2��I.�^ex*��ŷ������=�pƦV	i+�W�F�8QX���^�o�q�A2�7b~�B��CE�`�#B�6"�Ln��p����++D��S_غ��e�u��K �&auA> ���C���J�լf	��L�1e�uc�}�]*�播'^�^�uvO��Hw0VI3],��a�����b�_��r�5d��晎��d�'}���>�wW]kua�D��BЕ�!X�aW��G'���5�uD���y�ͫd�HZE�{x$�z�9�FS��ğK�l���UUr�-} �y^��6�ߖ�x[��̤�J`:��c9���W�"��7�uY曾"�xm+���WdG+N�gN;mY˯��3>h�[3�{�?>�Kr�|�VRy$��i5y3K�cT�͙ӟ�g{?�w��R�K��}�܊Bo���+]x��<��<�e�Y�����b�wUW/D�yﺚR���:N��Ɵ�w? ��P��yw��Ck��ަnQ��T0&DY��/f��=�����F7��x�̿Q�sxP�tUE�/Ua?Y��4�A���O�hh�.��(���ߢ=���ߕ8r���ޱd��>D������$]�,�X»ڥY��Uo�ʶ�����{�������<�b�Q�+���R�Ww!Qu��E�L���g��φ��i��)R�륬.�u5���a@��1��!�t��?��t3�{RКGx�^�g-�O�+��p��&mq-ç����8?/��3w'H�'_�@ �u���vy
tKw%��b2��A�>[�G֒o�(����7�
�3��j��E�}��0���xT���z��L<���Q��ZU�!���]l$?:�Uf�(��/J���p�%F=��ַ؂5}�ܧ��F��)$����:>3��޲�r�3��k��\�waFG:�F%tgBD/��Q��{4�VU$�s������u�Jb���8.�9���AG��i�gf�ҌA��Gɯw
h�G�W]v��,��9�=K��H��D`�+��nP�=��8�����7�O� ����j�N��
>�`x��k!���vn�Enn��쑺@ �  N������ȳp<�B�>p=[A�Qߝ���8Cnr[��eH$6��^�#���V{�=�Kk|���;��MC�Y]%8��{��k͇�N>��̯�IPB(�O�H�3�����Հ��3�4�<������e�iQ���Wt�:r����EY�\���Jwxv�� ��F1��Xϻ�TA`QϢ���n���, F_��Df�g��z�ϫu�&�A.����:4�D�t���æ�$C���S��px	�G�6ߊ1�ʇ�oJ�
7?¼rU���m�e�����m�����'����R{�m�Γlġ�iX� �����FBj�/+݅8�릨/�Z��%���rvL�Tw�f�d(�����;�Xz�y�M�졮D���<�
�vO���T�8+Z~4���@�X���ۿ��c�H<�DT�`����Q�����#���Z�y���y��n?���h��)�)�x֍�`�?�q�ub�ɯ�%�IX���UQ>���)I�*�rt}�?T�EQ�p;W������;���s[ԠC�zC����ҕ'?��ު�kZ��?�a�z�SP�<�%",Q�#�,�|@j�=O���.k~�#�x��,�I`�R@�ۙ���~Tt�̧��t(�B��|��YC�=������V��j�Ͼ�뾛2�}~W��Wl8o�^�Ї��J�e7��ǟN}p��߃���L�o[�E����-~�Q�ۃ@D�������6O	{�~�/�y{d�-x:_�
�Ԡ����j1�3˂��$�Ӣ�)�SF�8����4��3u����M5�U����u�Rͯ�ʈw����5Cj��C����[�g��JRM��R��Kʯ���A���/Y�eư�/�b1y�t�<L4A���g����s���=��n�KnQUؕec����=��k�1�q�M�����S�bL����YK�� J1�nI�T�"��1J�g���J�ެ��:|P_�m����x���rpYCv;�ш����ꩧ{"��N�ǡ���D�N��KZ+1��?pO����u�uyd�&��t����(U}�#Ig�M|�������kd���V%��5ӍH���Fj#�5;�w��-,P���\�=��Q�����������׿�$���      �   s   x���
�0 �s�%���5[ۛ��Y𠗘��M�i���{uԨʌ!�\�Q��Ue-V4��i�&p���*�b~Z?�k�>ө�z]�B� %����p��K9�9�0��w�����      �      x������ � �      �   �  x���Kr4!�׮�0�K �2���G�O���8v5R*3%�f���J�7ԥ7�}[�WW*Ӗ��7w�k�$�j�E�.m�V'���th����Y!�0ιa���Y��_啷��MB�M�Y���S���/}�j���S:�JԠ�I�Ư���N�K�wZ�a��C5�`g��o�Y4���|w��%%��ZZ�N顕yڐ�����8=��gb_�{���o9�*/���c����D��)//�Fdh�x�����ٱl�:k�G&���d�dI�H�k��N�;�i��6a�ħ�m��ƛ�[��WGڜi���H�3K㤹�IZ�o�H9	kf�Tz�2�k�ц��b��B��ja�UZ�RR׵Ǳ����M�
�AM� �H��ZN��ɾ�*{�I��H�}�� ������ى���������c��eGM�V�#V�]�#��$�����8ש9/��Z@%����4@X,�1��<�o�}����O ���D�Yf6=���!-���j?���G��щ�ܙx����z�a�T��"������D����354k�B�E�V=�ob_n���s��s	6/��M����
�xI�Âg.��3E�v�Tꞕx����*�֨9L#^��I�y����:l��n* ��-�ٚ���m�6�!T�W��tSCQK�fq�X�z�W��bޜT-�}';�$+�[%~�Z��hԢ��Ü��0�J�mp��I�Q�a�M(S����p'��p�[�ƾ�-xBA�v�l�"�Ӧ�tK���C�*x�xi�� �hu��SQ=�*��ylWj�RC;��9H�q��ڞ���YHW`ȳiga�E��k�;�d�t�ˀN='��HO�rѿ,�����#A��N���^������M���<F�B&	(�K�5��V��'��~̇,t/��{�>2ۧ<�j;}�[��< F�2�9�ԚD{�b��m��Iڧ���ڕ@e����u�}�h�qDV���,0�V�#������۾�C�[Ji ���j������4�����X�A��y�@ UX�6� �J���Aح�Mx���1�B�Y.>��3�O���
��5�JV�́�����~��Y�R��7�	��Qb?o���D�M+~2�dcKQ� �f6�⯴y���$[��ZB�$6�ϴAW�g�_�Z<fh֕��S�<�}����m�M/�d�Ȣ�������~{I�8�p'���rF�Ȣ�FT�M�8cpL(�F�q�zrEȈ�Q쑿�d���"a��ڡpN�lMk��gb��8k�ؗd�^=(���zӖWL�ܡds_���юʂ�������'C�pV��$���uD�r�{_k�S*�����O�d'܈��iw����x_�qu��\����7!��y���:o�oߎ^+4��4w��m�������W��J�M��r?��I�[1�65͓�n�X��[��F/Z��p�D�s.�aF�pTQؒ��'v�S�^pLTsz;c�zYX
\h3��z�a��^���`7��˧wN��_�nk��l	�}���Fz����_N�)G}�v�OB�"�-��q:���hm��ޜlO�p�]c�u���ܲf���a������A,�b��V��w������a=��.V��h����}��
%X����$^���Pm�w����i���x��9g�a��P�V���O��q����% X~�8�0�r,�m-�	=�+\��g���)�
����#g�W����ɰuůN��nڮ����Vt}�����S��m���d�֪_��p+fW�P��y�t�nw�գ~�R.�afq���H
Q�|2=���'�s�6@��d�J(�ڵ��ǽ��z&r���9}ym�O� ς��b���j�߫�I�㿵h	�*=[�0���|ι��=0�����_RQh�'�e�m-z�z���g��Q�؞��`k���}��PBa�y�.-��*2*��l�=�� I	���
����.�����7.�����4{�����B�=R�X�t�7M�ߊ'���x%l�Z|j�{'�)w�7ݦ[mZ��iF�/���\$�n�9����G�Pr<�ހpy�BA�޴hc�c��V|���\$�匽�|�y��\����ͭ�i�X/z>��q6\n��y�}D*��r�Q��c��Ć�P����Uj}
�o߬:)[h��c�g��0%�87YHyd-��g0�1�L�ynr%�������4�d�Ɏ��0Q�-������u���|_��%|
��{:�a�6�K2em
�6��<S�7.$^W�H��ֳO��m�oR�tPa9�XE1|4x���6�֑2Cp�*Z����>��}��M=����b�k�#�'ܗ���g�8�kH� �x���U���0A�M�e�?��z>�h K���竏s��H{��}9������a�O�]�I^k����LJ��'���M��t+>�}:#�����ק%��Ib$󌳥��|!}�!�1k]O�q��:>��7*�K|;�~��;8_�ث�h#�6��r��{�=V��i��ϣ�7�cK#�n�ul��99��@��gʔ߿�
훶5��A�~��ƙ6mz��)2omi���}�/���ċv������'k%����Ł�d�~�H a�ZM�x�����א�2��k��MP�B}��#�	�;��'�����:���*5$@��}�b}�}�t�!K��7���_b� �w�BA��.b���T_�}����z�b`���'mH$�s��;��I�t	��su|/�(qՓ|���� ��4��\Ɇϐ�����hu�ˣ��0���v4����I���B�S}�B�ۜ�~����y�$��;~s&�nI�p�'�ޱ.��;!�6�5��CM������ӻ�� <���W��W�=���#�|�Ι�V��W�:�h�\Xp�NPG��������i�-���$wuu�Mq����Y�XKHFHI}V�ov0��2�@�Wۣn�oov���T�r@��<>Z��h��9�N��nH�~��×)�4���.~7�xgH�����_Ow�.��m�gjE�^�E{����n|����i�У%��z�}���~x0�nǝ��=v�عk�7�������ۄ�Ur>
�π�U��yD�[��(<�F�1��sY�qn�>��)s`�/�Uٳ���*#���aj��+�1����w:�d�<d��[�N�>�Poч�'�K+��UR4�B�ޱ��^	��n���z���zvM��
��ޒhRU�<�Ғ�iOA���&E��H�k=�w���6��*�r�j����f���{��. �
�{=1�/N'ͿS��kmǳ��1�t^��}��M�*��}l�w��5�����c�ӡ9�����Bk�)m�M�_+y|���%(�L싕gӧ|�g��4�E}sb�{��������뒈N��v<�kUﭐ�(�5���昨~�+|.����|wR��	�7�����B���9��_���	"6������9��Im�I_�7�ܒ7���U����Q�G��P�5���Q�a��d�U��n��>ﭯy����������&V=2@\H�|]K�[m�'���i�e�u0���k���_k��3����M
�Q�f�]�7�5����H�����RH�����xѩ�Ͷ�� },����7|����>�!Þ�gݮ���@3�c���B���� ݢ@�Qki�ӝ����g�X/	�J�Lxݯ>�۬�mm��9>�Kh���ͪ���!�IY��^��>�b����Bsx��#����'|U�B�{����|ħ�4�9����������θy�      �     x��W�n�\��
/g@��}?vd$9�,)�%�H��}��48�z��蕜l�H��.�ˈ�����zHY2�$�-�p8�]}ΩSU7�!y�mQ�Mu�]%�\�|��Zv7MSO{�x/ٽq3�ơ�5�=�Z�/��i��Ƕ�3c��rᘎ���((�
Z����8�8��6D\yR�D��Jɽ5���e�{L��=����=JC�R�A��iڵ^��8l���JL	i�\��W2ˎ�^)��Ain�m|�1K���pӕ�c�K����������S_���g��.���q�����|�U���ًkH�9�J3���V�E��Ư-
R16�*�Y��y��pE�K�dd�Ӕ�A�=K�6���}0�oq#�F�?m�x��iE=��/\ˡ�.���k�"G'���O6^:P.zNQ)���^v?�O�����~pq�>yV�Sj�?��t L��L�X�q�!
�xaؑq�\+�� 4I�ܹ�+@����x��)"����A�Ki��@論��ݟ�-��և�}�+i��=?�a���0#�^��R�X� ��:n\K���2ݡTgx�b�A��cgC�Ϳ��<�q���_���%����E:^�6�c����Y�����=V�K&3����tI&ՂZ��F��S�+���^e*�}����˿<H��ݧ�����偮���� �P��{��SJ���p%�];���j��.�r\Ո�ԗ�Ґ(DW4n@fL�yD�S���=_*+�x���2��I&����"�i���aY�.q������;t�Ix����.a'\r �㴥a��ޝ�<MR`�q�o�T-�$��`����`V�B	����&�ΥD������	���Q'�V��w��{x=.�s:��ިP��5Y��*��I������5Gj���	�PG���%��/��%Ǻ�.�s���%#{؟���~X6�
�&"��/DW�`��D�*����xt�Ǔ�'�?
��Y��S�X'�y�@*1��Ԡ��AQ_��o�1��)&b�*�m@����.$,�Ʒ��B(5�)�m	�^��	�])](��h,��2�T�,+Ͷ�5���o�t�t����c��
^��J�Xb-o�"8W}���I;^U��x)�%626�s�r�t���l�������GW͟]KQ{��ӯK�Z�dQ"X�67R��UM(�*T0�Q�'h ��z[%͇�b��8�M��B.�w]��������/����u�<pN�)��m&�HNN��6:�U�>w�� ���6��y�F�Q�H���c5�L�iz�A�z�p�S?$D��M����CYR�-�9��sk�u�ZY)�����m�2��C����-�؈>���t��^�ɇ�eM���MC+̫�1�3D�`p`���bn��v����x#`Ĳ�hcA����&����&����lO�!u{vz\ȱ�&F�F|d��[[e�W���K@$�:t�t<*�,āΐȁH�RDČ~?]���گ>x�&%&vȯ���-�R��Ô��J�&��r'� ��T@B��|���6󛺉��k��p$[���AA��H�\!�"��}gU� ¾\�����j	��]2��t;^ ��BB<�f��mD⧩�g������hd�H�C#�s�6�Tl �5C�*
�$,�>.�l؝��r��������X�O�	b��}v]Oۺ��P��m�M8� ,�4���o�r�pv[X�q��0�
����!'dز�����I��+���S.٣��MyxS6ǔ�ۚ��͸}���&�I\�B��!"�����P0.�����BW��em��Q��ڌӞ�$�C�����o����xP.h#F�<��J�2:�0,�v�<@�8�>]c��d�^^���T��l��2=�u�T�����U��˛M�!�0�6V�8Z�b�!cH%*VpF�={�?c��s{�|�釧���p�pR<$��|h��^��X��Wg'��8D
&��U0߂[�U j�ED���h7�{�������j�}m�Ҏ���j����C>={�H�u�L$���H��+������gm�4�ܹ2�      �   �  x���I�#�E��\x�B����P����p��r:�8�����,ㅺ��J	�jy���WF��8w�{C�7����B������O�e�XO�g.Z�[)��]w�����vR�5Q墧3�bt�iϲVnW?���Z!�mw�%0~oe�Q�Ȓ>Lb�˜J�m&�kطi�R��|���W��A��0tqe����UE>]�X�i�
s����}ݜS��]�(w���H�+��s�=-���3J���A���c��Fz���3�+�� g�5q'��z���V_�)c�w�D� �]��S8i\��r���&q��B�GmN+�0�}�)�.J�>'���0�c�w=ɧ���ɵ|:���-k�Q'�	�J�W�~O�U��0Ց�J%�1�)��<���|�ٜbz�;uV�����e�{����렬Q;f5,9�r�9�=��{�R�T�$e��^�.l�;���f'�^w��2O
��q��`T�i��Pv�bi���]���߾����#B�=�sWS�r����k�l��5ߵ���:w��WۖG�c�4>��yPb�V�[*���n��li��rj~3N�N�@Gym	�e�C�> {�˜K���E
oX,PA!�dI�l���p-X'��^_#�(M�b�wZV�����ī�t�?'�>�԰_>Ɩ�Qt'��zA>Щ6H�K�����p�,1�� �/��o�o1"�;�9�j���}�s��+��R�$u�0�`G�����Q�S��ۆ�}��2ȕT�;��ߥW�hq�pJހ����>n���QJ������,s�<P�X�dw���ҙ<�+��.�=�Xq����oT�y�	iPQ�k0�}���Z�0a:�Y��+��c��m���Is�$�-}���=`K�j3A\?����lk�o�\�c&��Ja��_�K�e��%���E�x�f�f>��(b�E��W�LW11�����{��x٘�`L->8��H�yr�?9<SL`87����X���G8���Ü&��B��Oo���r��e��ιJ.������j"%��F���fod�;(��9B�jr�H��2n��V�}���ٖPrzp|>m>����Ep@ɈpF{���e
8$����4Q%l��ғ��[ړK��M�hT�=?���J0[��G��H-&�߹��5�WY!�t�O#J�풖Z�żr�?=�A1�}��9�r�=�D�޹���!���IZb�vP���ٷ�h�>"���6���~~��<��x���b/��-;�|���	�o4�3֛b%�A�E�����F.v)�7ulO��<����u�TҊ퍙Ý[T�[$�T)c�"��{�t�S|Ō/!aP��V~o^�]:��WY�3�z$z��lZ�H��/��5^CJ?���S�X)�|�[ɢČu��I��wSa&1#��4[�xK�OX���;T��%�@%[�0Ua��l{�P���9$�2	aB��91b���]v%:�Γ�Q=�4x
�0@׸�2<�;;�㣹k����!%��\��oy=���}3��+�*��(���*�J��z�m�Gp�����S�ﵽc��+<l5���^]�<5�a�j���Ji.��Μ�npб�[MK
q�����Cz}���%�>��/�����A;�Mfŀ~�p�qL��3�W�F�����9.��[�+EO��ud\�i�5�f#�$ߙ�4���A��=.t��p d�����?fd:�/j�}:�eS"�a��.�O���5��Ŷi"�2����2��t�<Lq�^����Iy��"A,�r~��vޯfn�`�F;9y;2��vO�8c����l��G�aFͶ�}�E2�_�7�4��p��>ֽ����}�I/���;G�j��q��P��@�b�}Ծ��˴_�9$54�1Z������M��^NU��]d��l��,i���Z���%0	JwE륈F��x�ڙ�+;��#b#�Wo��܉�ҍ��7���.�5�J7I��j-2qdb�5��8�m�0��גt��#8(1͊��&�k�t���*&��2�
ZV;#󩘈Y�, >~)bZ貇.~�(A�
m5<`e��4_1}Ѩ�r�&k�(�
�d��t(Ww�fe�b��C.+�A���e҃��.�{ɾ��ZåFvE��dbE�"=�[u4����S���ER4Q]*�2��J�>��[�O�\��Z� �F�M3�J7U�����9��3 WG>�=�ldڞ#��\h�,����h�Q�k�cI�3�b=�F�缃�+ω9���;W4b�xK�O\�muV�#��>������kƨ�="0ȷ	J�\l���^��4��U@��l���aV�%�[���;(ڠ`u��`�y0�ڝùN�Z�ӆ�L�m�%���:�K�R��3��cφO�XhG�uQ�H��D#9����o�}7JK��l8���g�:�,�B�3E��X�߽��%mg� ��y�������\�����Ҳm9!���GeF3�:|�d���|\@���'�X��;�&_�Yap�O�����!?�=b{M�+
|O��N�V"�Dr�b&w���E��0%v(4�#�m�%Ɍ�X�Ih�z�I�������,6����UH�bz��T�������w8����>�v��7�o8�D���t��:J0#�O��>�t��w�8pT�g����80�!Z�ے�9�#b�pS��A�=7?��
"Ƥ��hL������ܒ=m�qlbX��X�����yhez�kϘ���1��G{��<����K��"H��LK��K+s��믟.O�v���Mk
�a((�:�n��*K���\�+J��<����T�C0("P����X�)��m6'�l���:e�q��0�Esz}Zg;��dx���31���V')���<π�����v��k���6������ss�#H/�6��-�7�KԵ��к;�Iש?��г�:�����������J����Q���9�h�KD@���#t�V�ާ���nÒag��z6"@s|�xn�b�ң�m�K�!#��
�
�	~�f֡=��Z�3����� ��/�l{q�����c.W��}2c�)��E�"�"��2��p+P_o�Z�]$��>Й�/�,�3q�
�C�DU\~��qC=Ŵ�4��Iy5gE�o�u@��H�4&�����kn��龜��Nr�c>q��TF�M*{�RY&-��r���=�=�UM���ԎJ���G3�`��\��N<ش&����˂��v$!ם��T��}�������      �   p  x���K�$9D�w�@J$/1'荾�?�<�4ً"���D"p)�hf閣�֬1H�,�|��|Ֆ�zܵ��=t)H�!Ϻ��q���-��c
���[cKq��n���O���@H��$!z��*c'i�n���g%���gJ%=+'��[�'� �r�����JӢi>#��R=h�D�
��M�����7	��ϟ����TĪ{h�{��{�y���E����~�q���I-�;��.�$Kc�8]�3|�}��<�$�a�Z�l�J��wy����np��{S�{����	i��y'�\���Eeֺ�:+��4"�ZJ��kyV��W���a�g�������z�{�R��{�q�}�,���Q�E�]�ډ&�>-o;����[�0Z�������W��CJ4����2aJ��TT�p�b���ϒXֳv1�3B�T�O�{��O)*3�S˪'K	�e/@�[S2̦�����-����L��G�K�Y��t�M_�d��)�K_�������B���x��6���<���|;��U�=Op�s�/����sN;�����w�Gd�Q�ͅA���5�����8��,��y<*������V��
�t� v�	c��bVAY��A��}���o Q�@������KI�:Հh.�tƄR�1�\�{#�&���/ ����۪)m�}3�w�7z/�M�{�~�+x�{ ���K�ˀ}2[#Y�Yr�5�$ŤBB%���0�`����6e�d��$�\n���ߚG8������r?c�f��>+ܖ����
G�z5@��6t�'��G�͢����i�f�:%�zl�4����z�?~߷4����sG�-q)�����C�7q0��3�	�`e��7�A������;zv�';�ڹ�T�ps�K+�f�~�ٱ��!V�Kq�`���d��,C!ܲ�2����&f��OzJ�'�5��F�)0�Y�^ 5�k�̝l4��'���lt(�K)�sU�Y�x���!��	� ǅ�&�b��[�9�A?	��ҤM�L�P6�k��漵�a�a�	�GH�2�&�A�4�
X�M��$��2e1@e,��`p��g�^�2<2OE��(H2�����Q��V���Q����8���d&���Pۈ�ܾ�����-�|H�輽��Fo9��'g�9M���8$3��L�ٖ��s/�/s��-p�Fպ������<ƫ!+TJ{�T �c1��=e���6�o�����0þ��I=�,x��X[ݑ��2o=�p3.�5e8wY5����-�,w��T��C��78�h��}�k���:�����C�,}�(�"p���>�-	��b`��=�_���Mf�]��zG�`�0�՗��l��(Ӷ������d��jJ��n���4�9-��(/�z��B���$��xZeɈסq���LY+��������e2�P��ȣ��"���5�A��#��U����*�y�~U's�&v���0��
��OŮh�7��}����䎩�q�?��Nۯ��xuযU�L`'�~ Ǳ����d.Ǽ�69�`@����L�j	xr�σ[�z/���(SgÔ!~�	m�]�P��Uf��n%���=	٧��G`s ��Td�a�����1���/TB=P|�)���� ��K_و�0d:XG�_b��^��:� �������yl���k�F��nG����^��CƏ���M�0˹c�,�c��\����u�b���񄝭��&L�Ƒ?ӎk�c*{C���ԉ��X"X�
����X�5����R��V�ʤ$�sO��:ƾ���3�"}#���?z�Z�,|U`mְyg��� l�dpX@J�������01�r�Au�
�q*��mn�Q~�?N��
�Y��p//�k�a�w<^ql�:G������l"�ٰ�,�n����[S:�nؿ�X�+�O��l� d.ߓ�-�|�A�Y�ٺ��sJ좶��c0mr)X
�2�qC����|h^�{�e7�;�eW5Y�:���Vg-D��+����WB%V,��qH_1ϳ�g@ӿ�!�	̣x���&�{ȸ?i뵕������3��/M��d�e�8���@��+��uRD���1a"��1V�OB�2�v�[$!��d7sܠ�5��/�ג��_���?^
�.      �   ^	  x���Mn]�����"��$�ͦ֒	GAd����z��8l��evWWU�-���=T+1�7Õ�j���h���9������-�צ!G�c�q��c��_�����z$I)��T�"�����k�����;��L��~r-�?rZ����t�Asq`z+�lMK���a���+���*�)����W������z�%���Y����5�[-�s���(#��JО'$�z�ig��>3�
�n�����jQ�u�aÿ��afɧ�69��C{]s�2��15���Ϻ��,ZϢƕV�UrNm��?����Y�<O�N��.kw��!I���B�tQ+d�*ժ���f���|�ݲO)a�@�������zx��Jgzh�%Ēg�c��aZ�0��x���
�y��y�e[u�9r�G���j����H������F�9L�5W	�t_
��'���ϊ�)�ɳk_35*����f�j{���M�,[��Co���VוsѲڣ��K��v4POh�����2���������0;jh�	�z��Fs�K�)��� a����ϳv�ߪ�|���9�\�ލ5���[��Ġ�xxI{*nv��3/���:<�G�>�9�̶�ϡ�AcΡ��^�E�н?�����P42Î��}�� P����0��3:����c��j�zvO��a�����7-DyW4���T�д��4$�Z�:�;�}]�G@��`�J[J�c��(���n3��56�w$��F�t��$a���n|sۛ��i�AP4�#�9�j���c(0-��#3=2\0�lNJ%���.D/�y�h`t�ȧ�x)�p��6Ѭ�E;F�����ޯQ�kk���Xg��3��FP��_xѮBG�wE�:(	�Bh��ā5�c|�̸���3����0%LF�_ԣx�`'&�ɣ@��K��/��!>\���*�����m(4�A_:Eî%JԸQk?��۾��3R��
�ƌ�b߽ٟL�̦ Ȗ3��J�0�^W�"!���S*��`k�e��Щ&�'��a
�9�Q��a�D��rd��P��s<J��Ŕ���Ln���$ύ�v�9L��4(�ܲ_�${,������a�s���8QKy4*� ��v���?���`��:<_ֶs�����u�э��:*��ݸ�(L�_}�]n��`�G�3'L+roӡ �ݰ��r}�S��z�BK'ឳE�Wi��O�F6�U��v�p�\]q�7�o��'�ۡغe�z�3���lt��{~������\wnڞ�e&o�S��o��n67�T �T�g+�yR�D���rS���|O˝�Lw�B_���:I�s���^�O��ڑ UV,|�{�i�TB�3˭��ŮP`���5�큡L�&��?�$܂ʉl/�I �~s'�8�����F@�Y8��o�xL������x�b�<R�����;0)�wO�w	���j�T�\��Ki[[�)&��&6f�K<���q�@��ܼ�I�E�7!�r%=�a`B��a� �>xH)�,���QP�X�h���s�%�����MG�Ny�����U�}�.Lz�����I�� $��}L"�	y���HK��ʍ�F�j�2$�Dc�Ĕ�/��70e��h|���ruT����o�a��-6�d�z��I�yb�F��0S�bbQvC����-����vÕ�B���6v�=��s�xC��6��z�>�w0��)Bƈ#ٗ�'ur�v�1��I6(��7������ďGS�sݤ�'�����ԫWE���nP6����P��
��Dq�@E��lnq|�71�f}{A�RNOӑ��eL�Ƌk�;�UO��_D�Υ�@����?GNd����1�
�ʨ[fZط�����=��*�5������T0Y���]y	���Q�e����C����o�5υ����F䮥�Q_ι�Ί�����[�ה_JJīg�[b�>t�s�.�F־Kub_���=4�\��K���h{�T�POd�7Ǖ�0��2�7��1}�轛�T}�-C6񑙹^����BˎD�޿j��E��BF���L�����9j5r��*+�錕����z��5��ĸU����l6���k���k#�p]���X��T�1���ER)���8��Ĉ�0D��YB9�p E�_\`����ݴ��ȼx�3�%������p����֎��UD�����>�b{�u�I���ק��D>=#;�U������5;,QV��nT'��v����}v=���	�⛺���\^�D�����m�6���V��Kʿ:�ohE��TP<���k76��3W��}ٹ�RuB�_� -�
��ܚ?�'
q���)Q��o�>�)�T����hQ�z_�}y>����
�      �   y  x��V���0;���76`�����q�%<��r�d2E�Ɋ�k�Ob��Bp
����"X�
�.����n'�#i�>u�L��l���D����К_L�2;��pr��nmϽ}��O�G�0=���$8r�D��O�w|O�{A<����4��e��W~N��:)�Ew;���R�5r����%�#�p�bu�O�"�@U��"S��k��~��,ɁZH.���/�Irjt�֑��u���
2l�/�u��n
\�Ť1��X0��R����<�"c�[ј'��.r��t�y�E8!�AR}X���M��쮘�"�|.�z�� �p7�2[Q�Wp�xv���w�<~	n8c�
�`�eY�COi�G�N�=���t�c��h����y���t$Ѧ�M�E1[��A	=�VYv�8Q�|.��E�-kV���b�;`G_4���l{뛙��qj��g�ƺ��ZL�(�Cx����	�����#�k3�Ń�f|s�qm=:�]�t�WQ����G^t�Cj��<���+�P�T�^��Ӂ���H�z�U�Z=��tDp����du>�e��b�I6�Z
�S��TyȎ�Z�{��3�_�<yƼ�c����Ĳ���2���A�B��-������~����fz      �   �   x�e��ND!E�������/�j|pb��9�NbBJ�){eM/J��C4r�y0hm1U�=O�02?�!�z���_��Ox�u�ߔ�ɧ4��!j����؇@Qa�|�j:�}:|"�&�&Н��48��X���G��0�D�uĚO���Ϸ��.xt����9Hʭvu�HZ�ք"3)!jJ~��A��n���� >�Xm�k�YZ�������a;�v��@�^�B?i`m*      �   �  x�e�Mn1���S�
��廰��9f&�X)Ab��"�2�L�
�Q݈���mYr���=��bM� ��`z@m2�^���e�O4�#�貝��N�@��yG3��z�˓p0H�@e���X ��AEes���}]��Zh�S�P.e�����R���$������z�}f�#��o[�3��Ň4t�Xź
9;��Z븞&z�׏����Ӹ�Ehc�-�A����&� �,�t�uVW�����2n�e��q�
��c��U��+Gś������r�Lϭw�}�u܍[a3Fq�#X.e;��A��s����؏[�X3Y�����\�$w�y�����t5���:֗��e-��|���Z��{��ƻNy��l��dl�I���M˵B�,��Յh����0���߾B���'�      �      x���۪+K��y��.����.�颩������1����j���+��[R���a3s���i����Q�K�V��^!����Jos8{��luW��]cc�.1��py�<�����
!Ϋ��'Ǟ3�1�n6<�����?�lM��˷�0�����j��4F+�G٭�>�۸+�ěE^tnsv��Xu��7�7=�K,�9�+oC��WZ[�>��\������������������/4��Zm�����C�ٔ�����:��J�����,�j)�<ִ)�G�;Z�~��X�K���쫬6X}o��Gy8��>c*�_����^��ݶWl�W3�v�<�۵���<��~n��U�b�1��l�y�`��8����B�u���{�����R
?6���F����O.������N��~�ɮ���j^[k}u�W:[4'γ�Uۺ��1]�>χ��ҸV�۹�R,�QR���u������3�h�c���-�l�z���C�˚22Gm��[dI]�r�i�����9�f�jb���ɇ��F˫�>�}ĒK6v]�G~�U�8�}�jC�*�qzW~��K�~��>����k:?P�ڶk�G�f��1�
k"n�r께�|.�
�����n���g{�,���"z,�td�/�<�̋w�W,�g;���_&��mC:X�Ѫ��`�s��R�+�u���X��9��?��ma��žG��*��*�������J5����GÉ�Z${Hq�Ȟ�;��zoa<�����رb�ϜC���r��O���j%�����Eh�>���y��igԤ6wh���#um�}B�>?�yL�n�D����~Q����D�+[u�����W祯�������>Z�~�T��B����U��F�����|�cq\��b+�޵^�A�V��%�|Ֆ�:f67,��ȑ��]n����M?�6�n�,NcA�w�s��'���-*�p���]A���*B�˕rm:� ��T��S���0��/rxa��	���=S�#���cM2O�İ |��͘�M�,LH���"���z�a�,lN6H\^�*a�fmvL�#b��r%S%Q�^���a�-0��J��[��x�Q6+��/,�W��Ci�3�I�����̪�tP©��:����Z?&j�k� �q:&70>)���}�8� 7��e�����[��3�F�����zc��ޜ�F7
�f�Yc�6|K��Hz���-�Tqa�[b���>\3��},mE�U���o!�eSI#/�K��W�ޢ��^�s�����w���{�1l6y_� %2Զ�W��{�;=��`3K��x2�a�#�ņ�������aL�@0R!PHi���Hc�U:�S_�*$��mS� 9�SA���Z��qP���ҪD����GK���׌�q���z�oc�<o=�}j��Kۘ6���i�C|��U�;B�_AAh��@���P�<|����V�k0�Yp�Z���kv=���J�� �V��yirpaa��ٳq��)�a�1�Ӛ.��m�.#��4�x=�� Ү�9b��4Wڝ-�}��:E	Z�f�� ��˗�\��x���؟c���ǽ/skqEUKl��5*��J�;v�6��8˓C`)�{������+ ����鐦�٪���q�.��փ��{@z�v4�����og\/��C<W�G0�`P�r,H���/n���n�V}$�x�_�"J \�3���l폁?��h)ۂ�?��3obb�8������0��<�bW�ֳM�ſ��s�"k�$O���U�}l�ݯ?i��p_�-��:ѱ�w��x`�q���{�5PY�N��&X	�;�����\l���.�%7�ws.s��]*��w��=;v|Ù�K9q뱋ͧ�ΰ��nGb����6���9�v�'f)ᦇԎ($h�-�j �k��\;n���������-٢�U
X5�)e�K�󌢟�(�l�d7�@�8Tv~q��v�����@��SYEiw�Ad��M (�!W���akv$ 4-7��*4�|mx�G�������eS���eN�y�l�!X��g��@�Y6�i%L��QCx"���c�.���u�8ߚq,��z͇����/��q8����lāe��\c��y�~�:�*@L�TC�(˛|*��U1ͣFhY�YFZ^�)�U�pn��~@�`�0@�$�A!�9���v�^�99z>�p�Kl_�&~d�*�r�K!��r&dA�{��4sF�t�~@�@��oQd؟���F���_�Zț/DHӊ0h���-��E����ܲteX���F���ר����[Q�ON̻�� $�9Ŷ����	(j}�a5~�"��˰�C���e@��7��#�W\u�]Ҵ��[)�MM$2d�sb�cBtX�<%=�`������tK���~=��eހDg����1&#�	�4����]Y}��-5��|��*�	����0�ٓ�������'��r�K�-�A�mtlf��@����_k��c� ���� ����֡a5z�y3]����D�@Q�����z̊��8\�i�|!��������˛:���9��h�M�
����+�}��5�p������+,^��� �C��+�� � /����B�x`N����6	��(.��lU4iu�^6l��b�r����)��[?��9���xt����Wc,$�(�pjn>���y�RJ@���xdnF�4s�?z���%�z<-�wr���;��p�ؠCT{v�c���!���rB�l!�	��Z ����h{�(a2��[�28�V���Ș%��(�CG�
uj��F�VF��1�9��(>u���p/|�9�����,��P�t����H���3�T� �-��!��ܺj��[VI��j0�ƫUNO�4�^K�Pt����s���(��M�򒭴�����;���A饱�Cg+��x]$t:��~cz��UOmc =kf��	R����;���7��#o�.T�^q�.�¾`�������l̜�6+Gd X?Mt[T����8�P�R�aa� 1��X�x��Ua��h�`M�{� �� CD,�]��Z�A��:X��S0tA_,�,Q�u7)�z�<��}`�k�\�$��
��]<7��I���3�uKR�_mK�v�������+�A> ��d�������{j:\yV�ʶ���*^�����ђZGg���pV�	�_�@g��I��a H�~ W�e����t3��c]�j>M �7�yA=_�� ��Sт"N��y/o�7�\�� S�Dv/�&f	cZ�3Z��4գ�w�uf(�ᤥc��Ѧ<��(�i���A�u��(㞇�i)߭�w��9C��<��1����G��`je�# ��}���� ��(��X8�/�� i�y���]��.��շ��䀠B��®]���1�<���l��S.��8
�-ˬX{S�J^�J���ϒ��O��'c��^���P���(��bW¼ڙ�;c�� �8�5��@*M^C�),8�mg�����W�-���
v�б��b�޸�u�^U�R �B�ϳ�\?������$k.uVUq�1�"�% ��G��6�U="�zs���@�gٞ#+��6�����+]_r�>A�G�}x�O�v�śs)�E���&,�9.[B?�{�C69���q�
B�Jwe���b{9��=[��_��-N|~��� �:�g\�k��صr�ڠ�8r�w�&��5��" C=CǗKc�ɣܸ�r�ƄY:��P,�mj�ݐ�P�SO ���K\0 �37�d\�x�X2ȉ�]i=hO�1���U0l��K(2.�j��~O����4���4V�1��v���\�+¾�A����X�W��#X~G���(��Ö  �&������y����>��KH��)�������V=l�jHVUu�BN�a���C�i���h�_*k��k0�E۷���i6�޽m�,sƖ������j5;�y��NU=�� �S?�o�U3T�	@��T�HR�P�5����k�C�z
�����Dm����    �����ʐ�2����%��$c�w�
pb}���p���T��Ϫ'�7bU�v=�+���/3bQn�,"}�R��o���P��&��k����f��F�%��x�����e0�J��"�,��IR`�W����-�4��9��a����/�!�x���g��*�c�
-x�mVN9���ɣ�:�ɤo*���1D�C1�A,��T��+�{����u%�]��Y�C�6�qӞ��"���e�1�*U^���J�ږU�om���"��`�otB��hT�i<5�^n.ּlW���]�p���%Cu�*��	�z����G�%�"!֟�3�� ��{���g��3.YTY0��g
���y����Q����l��� �J�+��d?�����=�Ü��J��Ј�����]�P��Eq7��q���k9����|��Α�v��� )c�B{C����YH�j;~X�۞5�kt�7��y�W�w����؝|�L�=N_��V��*:�+�^�c+�3�;�p�e�}R��5��STh��E���`�u��,Tq�r��O{��3�xN��]/ AXX;�~>�f� m9��U5���pЄ:�M 	� �C��M \K�f�x�S�=g���8���:�.Tԫ���fZ�8O��J����#kS^����	&��8K�Ne�Hp�4��n���3�z' �
�p^�Z�1Ԃco:L㔆R������q�V��+�5U�C!�8���xV�Z49u4�8�PgoQ?��R�r�αx��؛��v�f��f�r�ᑺ��3ߤ�$�tʝ�f����lq�!_n1�qבa�F�5$��:ttgN��L,?�4&�s�YW* �h��m�A��YM�q-�N�R�(���������' �,�{.x�: ���dQg��UTǀM+�3*�~T�|U2�X&R�����96iâ�5�#���U+�&�G|���8������AǏ��l�)���%��:�Ee�����R<�:*�Y^���]O��(ٯ�O#��O�ŏg�k�7^��O~vG�V���/&�&~�"����doUE>���ή]���"&{�=aDv|��99u��-���h(��L��W�Ǹ�rC{M+Q�;��&�&��ܙĝ=�}�.���.��9���;M��2��8�U�y�w|��VTp�%ow�=߄��e1���3�r��]z��*�#�����y��)N�tY���YL��R_�����r^0��"W��
;�pq^��dqoͬ�Lq�f*֗�X'3o7�H�k�;�t�R~ܥ����Ğg;�3�!��7��;�fkUZ��"��p��G���容���,�t]�C��]����ogb�����t8<�`��RP���aY��̯�5�Z��%[�Utl����J�)�~V�|Z�DvP�����
8c̺7/q,W8���]aȣ�S�i �;�wVk�:��iӍ��ȧ�]$�~�9�hU�\��'�~�Ӌ��Y��ܸ�a���|�4/;2����^�4���Ș��ei*b���C����3�z��B�4��SQ_U �,^8���쫱���#�V_靼� �g��g�狊��+�7v�f��O��_�`��L�ĆPu�b�k����c*��`�ڋ�kq�n�%�}lM����GZ)��&�[Y��	@�U3Μ�A��H� �84��ċ�P:w��j��Cn����O��͆�����z"��(�J�znh�ٽ���}�-��vi\Ed?,AK[�����1��s�d��פ����a�YE�x�Kj��h��wu�̌��B���p�=�kȚ�y���}&�ۈ�ob'�����qZ6T�8c'�����@u#�a�z2F��^�ua�)X�>4䇥���G_����̨g�Q��G�Ĝ6n��3�yqK������ښr�`P]J�����V��Tl�_����߻=����b���4N�d�*��Y*�,T�w��K��&S�[��6݋�Ŗ
�`x����mi���m����%خ��:C�i�7e+��(���FS? �.-�P��S�P���g�m�G�rlm�q?83P�"4��E@S���>{vy���|U�>��{�+rwy��ͻ<�Y��̵�W$���X!�7�4�߻�������{��AV=ؼ-m����k6g�z��Q��u��E'�KW	��dB��nk��}F������Py���Q�}����j�g�5B8��wa�U����F!�^y׀��W�Z6TԿ��7Aw�NŠ>Hк�K?�����/_�w�N٠S���6���<K+�9���y��S�Dq��y��ݐE]6khꨇE�g��>Q����W��nF�i�d��;��9�x�O	㻖&\��ۢ����$�����z�����x��&lr�7�	�l��*�Np����Κئy b~��\6љ�t��ȧ��2����k��<���=d��1�q�>bor�p�ڕx�2A5���ʭ��B��i�Q0�NyG�mb1��n�T3�kL$�7�T����I�-���p
.�P�|��z�����U!+��ڬgi޳��gL|�Q��x#>�oW�b�R�.:��I5e9KA�7����y�P��x�/�v*��� �_-H��s�+��3�Mn�5�9�����3�?���̌��%ͤ0�P��p��+T�M?K��7|�yc][U�̈́ ��ֲ�o�P?�d��*����|Pu�X����젉��)�/-���4˰�/D�X�ݡb�=<�Aďo��H�	����ݞ6��c�{�y���B&�K�������cz�"j �MW}�`�RϤ����?���q�+�ƺ��P�.Rp�䪩��I��y��_}�iÀS��]�QaK�?��.�������_�FoF�Sd̃��!qp��m���Y�����3�0u��(m��ѦJ�q-�h�(WPk�;{�Z���7�!P�ۻ��H��et�Bql�gl�\=����iR$LL�|�elk�ʥN��V�~�&���v��ө�8�n�h�\�Fn^_��u]��2���m�9M<�qa�6<C\�5�v�D���  k����~J6�]�4�q_�R�3�T�S�C5��lͧ��O^(��U�p��+��F캗[*��(�v���al�b����lSUdl���J�4@��C���1� ���K�S�^Ц�9����M�fI����]{95��Y��ɕl�][T�vExV�a��]�T{/A�����S�o��u־�8r�m0�����at�!�t/��+'��5�Y�,�\>��\z�f2;lL��S���3���ݝ��O[��g�b�����	%������9�B�8��$����'�ͭ��K�{!̑�L y�Y36�{����V���n��&<�.�%�cR�?����}�����~���ѯPAF]ש�]ɗ�����Ʊϊ&�)�o�d �]q�XQ�*z�Qt7©�:�qz��y�	VZ�Vz��x���ID� ýK��Q��L����i�J{yӤ���
��I]�X�:��g�������7�i�:�p^���L�/�㫃�>���� 2���)
Kս����t�<�n��3g��B�ZY]6T�L��&��kO��hY	<ª�D��B8t';�L+n��
Ϣ����ߍ�������*�p*:��?P�d���Q��)m�JZ��q�^鮒��Ÿ���t��g�1����B�T���tӬ�h�bG*x�XRa�8��>���E�bǳ}L�s��?\J5�fC`�w������:�33�����qF��{Ev���3$q�(�X>�^�*�9�?sz���C��� �;�pC�.��z`����հYc���y�<'������`�O�.�sW�W>�#7r{�9x��I�n�.���uI}@�uˉ�gMf8�hT�])�Q������İai���ydܱ��|�J�
w�ɻ�Y�4n��P1cHh�p��`�PE����C2�s9��➑�1�Z�.ɫY*(��.���`q���/6f�2=�
�p��Z�nxU����^ݏ91�����P�I��#�^��    ؆f+�?���^�S()*@nE�go��rK�c1g�9���.w�!�$��N��U�ɥ����d>���;x���h�q�^vg�zX��@S����(��C����B��4��b{@�2L]Ӛ��9�:��C��^j���%}��@�8�j-dp��P��"��~�; b  ���2V���Y8
�2�]�;���Aɺ$&�M���Aʣ)�(�4r�Ν�pO�y�9�h�/��].K�5ڥ&�r�s����������@P@�n��1�К}VK՜�I�y�>2�����őZ��ݼ�ղ�.$3���JL�8��2*P��ԛ
W�����S��L��y,���7���[���Ŷ��+)��/�Yb�Kw���	7*e�:�Y�Ƨ��}T6�:���M��̛w��p8T�����˭�3h�UR#�6�Lefi�m���M��C�J���<|٧U��=��_��du(��1�_�6��mX�G(gzv$>���&�h�����(��ц��E��Y4�{5z� \��\�nS�(W�>\'>�z0U�0�R�&c�����k����A��;F�\�
=��Q�dU/�����fɨX^P_���Nv �Z<��*M�D�%�|M�*�wo� ��jd���@��ˎ�^숣�vfp�c�d�e�*^��(���R�W��n�e佱�E�e�ʉ"���ct�<�������cwս+��(N��� ,X�_gq�3E���RH#��P�����D}�!E1�==�������ՠ�N]�h��"V+*��26K���w1B���&+��}�1�N��щFf�����UV�)�?�ɳNY��5��Z �Z�i�˖��D>���kƬz���n�uNj����Y��{�p�ӼciA��͢�0�WfK���F<��9�Tf��n_8d ]6��L ��V=�y3$�(s|��C�zX��Pٙ��i��d�3@���g���zӧĹ�&5����N��4����U��u�ӹ2/�(��;9Y2<\	E�u�h-x
���8,~��ٺ��;A�f��c�x�v��wK��s���ռK� ��m�N��܊l=�U� (�p�:�DM���b�K��@��ʿA@�q���{�	le�t�Ā�a��U�FN��8��լrQ����nC��V)��3l�C<CTg.�o�P���`j�͂h� �)�X��J�f��?�3��n����"��)�u�l1�	$Y���g�Һ����y�+'��(����ft]�L�ÑG/�������:e�U�Uu��x%�Z҈uJ�V��Uڡ�B��� f����i���0���F
Kw�d��=��f3�&d��0g����6`\��9�-��]S�nWC(!z�ء����k�|w,�-��� 	�"�Ԏ��i&���ʢ�>�F�H��m���C!���}r��Wlj����x�����
V�b(�>�
�O��:���<$k�.#E y��X7K39eANR�g���KU�0����lp�c�7b�S���9��>�+���U|�#�U�ڡ����"8&�;���P���:A�Ă��엳P٫ep���:õ�K�a��x�2�D���b�E�G��:^*F�u�?�
T�b����g������9�
4֏�L��b��m?3��c9~v� kn&��W���Z ���UcDd�tŭ$��X� ��<�c3�9z`�y��W�%�㍊�5{VCP�jig���i��|S�Y*���� KE=���7�~̦[x'���h�>LlCP���j�"-A
��@�;�=��5e���+B{�4�ww=VQ�J�t߲���5��6{�9S���s����jz#n�n���5��,fD���;�Eݟ'�����(s>��*e0���D���+	ep��	�QU�V5��K��t�7'M��xS����T��ЪL�u�X*�-泮ԧ��>V"���N��B��g7�H+�i�y�4�s8��Y����M���9�X�K�gbN���Ž���s�HYCN�]軂�:翧QK�v=t2�M�>���Z �4�F@���1�Q��EM�2ۙ��H�5�vTMZ�`J��A~j5��6A6��H4��%݅�w�qWzm���	���u�쮢\�+��}��
0�Lڎ�1�ي=o����t����.;��~���G�6�~��h��c�~	���&�x�Ӯ:�����$����ݣ/�5P"x�'s�[�٧�Jwⱨa�B��.b�H������п�m@V��Pӽ{FkC�]�f9F��O�{]�tr��c#�Y�8�.Re �4.�uV$zf���K�X%�0ƿ-�Φ�A��o�/�Z�c����CKw�� ���TzR#xo�փ�G�`����@bt�brײ6+��\[��D;1Ě����k��χf��e�iׅV����.�����G�Qq��1 ]���K������۠��p�����>�ܠ����u���:����Tc> ��xnt��ݨ��aU�ǧ�9�y��=���Q�Au�<��{�F�}�<kfy�����T���b�j�̞�Xo�~Ҝ�l���ž�����V��l�0.+fg��=_z��;�VSA/��Wt���N筇� 9�=Nh�u,w�?h�W;su�1�F����o�T�h:�OM�s���w] a���"��Cո�RDN����}q����t/����J�6A�~��Ǽv@�S�M�&��=9}�Y�v\��	�E �|��1Ҵ?�VXg�3ޭ��a�գO�UCV��r��t�f��a�z =l���͞��w���z�{|`-��L�bM�<\�8D%���V���+b�MF}���q-�F���^
W�%m�P��VTf䨆����WM�PI1P��|ܐ��A�F	F��ʏu���e	SqU�j�{�yڹstVӹ���̴'�����u'ݼ�(�ҍ��^45�� j��yɵ������<�>R����y8�}M{ǲ���:�S�n»�'����p���H!ե�4o����}s����&����������%�W3<���2�u�r��5_TC��3S��=�~�EX�a:H�y�k�}�$���v�v�*���-���	������-�U28�^j�i�,1�"�g1�g�Έӟ# ��n/��=����
le���1ѻ}fgϨS}U�U)`���Q�#&������i�'�g'�_��T�t�
gS��+!��.��dG��m��юi,�d�^H}�hI=�`��+G��~l�~��Ԡ��<�$��Vj��+��1�}
��ת~s��j	�p�q�q��T��8����Y��}*�K��v�y�y���y4�f~Q�ݻ�(�z�w��
��� t��/���1��)X|ȀXk�����	����n�)�>�.ޜ&�^�ɢ�Q�sp4u�֯f5&tW�|��gᩳ�s|��l��`�x�;̪�����9&H9�F�U��Hu}��dgu}8;`�y߯e-*��.��\��-��v��ϼ��<�'En1��+7�T��q˦*�caJ�I��=F�A�RfqN]�nw��4y�SsN��^Y���K~�=�e���3]�}εnMᵫ4D	7o���1]|��`u,�l�u�6$� @�M� ��w��x�+Ƣ�i�*]�Ȕ&�)�W`{>�\u�L�t�M듇ִ� ;W��+�^'�k�g��{r?;�$�!ob��͒3@K�V^u�=b���q���~�>��Ѯ���`��w�5޴:S���E���-l^�Y����v���qk>���W3gW}N�R�A�� kW��гF~(�VSTT⿸��oST�'��4��z����)O���dN�*}̨[�Flw��	�j�+�'j�w<�l��Y��O����Ɣ}��d��dU,l��*�u���4�򺽻�����6Wa�jA��G	�S?����ݻ��� G"�q��}~qr�0g���w뺢b=͹Έ�4Amg�g�?�OV���Y�[����f�Dk&<��3g����O������P�"o�aC^�����Rs��;�g��=a�FOw��54��F`4U-��	��A>Ϻ���s|� �k�c;Є�R��.���M����_l 
  0�ͻ���c��4��tIɥ��1���WE�$�XZ�����*¢����`�J�hd~C��[5�T��WH��o�L��[���gW{O��=K�l���?~��U(��/}���Y�����34�KW��i��Ք4�s�y%y��쓓3�����4E��
�mpO�e�ݝ�"O�S|b�ua��`u��Q��ֻr���)Щ�}�wu�Ҵ{w��KM]�d����&��4�1�}J�} �[ǒ�+�Xl'�q֥�ʚW5[��#�����_K�@:;+ǽ�����H�1W�54����U�l���
�p�W�1�1��V	�W�|�,,��h�ܙ蝅'ݟN�CQ>.�Ot�\�a�PL�S�c�8K���L���^�YJ7�.�Q.U��:_�Y�=m�n$�����Ll��Q�*M��3U��p�l�pg�o�b��s/�]\�éZ��f��v�_��ˮ(�э�3]^HO�6o(�CU]P-h7��X|[w*h�oĤ�[ŲMȸvP��>����.�t�j��b�3p��_P 	S=���Q���^iΎ�33�oN��.���P ��3�4᪁�{&��K�bS����4�f��F����v!�_hY{U�vx�����|Oo�t���_ ڵ�Z�L��G�Vs�ƪ�ݖNm���k!͵X(~2�����t�WO�u�����V�����eM�)���٣Og<3�tێ�ZE�1����0*4��;��o��(��i�]+� �󖎲�q��4OȔB���>��|6�]7���'�b���W��J��>&�p՟j���j��l���M�9�{ļK�s��b���t�/�m��-EB�2�g'��ы�x����)�6�Iu��E\fP/��3VV�����7����aƬ���i4O���?)�4Tm�jD����;9v������wL�f:5�@9��ءo�N'���~�,տ��\|`�~�����>_��A�领o�W��]�o��F�.7��5��n8�D�����DɆ�j��.�v��M�F���ڙ���$���Aƶb$��J�b��� ���E�c��:��Y�����ݽ�Z9d	[mNF��'xulFiww��=4��v�2�L�d��l{�g�]YK��S�I�p*�1x���a�� Փ9L����>]��E#��!LPpO����Y�&����[3,�����ړ��z��9ݳԾ�Z\~Q���n��V�:�vVu�:c��&ӗEM�ԧ�3����za+��{Xq�r�2�C��7;G���٨��[��Mqђ5�Y�X�ę}?f�T������!r�E�&�-�q����{���j*t�B ���U��#�a��O����D��'��0d�l%�1W�FH��ƞ��w��*�����!�k\8RΚ��<�h��鵪�}ޥ")��b�B��TG;l��g���XR|u���ڔ�{r$*�WW�S�5�O�P��8��%UL�=�pUt�j�Y���`��Y0T����VeN��MB�c��U�����U=�z�E��߫]:�ûkb�1*�p!H�n�R�ZEWD>�9�{�{�pMU�P�U��{�i�v�h=�1�U��d;���䋷W}:�ͳ_8��	vG�!��J�`QÏ���-[`�DI_`�*������TɆ�)���%�R�T��y�X�������#M��um��.u��mơ�V�s�5�X��%��+��G�R����B�����(X]_����>�w���i��/݌�I���Ga®�6S%����H�9���7�+*��*OO5�~�xf��6>�ms�7�����~��6��,��̠W~@���k^��#�L�8@��v�[�4��$����}���V����+��U����p�Ř�����.̧Ԇc)���X�����������:�B���@2������?�b#�wS}��Lw+IePՔci����S�\OG�~�h dl=�U*��oR�wyi����2�C��ݡ~߰b�i���X�ՏGG�����1h��.w�YC�"�&M̀?�t�a�_�#T�]��^8�#��\,fb���_7��zY�{|�Ħ��W�ۀ�\K׈��0F��+�cx�"�z�ԅ�4�HW���A �{h�,�s:��ӝ����r���:)b�&K͹�M_�0||��yƢ�#^S�B��Ǧ�hkT���kێ���t� �e�a*\�颼��d��.�Y���!��XN�a^m�QKfY  ]>����T��z�u�~;�]G�z�J�h���W}rD�a��ڼ��v+J������5*]rr��c�3�Ɠ�WvY�	+/�K*�u��j�Y[�S���̘�f�i8��} հ��0q��zp�3s}v�(3kp��%�y߭��V[�/N7zOd��*#j���e�Sq���Y���*����@f�ƨr��%�:��oO�AX
��G֍5��5��K���r1	���\�,��w����a�ǯ誥�ĨWhs�0~�Z�+�>��A]J�R���^C��4Sg�R�ژ�]���NTTX���T�Ta�����Dֹ��֝M�m]�Q_��յs=k�yV-�]0�ط")Ω&���k�F�Q�=�0�u��?#����n�MU�?�V^�~P��9Y����:r��y��z�W	.@F����t��wWɸ�R�S��ek��f0^Y��RQr8��?�}󼬽�^�9݋Wϙ=�˩��X�Iz�	�_�=�_6�Ñ����Ku�`0��zG��n���U�Iwȵ����@�医��tײx^9eCjT��f~@�9��X��+@����!bP��Nl�Xgſ�Wh��X!�(>�>��i��g�=��{��y��8�fʅ6hX�@IQJ<j���~%�@�ZИ�Z�S[$��9P��z�U�b�.�)��A�-�/`�=�m�ϊ6N�q�ǖ�B�"
��|kd��qcuw��I���]�OF��q'��t����<
lDEn�b?�{��B˛ͭ���S[�%�2�bqȟ���MP:�~�ϱ�6W�XU���_x���x�����e�Y�n|�+I30��gr���>�qh"�Y��Oؠ�[U<+��@0��!sZ�T_��S�>ffe`�fO ³-<`��a�t����Lx,��an���?*<U86��r;k�w��}EqT_g���^ˑ/�(�-�c?�np���9�j���ȊAd-G��.k_T3�l+���iYPx�@H��nc�v&Sپ��J��pџU|��U��F( {Ϲ\N�]�NW��s��p�,}<I�=�	�]�}3Z�J� ���M����s������}�����߿����      �   �  x�E��rbAD���-T�,�01e	xx��s�i��BH�W����[��z�G�0�8���4�R8,,g4�\8l�u��cg���4S���4*�q�x:���O7-R�4�g .ul�Q�Mv+کԇ��������c�A�H�x�Y�3���%�e^pb�}��I��NYk#�Bʔ$�֒�L�������qyr�&���ن�[��jr���<�}>�L�٢��z1���'S.1�5�p�� f
���i�DǼ�LrO8JN�t9BbQ0�H��������j�X�g��}��5�l*�.>�k��F�á��U�/�|n�㫩~����Rz$9�;)���!#��"1���Gb���O�H#M��5WTQ�e�6w̎������:��f�fw��0;��]d��-��ph���s�}�lp��?�f9�_��c�.N��)Z���\ �z8�!h�U
�YE�%�&P����H��72!+�@Qј��^:���]��k��Ƹ���b��kK����O�V8ʹ؛q6�V����Z|����i3���k�J��H9p�kd�ƈ�r�R"���Ф��*���\��GT',T����ͮW��׾3+Q�_t}E;�71����N{�|4u�Ck}�4��v����=ߟv_\�(&�5�X�'d�
(2�x�N�H��8�(F� �
���Ϗ����)�r����.?X����ê]Uw?H7�[����tq�b�c/��ۍK����.�֮U}a��4�,��18���2�4C��*b^e ��9� 63XId`�T��	�d_�?��ɾT������~Yw��������{���~��f��tQOn-3�M��NL
��8@%%i�2���d��0K��q�"�C���+����[����G'��ݸ��pm�z_ӫM�~�U2�.N�aeX��y�i���2��E�0k��_Bi�cP&�2O�8��B҈8�D �j���r�0��o��� '��ABX���b?\�WX.�}�O��R���G�q��Z�k�0��Í-���_�s�A��K�bE&��0��ƈ�$s�� d�!�Ɗ���%4����wVZ�����\����5��V���(G2�j�I0��ZJu��E����k�Ͽ\�kA���xi�v�c�đS�#�����@X���CQf(���wvX�RX����Y�w��<��6���ڗ�4�Ҭ���v����/bö{Щ?T`�	e�jy���#b0N��Ĉ�sH��
M2H!d���p 2M1�Ѓ���_�C��f��iY"�We�^le�B�g�t���qZ�hyzlG��he<��W�z&�P	�(�=Ga�`
�B�$JS��&1g�'H)���C�bEK��C�﵁�^����ZU?��3U�ɤ���A�:_L/�t������W��x���x䔅�Yn�3O�GH�~>Iʭ��!x.a�j[��Zhb�2.^{g3]�Z��&���-G�ݜ6���ū�&��b9<���,�te���W&mU��R�	2a��� �=�Z�ܜ'�9���z�]F(t���L��9!��j�n>�������7y�=���NW�+7���=u63�_����
�P|L�A��Ft90
��@%�go�<KBy�"	r�)iTi��H�L����y5������ǋJC��5���KZ8�͔]��mY�,���[q_�0�ǁ|Aq*�����0�H�F����\���ȡIa�Q.Q�a �;�4LW[WFs�(��T��߯M;��m��q�lX�_���V���t���o76��P��u#s�LN����TC��J���D�N0� �y؀�$����j(PC�!=��J,9��~���Y����6���V2]�}�ܕ`j�ɽ��{k�o���i�}A(ME�G0<
�4��ǹ%�'�m>
��5 �������C͈}�J���U��)M�}��S�[̋��؝w�m�_},����QE~|�Z���:�>�����鉆+
|#�>OH�w&�-NR3�M�d���)T�����1ZqH���/�y����m�զ�J�=ώ�b�����F<��3z)W�~y���";�
��zAQ� e�n#\b\�a�	`��%L5��:B.���������a�@d���P�P�v]�r��\�������|�G�(qՓ�z?l%�쐞������osr�I`%�\�.����I�CK��O!����_��      �   �  x��W�nI=��b�$�,��(����L�2�/s�\�,�T%�r��~^R��ssB���"�-�Rs�"�"%7Bt�\�Zc
1F���Se��-�˱?�7���y���:�s7�LFg��\I�e�Ҩ��v~c��z|iU`�U�J�X$OBO��)��c*��)��={_��yY��v�}��p8PwK�<uA���v� ��f４Qo�u����V:��iu1����7�ky(�x�����h��gZ������2ا�&��Ώ�s�������Z�J��iﴴZ
Ϯ������r\�^	�B���d{͍՚-/�:�K�U��!�rb�Ѻ����e�T���2֥3qw��<?��KŤ6A� Z�����M��D��t�}�R���'����b}��Jci���B������i�7?tt�@��3��U�hmٵW~��<OU��`�	�hj,2^D�p��.e�����@���}����{*��Lo�*��/� :�ݚ�p���do7!��5�[�l��:�r�&�呴⪨DE��cw�@Ӻo���f���eX�<�t�݁��~��n�k��)��9m<f�fz���h�S����N��Ѩ6�<�)!U'H{S�ǚ��=-`qe
u�����4u����:��}����h˕e��rB��>l�[h
�i���" 3�8n�N"g��8���A������<�'�e?O��XP�+�~�Ŋ6fk���G�]�o�
l��5���z�R���C^>i'���E�����q���e�)��8O����b�&&�'<ׂy	�pJ��k��e�*�x0�IXI��e�H����z{�oT!�גl`�֧ab��X�V}��0A�S'���^���h�sM�Ω�z�(l�VƬ��hU�H����X+`#�`= 3{w\��6���:N�D8�e�A4��!e�LJ��n	+�����Q��z<W�Y�yV�ؿvws�s�{�����1���lw:�X��}����+'���'�q=���d�M&S����8d8 ��|;��^��4,����4��S��,� f�1�{��8+���C��0�f�C�aR9t--\�-�GŅ�����2�u����<���� S�tK�d@u�K˼�
�C�`va#��ze���L(�P2���ć`r��b��!j���t7?�{Z��n;�z�B����ݰ��T2eUtڙ&�JH��~�<J%�!9��&B���B*��䚡uBwo뉽�'ˋ��ۭ|�`6��#O���<�Y��U���~��Jh�[\'m�R$a�&�ة�b�J-�"�h�|Z����4��X`�0�z�l�=��H��)!�(]˰�N�q��U�p�\�Ԕ�'��l�M��dx�(��*�K��8����':.u]��#-����u8d��{N����Z4��H���$�
D0p�e�C*��%���\������涇����t�C3��v^:w�|����3�eJ���1"I�ƛ�u`Y�������X���j�x�Ԃ��2�gk=����H�U��.Z��?�4&��X;����ù�rm�9oXP��A5��}m�-\%��=�d�'�j��J����|�����R�O�Ӑ�ݷ^��RgmK���5�UUN�O.@�d +�p0@��Η���S�cZ�9�~�b�*��L��&����Wa7eh���"-�0�Q�w��;��qwԌ�"�3�@$s�^���l�XhXB�tX��nJB�V�P�DI���4܊2���wm����ͤT#�Q΋/t�a*�`��*U������0�r6����t�/�����8��jy�a�2='��Hgl���G�
l�՗`���.���[�7vy��S]�����y���mV���2(	D�+��A=C��>�gj���%If��nZt�e�� ��Q��[�^=��|�9\Οm{~~%=8Si[�6���ςb<v�\���7���S��z6*�_O�nR�H�e������7Â/��&������B��      �   H  x��V[��0��<��� a�K��*�F#M���Mt��`�cf�''��;���fb�t�n�R�Չ�%��E�:GX�l�{��Ӛ^�!E.�H��rF�<��vtel&6�������r�!?��Jj�p��m��Y�r(�I[l�ٔ��!;���wO~�Kwc����� �u(b�s�ɳ�.�6�vd�1RT����A�y:�p�U�N�&�}�Z˞#O���PY��p<�i�赛���e�.[���CܷS�L*�3nʑݿ����\���c�	8���-�P�e�$���dt���v|ؼ쑾N�����-�m�L��y�񭻚,���[���8��ҳ���M*�fWM��R��b2�P3�,Vqϵo�k�o��ϼha\�8��H�7e�Fq�I~�}��C��������b���l^�N��G�J��~�����f0�Y��\��/;�;�1��4��҆C�@�.�k���u=��0
�=��0�){^�9����� E�ǽ�e\0oũ�q��ߺ�'��UM�n��K�m��#�	����u#�*X�G��X��L����U�h�|�	��2Qb�#c���KI���`��"|q��,�������/����+t�6��ͮ�Ǵ��;�� �`��ty���}��:�-Cz�6�pl��a���ֲ���Fu�[B�B!���:���<m��:@jMPP
v�
څ�u��J��f�~c#�Ew�{5D���R��u_�!��I�'�q����^�η2>F4��zEc\�3db���M7�}���JD��D�J��Ù�Z?}׎߾�l9�Tq!૊S'�v�#�,Y�4��)W"��#{��滩�)�p\[����C�U���u�f2���p�%T
L���3�������[w�Y���M�}F&�D�c������F�P�#������X�-�'���'y$��z|��2aS�:������q��Z����+�>&�^Y��Mɟ��tb虐[��/�,�����>ms�H�����MI��^���ܧٵB$T!����l��g��ޫ�{�7�o!��½�X���M_���5[�;l�F����,�Á     