-- psql -U postgres -h localhost

CREATE DATABASE emergency_room;
    
    -- \c emergency_room

    CREATE TABLE Doctors (
        doc_id INT PRIMARY KEY,
        specialization VARCHAR (50) NOT NULL,
        doc_name VARCHAR (50) NOT NULL,
        doc_surname VARCHAR (50) NOT NULL
    );

    CREATE TABLE Patients (
        patient_id INT PRIMARY KEY,
        patient_name VARCHAR (50) NOT NULL,
        patient_surname VARCHAR (50) NOT NULL,
        date_of_birth DATE NOT NULL
    );

    
    CREATE TABLE ExaminationsRooms (
        room_id INT PRIMARY KEY,
        doc INT REFERENCES Doctors(doc_id)
    );


    CREATE TABLE Reservations (
        reservation_id INT PRIMARY KEY,
        date_time TIMESTAMP NOT NULL,
        reservation_priority VARCHAR (10) NOT NULL,
        list_number INT NOT NULL,
        patient INT REFERENCES Patients(patient_id),
        room INT REFERENCES ExaminationsRooms(room_id)
    );

CREATE OR REPLACE FUNCTION red_priority() RETURNS TRIGGER AS $$
DECLARE x INT;
BEGIN

    x := Count(*) FROM Reservations WHERE room=new.room;
	
    IF new.reservation_priority = 'RED' THEN
        UPDATE Reservations
        SET list_number = list_number + 1
        WHERE (room = new.room);
		   
        UPDATE Reservations
        SET list_number = 1
        WHERE (reservation_id = new.reservation_id);	
    ELSE
	   UPDATE Reservations
       SET list_number = x
	   WHERE(reservation_id = new.reservation_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER after_insert_Reservations
AFTER INSERT ON Reservations
FOR EACH ROW
EXECUTE FUNCTION red_priority();
    
INSERT INTO Doctors VALUES

(1, 'Cardiologist', 'John', 'Doe'),
(2, 'Orthopedic Surgeon', 'Jane', 'Smith'),
(3, 'Pediatrician', 'Michael', 'Johnson'),
(4, 'Dermatologist', 'Emily', 'Brown'),
(5, 'Neurologist', 'Daniel', 'Taylor'),
(6, 'Ophthalmologist', 'Sophia', 'Clark'),
(7, 'General Surgeon', 'David', 'Wilson'),
(8, 'Gynecologist', 'Olivia', 'Miller'),
(9, 'ENT Specialist', 'William', 'Anderson'),
(10, 'Orthodontist', 'Ava', 'Thomas');


INSERT INTO Patients VALUES

  (1, 'Alice', 'Johnson', '1990-03-10'),
  (2, 'Bob', 'Williams', '1985-07-25'),
  (3, 'Emily', 'Davis', '1995-12-05'),
  (4, 'Jack', 'Anderson', '1982-09-15'),
  (5, 'Sophie', 'Miller', '1998-04-30'),
  (6, 'Noah', 'Smith', '1987-11-22'),
  (7, 'Ava', 'Wilson', '1993-06-18'),
  (8, 'Ethan', 'Brown', '1980-02-14'),
  (9, 'Emma', 'Taylor', '1991-08-05'),
  (10, 'Liam', 'Clark', '1984-05-20');


INSERT INTO ExaminationsRooms
VALUES
  (1, 2),
  (2, 1),
  (3, 3),
  (4, 5),
  (5, 6),
  (6, 8)
  (7, 8);




INSERT INTO Reservations
VALUES
    (1, '2024-01-17 10:00:00', 'RED', 1, 1, 1),
    (2, '2024-01-18 11:30:00', 'GREEN', 1, 2, 2),
    (3, '2024-01-19 14:15:00', 'RED', 2, 3, 1),
    (4, '2024-01-20 09:45:00', 'YELLOW', 2, 4, 2),
    (7, '2024-01-20 09:45:00', 'WHITE', 2, 4, 1),
    (6, '2024-01-20 09:45:00', 'YELLOW', 2, 4, 1),
    (5, '2024-01-17 10:00:00', 'RED', 1, 1, 1);

  



