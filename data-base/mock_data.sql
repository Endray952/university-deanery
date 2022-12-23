/*
 *   Subjects 
 */
INSERT INTO "subject" ("id", "name") VALUES(gen_random_uuid ()  , 'Математический анализ');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Физика');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Программирование');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Английский язык');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Физическая культура');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Базы данных');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Архитектура программных систем');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Дискретная математика');
INSERT INTO "subject" ("id","name") VALUES(gen_random_uuid () ,'Русский язык');

SELECT * FROM dean;   
/*
 *   Institute 
 */
INSERT INTO "institute" ("id", "name", dean_id ) VALUES(gen_random_uuid ()  , 'ФизМех', '4dcfa515-d10a-43d3-b24c-13e065557df0');
INSERT INTO "institute" ("id", "name", dean_id ) VALUES(gen_random_uuid ()  , 'ИКНТ', '0f36527f-20d3-4f6a-a5f2-20f929c9b857');

SELECT * FROM Institute; 
SELECT * FROM Direction; 
/*
 *   Direction 
 */
INSERT INTO direction ("id", "name" , direction_type , institute_id  ) 
VALUES(gen_random_uuid ()  , 'Прикладная математика и ифнорматика', 'baccalaureate', '2e5aca56-857d-4309-86e3-362b94416890');

INSERT INTO direction ("id", "name" , direction_type , institute_id  ) 
VALUES(gen_random_uuid ()  , 'Физика черных дыр','magistracy', '2e5aca56-857d-4309-86e3-362b94416890');

INSERT INTO "direction" ("id", "name", direction_type, institute_id ) 
VALUES(gen_random_uuid ()  , 'Программная инженерия', 'baccalaureate', 'a9c237c9-07f8-489e-b556-16e5cad86fe3');

INSERT INTO "direction" ("id", "name",  direction_type, institute_id ) 
VALUES(gen_random_uuid ()  , 'Фундаментальная информатика','baccalaureate', 'a9c237c9-07f8-489e-b556-16e5cad86fe3');

SELECT * FROM "group" ; 
/*
 *   group 
 */
INSERT INTO "group"  ("id", direction_id  , semestr_number  , code_number, studying_plan_id  ) 
VALUES(gen_random_uuid ()  , 'ae3f4ea3-d67a-4f9b-bb0d-e769e0d5d9b9', 1, '00001', 'decd68fc-51c8-4134-bc85-a8c62164514a');

INSERT INTO "group"  ("id", direction_id  , semestr_number  , code_number, studying_plan_id  ) 
VALUES(gen_random_uuid ()  , 'ae3f4ea3-d67a-4f9b-bb0d-e769e0d5d9b9', 2, '00002', '2d77e88a-cddb-416f-b84c-fe9bd99b116f');

INSERT INTO "group"  ("id", direction_id  , semestr_number  , code_number, studying_plan_id  ) 
VALUES(gen_random_uuid ()  , '4662e877-7db6-494e-84b6-9d39a6d8eb13', 1, '10011', 'ab912195-ca2a-4377-b62e-49c9e8a0b95d');

INSERT INTO "group"  ("id", direction_id  , semestr_number  , code_number, studying_plan_id  ) 
VALUES(gen_random_uuid ()  , '3c7e1c5e-397f-467e-b958-ebbb3a1b2c68', 1, '01011', 'f347a6c7-a4f2-4809-b18c-6e327c277339');

INSERT INTO "group"  ("id", direction_id  , semestr_number  , code_number, studying_plan_id  ) 
VALUES(gen_random_uuid ()  , '45a0b28f-1bc6-4298-96d3-a6ff128189ad', 3, '01032', '43e9ab50-5c0d-48e6-8d3b-399b4e293b44');

/*
 *   dean status 
 */
SELECT * FROM dean INNER JOIN Institute ON institute.dean_id = dean.id ; 
SELECT * FROM Institute; 
SELECT * FROM dean;

/* working deans*/
INSERT INTO dean_status  ("id", dean_id , institute_id  , work_start_date  , work_end_date  ) 
VALUES(gen_random_uuid ()  , '4dcfa515-d10a-43d3-b24c-13e065557df0','2e5aca56-857d-4309-86e3-362b94416890' ,'2018-09-01' , null);

INSERT INTO dean_status  ("id", dean_id , institute_id  , work_start_date  , work_end_date  ) 
VALUES(gen_random_uuid ()  , '0f36527f-20d3-4f6a-a5f2-20f929c9b857','a9c237c9-07f8-489e-b556-16e5cad86fe3', '2020-09-01' , null);

/* stop working deans*/
INSERT INTO dean_status  ("id", dean_id , institute_id  , work_start_date  , work_end_date  ) 
VALUES(gen_random_uuid ()  , '8be42be4-d234-45bf-8a63-2f949d6fd63f','a9c237c9-07f8-489e-b556-16e5cad86fe3','2010-09-01' , '2015-09-01');

INSERT INTO dean_status  ("id", dean_id , institute_id  , work_start_date  , work_end_date  ) 
VALUES(gen_random_uuid ()  , '43dc53d8-7317-453d-9a51-210227700a6a','a9c237c9-07f8-489e-b556-16e5cad86fe3','2009-09-01', '2010-09-01');

INSERT INTO dean_status  ("id", dean_id , institute_id  , work_start_date  , work_end_date  ) 
VALUES(gen_random_uuid ()  , 'd6c7d57b-34be-4eb9-b8af-6b5ed6f0cddf','2e5aca56-857d-4309-86e3-362b94416890' ,'2011-09-01', '2017-09-01');

SELECT dean."name" , dean_status.work_start_date, dean_status.work_end_date, institute."name" 
FROM dean_status JOIN dean ON dean.id = dean_id INNER JOIN Institute ON Institute.id = dean_status.institute_id ; 


SELECT * FROM student_status 


SELECT "group".id AS "group id", direction."name" , semestr_number , start_studying_year  FROM "group" 
JOIN direction ON "group".direction_id = direction.id ;



SELECT * FROM student_status ;
SELECT * FROM student_group;

DELETE FROM lesson ;







