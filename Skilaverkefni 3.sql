/* 1 */

DROP FUNCTION IF EXISTS progressTrackerToJSON;
DELIMITER //

CREATE FUNCTION progressTrackerToJSON(semID int) RETURNS JSON
BEGIN
	DECLARE cur_studentID char(10); -- kennitala
	DECLARE cur_studentName varchar(255);
	DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE cur_course char(10);
    DECLARE cur_trackID int;
    DECLARE sem_name char(10);
    DECLARE student_courses JSON;
    DECLARE student_info JSON;
    
    DECLARE j JSON;
    
	DEClARE json_cursor CURSOR FOR 
		SELECT studentID, studentName, trackID FROM Students;
	
	DEClARE course_cursor CURSOR FOR 
		SELECT courseNumber FROM StudentCourses
			WHERE studentID = cur_studentID AND semesterID = semID;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;
        
	SET sem_name = (SELECT semesterName FROM Semesters WHERE semesterID = semID);
	
	SET j = JSON_OBJECT('semester', JSON_OBJECT('name', sem_name, 'students', JSON_ARRAY()));
                
	OPEN json_cursor;
		json_loop: LOOP
	 
			FETCH json_cursor INTO cur_studentID, cur_studentName, cur_trackID;
            
			IF v_finished = 1 THEN 
				LEAVE json_loop;
			END IF;
            
            SET student_courses = JSON_ARRAY();
                                        
			OPEN course_cursor;
				courses_loop: LOOP
                
					FETCH course_cursor INTO cur_course;                    
					
					IF v_finished = 1 THEN 
						SET v_finished = 0;
						LEAVE courses_loop;
					END IF;
                    
                    SET student_courses = JSON_ARRAY_APPEND(student_courses, '$', cur_course);
                    
                    
                    
				END LOOP courses_loop;
			CLOSE course_cursor;
            
			SET student_info = JSON_OBJECT('ID', cur_studentID, 'studentName', cur_studentName, 
            'trackID', cur_trackID, 'courses', student_courses);
            
            SET j = JSON_ARRAY_APPEND(j, '$.semester.students', student_info);
            
        END LOOP json_loop;
	CLOSE json_cursor;
    
    RETURN(j);


END//

DELIMITER ;

SELECT progressTrackerToJSON('6');

/* 
Example output:

{
    "semester": {
        "name": "Vor2018",
        "students": [
            {
                "ID": "1803982879",
                "courses": [
                    "EÐL103",
                    "EÐL203",
                    "EÐL303",
                    "EÐL403",
                    "FOR3G3U",
                    "FOR3L3U",
                    "GSF2A3U",
                    "GSF2B3U",
                    "GSF3A3U",
                    "GSF3B3U",
                    "STÆ103",
                    "STÆ203",
                    "STÆ303",
                    "STÆ313",
                    "STÆ403",
                    "STÆ503",
                    "STÆ603"
                ],
                "trackID": 9,
                "studentName": "Guðni Natan Gunnarsson"
            }
        ]
    }
}

*/

/* 2 */


ALTER TABLE Schools ADD schoolInfo JSON;

select * from Schools;


UPDATE Schools
SET schoolInfo='
{
	"schoolType":["Vocational", "Private"],
	"founded":2008,
    "website":"http://www.tskoli.is/",
    "abbreviation":["tskoli"]
}
'
WHERE schoolID=1; 

INSERT INTO Schools(schoolName, schoolInfo)
VALUES
('Menntaskólinn í Reykjavík', '
{
	"established":1056,
    "headmaster":"Yngvi Pétursson",
    "classrooms":40,
    "website":"http://www.mr.is/",
    "abbreviation":["MR"]
    
}
'),
('Fjölbrautaskólinn í Breiðholti', '
{
	"established":1975,
    "headteacher":"Guðrún Hrefna Guðmundsdóttir",
    "slogan":"Lykill að framtíðinni",
    "website":"http://www.fb.is/",
    "abbreviation":["FB"]
}
'),
('Verzlunarskóli Íslands', '
{
	"established":1905,
    "principal":"Ingi Ólafsson",
    "headteacher":"Guðrún Inga Sívertsen",
    "motto":"Hæfni, Ábyrgð, Virðing, Vellíðan",
    "website":"http://www.verslo.is",
    "abbreviation":["versló", "VÍ"]
}
');


DROP PROCEDURE IF EXISTS getAllSchoolInfo;
DELIMITER //

CREATE PROCEDURE getAllSchoolInfo()
BEGIN

    DECLARE j JSON;
    DECLARE single_keys JSON;
    DECLARE js_keys JSON;
    DECLARE i int default 0;
    DECLARE statement TEXT default 'SELECT schoolName';
	DECLARE v_finished INTEGER DEFAULT 0;

	DEClARE json_cursor CURSOR FOR 
		SELECT schoolInfo FROM Schools;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;
        
	SET js_keys = JSON_ARRAY();
    
	OPEN json_cursor;
		json_loop: LOOP
	 
			FETCH json_cursor INTO j;
            
			IF v_finished = 1 THEN 
				LEAVE json_loop;
			END IF;
            
            SET i = JSON_LENGTH(JSON_KEYS(j));
            SET single_keys = JSON_KEYS(j);
            
            WHILE i > 0 DO
				SET i = i - 1;
				
				IF JSON_CONTAINS(js_keys, JSON_EXTRACT(single_keys, CONCAT('$[', i, ']'))) = 0 THEN
					SET js_keys = JSON_ARRAY_APPEND(js_keys, '$', JSON_EXTRACT(single_keys, CONCAT('$[', i, ']')));
				END IF;
			END WHILE;
        END LOOP json_loop;
	CLOSE json_cursor;
    
	SET i = JSON_LENGTH(js_keys);
	
	WHILE i > 0 DO
		SET i = i - 1;
        
        SET statement = CONCAT(statement, ',schoolinfo->\'$.', JSON_EXTRACT(js_keys, CONCAT('$[', i, ']')), '\' as ', JSON_EXTRACT(js_keys, CONCAT('$[', i, ']')));
		
	END WHILE;
    
	SET statement = CONCAT(statement, 'from Schools');
    SET @statement = statement;
    PREPARE stmt1 FROM @statement;
    EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;
	
END//

DELIMITER ;

call getAllSchoolInfo();