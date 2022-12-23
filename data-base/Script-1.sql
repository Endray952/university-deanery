ALTER TABLE teacher_subject ADD COLUMN id UUID UNIQUE; 
UPDATE teacher_subject SET
id = uuid_generate_v4() ;