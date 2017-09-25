insert into Schools(schoolName) values('Tækniskólinn');

insert into Divisions(divisionName,schoolID)values('Byggingatækniskólinn',1);
insert into Divisions(divisionName,schoolID)values('Endurmenntunarskólinn',1);
insert into Divisions(divisionName,schoolID)values('Flugskóli Íslands',1);
insert into Divisions(divisionName,schoolID)values('Handverksskólinn',1);
insert into Divisions(divisionName,schoolID)values('Margmiðlunarskólinn',1);
insert into Divisions(divisionName,schoolID)values('Meistaraskólinn',1);
insert into Divisions(divisionName,schoolID)values('Raftækniskólinn',1);
insert into Divisions(divisionName,schoolID)values('Skipstjórnarskólinn',1);
insert into Divisions(divisionName,schoolID)values('Tækniakademían',1);
insert into Divisions(divisionName,schoolID)values('Tæknimenntaskólinn',1);
insert into Divisions(divisionName,schoolID)values('Upplýsingatækniskólinn',1);
insert into Divisions(divisionName,schoolID)values('Vefskólinn',1);
insert into Divisions(divisionName,schoolID)values('Véltækniskólinn',1);

insert into Tracks(trackName,divisionID)values('Almennt nám Upplýsingatækniskóla - AN UTN',11);
insert into Tracks(trackName,divisionID)values('Bókband',11);
insert into Tracks(trackName,divisionID)values('Grafísk miðlun',11);
insert into Tracks(trackName,divisionID)values('Grunnnám upplýsinga- og fjölmiðlagreina',11);
insert into Tracks(trackName,divisionID)values('K2 Tækni- og vísindaleiðin',11);
insert into Tracks(trackName,divisionID)values('Ljósmyndun',11);
insert into Tracks(trackName,divisionID)values('Prentun',11);
insert into Tracks(trackName,divisionID)values('Stúdentspróf',11);
insert into Tracks(trackName,validFrom,divisionID)values('Tölvubraut TBR16 - stúdentsbraut','2016-08-01',11);

insert into Courses(divisionID, courseNumber,courseName,courseCredits)
values
(11, 'GSF2A3U','Gagnasafnsfræði I',3),
(11, 'GSF2B3U','Gagnasafnsfræði II',3),
(11, 'GSF3A3U','Gagnanotkun',3),
(11, 'GSF3B3U','Gagnagreining',3),
(11, 'FOR3G3U','Inngangur að leikjaforritun',3),
(11, 'FOR3L3U','Leikjaforritun',3),
(11, 'FOR3D3U','3D leikjaforritun',3),
(11, 'STÆ103','Inngangur að stærðfræði',3),
(10, 'STÆ203','Algebra',3),
(10, 'STÆ303','Rúmfræði',3),
(10, 'STÆ313','Tölfræði',3),
(10, 'STÆ403','Vektorar',3),
(10, 'STÆ503','Diffrun og Heildun',3),
(10, 'STÆ603','Stærðfræðigreining',3),
(10, 'EÐL103','Eðlisfræði I',3), 
(10, 'EÐL203','Eðlisfræði II',3),
(10, 'EÐL303','Eðlisfræði III',3),
(10, 'EÐL403','Eðlisfræði IV',3);

INSERT INTO TrackCourses(courseNumber, trackID)
VALUES
('GSF2A3U', 9),
('GSF2B3U', 9),
('GSF3A3U', 9),
('GSF3B3U', 9),
('FOR3G3U', 9),
('FOR3L3U', 9),
-- ('FOR3D3U', 9),
('STÆ103', 9),
('STÆ203', 9),
('STÆ303', 9),
('STÆ313', 9),
('STÆ403', 9),
('STÆ503', 9),
('STÆ603', 9),
('EÐL103', 9),
('EÐL203', 9),
('EÐL303', 9),
('EÐL403', 9);

INSERT INTO TrackCourses(courseNumber, trackID, semester)
VALUES
('FOR3D3U', 9, 4);

insert into Restrictors(courseNumber,restrictorID,restrictorType)values('GSF2B3U','GSF2A3U',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('GSF3A3U','GSF2B3U',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('GSF3A3U','GSF3B3U',2);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('GSF3B3U','GSF3A3U',3);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ203','STÆ103',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ303','STÆ203',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ303','STÆ313',2);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ313','STÆ203',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ403','STÆ303',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ503','STÆ403',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('STÆ603','STÆ503',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('EÐL103','STÆ103',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('EÐL203','EÐL103',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('EÐL303','EÐL203',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('EÐL403','EÐL303',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('FOR3G3U','STÆ403',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('FOR3L3U','FOR3G3U',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('FOR3L3U','EÐL203',1);
insert into Restrictors(courseNumber,restrictorID,restrictorType)values('FOR3L3U','FOR3D3U',2);


-- Added extras
create table Semesters
(
	semesterID int auto_increment,
    semesterName char(10) not null,
    semesterStarts date not null,
    semesterEnds date not null,
    academicYear char(10) null,
    constraint semester_PK primary key(semesterID)
);

insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2015','2015-08-01','2015-12-31','2015-2016');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2016','2016-01-01','2016-05-31','2015-2016');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2016','2016-08-01','2016-12-31','2016-2017');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2017','2017-01-01','2017-05-31','2016-2017');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2017','2017-08-01','2017-12-31','2017-2018');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2018','2018-01-01','2018-05-31','2017-2018');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2018','2018-08-01','2018-12-31','2018-2019');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2019','2019-01-01','2019-05-31','2018-2019');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2019','2019-08-01','2019-12-31','2019-2020');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2020','2020-01-01','2020-05-31','2019-2020');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2020','2020-08-01','2020-12-31','2020-2021');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2021','2021-01-01','2021-05-31','2020-2021');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Haust2021','2021-08-01','2021-12-31','2021-2022');
insert into Semesters(semesterName,semesterStarts,semesterEnds, academicYear)values('Vor2022','2022-01-01','2022-05-31','2021-2022');



create table Students
(
	studentID char(10), -- kennitala
    studentName varchar(255),
    trackID int, 
    constraint studentID primary key(studentID),
	constraint student_track_FK foreign key(trackID) references Tracks(trackID)
);


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

/* Test data, please use NewStudent procedure instead

INSERT INTO Students(studentID, studentName, trackID)
VALUES
('1803982879', 'Guðni Natan Gunnarsson', 9);

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



