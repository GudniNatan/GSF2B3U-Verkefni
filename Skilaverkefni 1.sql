-- Skilaverkefni 1

-- Stored procedures


/* 1 */

DROP PROCEDURE IF EXISTS CourseList;
DELIMITER //

CREATE PROCEDURE CourseList()
BEGIN
	SELECT *
    FROM courses;

END//

DELIMITER ;


call CourseList();


/* 2 */

DROP PROCEDURE IF EXISTS SingleCourse;
DELIMITER //

CREATE PROCEDURE SingleCourse(IN cNum char(10))
BEGIN
	SELECT *
    FROM courses
    WHERE courseNumber = cNum;

END//

DELIMITER ;


call SingleCourse('GSF3B3U');


/* 3 */

DROP PROCEDURE IF EXISTS NewCourse;
DELIMITER //

CREATE PROCEDURE NewCourse(IN cNum char(10), IN cName VARCHAR(75), IN cCredits tinyint(4), OUT number_of_inserted_rows INT)
BEGIN
	insert into Courses(courseNumber,courseName,courseCredits)
	values(cNum, cName, cCredits);
    SELECT ROW_COUNT() INTO number_of_inserted_rows;
END//

DELIMITER ;

set @number = 0;

call NewCourse('VSH3A3U', 'Vefhönnun', 2, @number);

select @number;


/* 4 */
DROP PROCEDURE IF EXISTS UpdateCourse;
DELIMITER //

CREATE PROCEDURE UpdateCourse(IN cNum char(10), IN cName VARCHAR(75), IN cCredits tinyint(4), OUT number_of_altered_rows INT)
BEGIN
    UPDATE Courses
		SET courseName = cName, courseCredits = cCredits
        WHERE courseNumber = cNum;
    SELECT ROW_COUNT() INTO number_of_altered_rows;
END//

DELIMITER ;

set @number = 0;

call UpdateCourse('VSH3A3U', 'Vefþróun', 3, @number);

select @number;


/* 5 */
DROP PROCEDURE IF EXISTS DeleteCourse;
DELIMITER //

CREATE PROCEDURE DeleteCourse(IN cNum char(10), OUT number_of_deleted_rows INT)
BEGIN
	DECLARE existance INT;
    
    SET number_of_deleted_rows = 0 ;
    
    SELECT COUNT(*) INTO existance 
    FROM TrackCourses
    WHERE courseNumber = cNum;
    
	IF existance = 0 THEN 
		DELETE FROM Restrictors
			WHERE courseNumber = cNum;
		DELETE FROM Courses
			WHERE courseNumber = cNum;
		SELECT ROW_COUNT() INTO number_of_deleted_rows;
	END IF;
END//

DELIMITER ;

set @number = 0;

call DeleteCourse('VSH3A3U', @number);

select @number;

INSERT INTO TrackCourses(trackID, courseNumber, semester, mandatory)
VALUES (9, 'GSF3B3U', 6, 0);

set @number = 0;

call DeleteCourse('GSF3A3U', @number);

select @number;


-- Functions

/* 6 */

DROP FUNCTION IF EXISTS NumberOfCourses;
DELIMITER //

CREATE FUNCTION NumberOfCourses() RETURNS INT
BEGIN
	DECLARE num INT;
    
    SELECT COUNT(*) INTO num
    FROM Courses;

	RETURN(num);
END//

DELIMITER ;

SELECT NumberOfCourses();


/* 7 */
DROP FUNCTION IF EXISTS TotalTRackCredits;
DELIMITER //

CREATE FUNCTION TotalTRackCredits(tID INT) RETURNS INT
BEGIN
	DECLARE num INT;
    
    SELECT COUNT(*) INTO num
    FROM TrackCourses
    WHERE trackID = tID;

	RETURN(num);
END//

DELIMITER ;

SELECT TotalTRackCredits(9);


/* 8 */
