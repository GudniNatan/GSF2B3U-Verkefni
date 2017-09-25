/* 1 */
/* Required table and test data

create table Students
(
	studentID char(10), -- kennitala
    studentName varchar(255),
    trackID int, 
    constraint studentID primary key(studentID),
	constraint student_track_FK foreign key(trackID) references Tracks(trackID)
);

INSERT INTO Students(studentID, studentName, trackID)
VALUES
('1803982879', 'Guðni Natan Gunnarsson', 9);

*/

/* 2 */
DROP TRIGGER IF EXISTS trg_no_self_dependency_insert;
DELIMITER //
CREATE TRIGGER trg_no_self_dependency_insert BEFORE INSERT 
ON Restrictors
FOR EACH ROW
BEGIN
	IF NEW.courseNumber = NEW.restrictorID THEN
		-- THROW ERROR
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Restrictor can\'t be self dependant.';
    END IF;
END//
DELIMITER ;

/* Testing

insert into Restrictors 
values
('GSF2B3U', 'GSF2B3U', 1);

*/


/* 3 */
DROP TRIGGER IF EXISTS trg_no_self_dependency_update;
DELIMITER //
CREATE TRIGGER trg_no_self_dependency_update BEFORE UPDATE 
ON Restrictors
FOR EACH ROW
BEGIN
	IF NEW.courseNumber = NEW.restrictorID THEN
		-- THROW ERROR
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Restrictor can\'t be self dependant.';
    END IF;
END//
DELIMITER ;

/* Testing

UPDATE Restrictors
SET restrictorID = 'GSF2B3U'
WHERE courseNumber = 'GSF2B3U';

*/


/* 4 */
/* Table and test data

create table StudentCourses
(
	ID int auto_increment,
    studentID char(10), -- kennitala
    semesterID INT null,
    courseNumber char(10),
    grade tinyint null,
    constraint ID primary key(ID),
	constraint SC_course_FK foreign key(courseNumber) references Courses(courseNumber),
	constraint SC_student_FK foreign key(studentID) references Students(studentID),
	constraint SC_semester_FK foreign key(semesterID) references Semesters(semesterID)
);

INSERT INTO StudentCourses(studentID, courseNumber, grade, semesterID)
VALUES
('1803982879', 'GSF2A3U', 10, 1),
('1803982879', 'GSF3B3U', 10, 2),
('1803982879', 'FOR3G3U', 10, 1),
('1803982879', 'FOR3L3U', 10, 2),
('1803982879', 'FOR3D3U', 10, 4),
('1803982879', 'STÆ103', 9, 1),
('1803982879', 'STÆ203', 10, 2),
('1803982879', 'EÐL103', 8, 1),
('1803982879', 'EÐL203', 6, 2),
('1803982879', 'EÐL303', 3, 3);

*/


DROP PROCEDURE IF EXISTS StudentProgress;
DELIMITER //

CREATE PROCEDURE StudentProgress(IN sID char(10))
BEGIN
    SELECT Tracks.trackName, sum(Courses.courseCredits) as totalCredits
    FROM StudentCourses
    INNER JOIN Courses
    ON StudentCourses.courseNumber = Courses.courseNumber
	INNER JOIN TrackCourses
    ON Courses.courseNumber = TrackCourses.courseNumber
	INNER JOIN Tracks
    ON TrackCourses.trackID = Tracks.trackID
    INNER JOIN Students
    ON Students.studentID = StudentCourses.studentID
    WHERE StudentCourses.grade >= 5 AND StudentCourses.studentID = sID
    GROUP BY Tracks.trackName;
END//

DELIMITER ;
	
    
/* Test
call StudentProgress('1803982879');
*/

/* 5 */
-- Adds all required courses to the StudentCourses table, set to be taken during the next semester from now.
-- At the time of writing that semester is 6. 'Vor2018'
-- If the course has a labeled semester number, that number will be added to the semester.
-- For example, 'FOR3D3U' has been labeled semester 4. The next semester is #6 (as of writing), so it will be placed in the total 10th semester 
DROP PROCEDURE IF EXISTS AddMandtoryCourses;
DELIMITER //

CREATE PROCEDURE AddMandtoryCourses(IN sID char(10))
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_trackID INT;
    DECLARE v_course_id CHAR(10);
    DECLARE next_semester INT;
    DECLARE semester_offset INT;
	DEClARE course_cursor CURSOR FOR 
		SELECT courseNumber FROM TrackCourses
			WHERE trackID = v_trackID AND mandatory = 1;
            
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;

	SELECT trackID INTO v_trackID
		FROM Students;
    
    SELECT semesterID INTO next_semester
    FROM Semesters
    WHERE CURDATE() < semesterStarts
    LIMIT 1;
    
	
	START TRANSACTION;
	OPEN course_cursor;
		insert_course: LOOP
	 
			FETCH course_cursor INTO v_course_id;
            
			IF v_finished = 1 THEN 
				LEAVE insert_course;
			END IF;
             
            SELECT COALESCE(semester, 0) INTO semester_offset
				FROM TrackCourses
                WHERE courseNumber = v_course_id;
            
            INSERT INTO StudentCourses(studentID, courseNumber, semesterID)
            VALUES
            (sID, v_course_id, next_semester + semester_offset);
            
		
        END LOOP insert_course;
	CLOSE course_cursor;
	COMMIT;
END//

DELIMITER ;

/* Tests

call AddMandtoryCourses('1803982879');

select * from StudentCourses;
*/

DROP PROCEDURE IF EXISTS NewStudent;
DELIMITER //

CREATE PROCEDURE NewStudent(IN sID char(10), IN sName char(255), IN tID int)
BEGIN
	INSERT INTO Students(studentID, studentName, trackID)
	VALUES
	(sID, sName, tID);
    
    call AddMandtoryCourses(sID);

END//

DELIMITER ;

/* Tests

call NewStudent('1803982879', 'Guðni Natan Gunnarsson', 9);

*/

select * from Divisions
where divisionID = 11;
