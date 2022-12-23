
--SELECT "group".id AS "group id", direction."name" , semestr_number , start_studying_year  FROM "group" 
--JOIN direction ON "group".direction_id = direction.id ;
--
--
--
--SELECT * FROM student_status ;
--SELECT * FROM student_group;
/* 
 *   student status + group
 */

/*9d671b1d-3170-4cce-ae61-ec083bfa2948 group students */

/*2cc0cb51-f162-4ee0-a794-3181bd9bfa46 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'2cc0cb51-f162-4ee0-a794-3181bd9bfa46',
'enrolled' ,
'2022-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'2cc0cb51-f162-4ee0-a794-3181bd9bfa46',
'9d671b1d-3170-4cce-ae61-ec083bfa2948',
'2022-09-1',
null
);
/*32d37bf3-c80e-4358-a7a7-d140e42d418e student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'32d37bf3-c80e-4358-a7a7-d140e42d418e',
'enrolled' ,
'2022-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'32d37bf3-c80e-4358-a7a7-d140e42d418e',
'9d671b1d-3170-4cce-ae61-ec083bfa2948',
'2022-09-1',
null
);
/*8ce78a75-5c2e-4d61-83d1-f699e8789755 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'8ce78a75-5c2e-4d61-83d1-f699e8789755',
'enrolled' ,
'2022-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'8ce78a75-5c2e-4d61-83d1-f699e8789755',
'9d671b1d-3170-4cce-ae61-ec083bfa2948',
'2022-09-1',
null
);


/*238a0a6b-714c-423b-a724-841f010df3f8 group students */

/*60ac34ee-27e2-4941-8311-754877cfb6b8 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'60ac34ee-27e2-4941-8311-754877cfb6b8',
'enrolled' ,
'2021-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'60ac34ee-27e2-4941-8311-754877cfb6b8',
'238a0a6b-714c-423b-a724-841f010df3f8',
'2021-09-1',
null
);
/*d18ac7d4-4dd8-47fd-ba71-42d53329d253 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'd18ac7d4-4dd8-47fd-ba71-42d53329d253',
'enrolled' ,
'2021-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'd18ac7d4-4dd8-47fd-ba71-42d53329d253',
'238a0a6b-714c-423b-a724-841f010df3f8',
'2022-09-1',
null
);
/*024a6e9d-37c3-4751-b899-7b576784cae7 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'024a6e9d-37c3-4751-b899-7b576784cae7',
'enrolled' ,
'2021-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'024a6e9d-37c3-4751-b899-7b576784cae7',
'238a0a6b-714c-423b-a724-841f010df3f8',
'2022-09-1',
null
);


/*874c3684-ac19-434d-b9ce-01e5472161b8 group students */

/*7859b168-7b54-4fc8-9b80-153c57be2216 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'7859b168-7b54-4fc8-9b80-153c57be2216',
'enrolled' ,
'2018-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'7859b168-7b54-4fc8-9b80-153c57be2216',
'874c3684-ac19-434d-b9ce-01e5472161b8',
'2022-09-1',
null
);
/*9ac5b0e1-9bdb-4551-b050-4bf97716b7b4 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'9ac5b0e1-9bdb-4551-b050-4bf97716b7b4',
'enrolled' ,
'2018-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'9ac5b0e1-9bdb-4551-b050-4bf97716b7b4',
'874c3684-ac19-434d-b9ce-01e5472161b8',
'2022-09-1',
null
);


/*aefc31f0-044f-4b1d-b9af-1a1a72c1dce8 group students */

/*f3ca4adc-03b6-409a-af3d-81e76572beca student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'f3ca4adc-03b6-409a-af3d-81e76572beca',
'enrolled' ,
'2022-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'f3ca4adc-03b6-409a-af3d-81e76572beca',
'aefc31f0-044f-4b1d-b9af-1a1a72c1dce8',
'2022-09-1',
null
);
/*9ac5b0e1-9bdb-4551-b050-4bf97716b7b4 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'997351a9-a9b1-434f-927d-e36f4e0b8ee1',
'enrolled' ,
'2022-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'997351a9-a9b1-434f-927d-e36f4e0b8ee1',
'aefc31f0-044f-4b1d-b9af-1a1a72c1dce8',
'2022-09-1',
null
);


/*c44330fd-3830-4b59-9d40-fc411716b651 group students */

/*62e8f976-01fa-4a79-b66e-97f083c7a076 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'62e8f976-01fa-4a79-b66e-97f083c7a076',
'enrolled' ,
'2020-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'62e8f976-01fa-4a79-b66e-97f083c7a076',
'c44330fd-3830-4b59-9d40-fc411716b651',
'2022-09-1',
null
);
/*852ebb18-667d-485b-8544-2e3faa405819 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'852ebb18-667d-485b-8544-2e3faa405819',
'enrolled' ,
'2020-08-25'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'852ebb18-667d-485b-8544-2e3faa405819',
'c44330fd-3830-4b59-9d40-fc411716b651',
'2022-09-1',
null
);


/* expelled student*/
/*de3887fb-5415-4862-be0e-4630f3374c04 student */
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'de3887fb-5415-4862-be0e-4630f3374c04',
'enrolled' ,
'2020-08-25'
);
INSERT INTO student_status  ("id", student_id ,student_status ,status_date) 
VALUES(gen_random_uuid ()  , 
'de3887fb-5415-4862-be0e-4630f3374c04',
'expelled' ,
'2022-09-10'
);
INSERT INTO student_group  ("id", student_id ,group_id , start_in_group_date, end_in_group_date) 
VALUES(gen_random_uuid ()  , 
'de3887fb-5415-4862-be0e-4630f3374c04',
'c44330fd-3830-4b59-9d40-fc411716b651',
'2022-09-1',
'2022-09-10'
);




--DELETE FROM student_status ;
--DELETE FROM student_group ;





