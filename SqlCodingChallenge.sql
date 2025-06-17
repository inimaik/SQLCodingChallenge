--Q1 creating database

IF NOT EXISTS (select name from sys.databases where name='PetPals')
begin
create database PetPals;
print 'Database PetPals created';
end
else
begin
print 'Database "PetPals" already exists';
end 
go

use PetPals;
go

--Q2 creating all tables
if not exists ( select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME='pets' AND TABLE_TYPE='BASE TABLE')
BEGIN
create table pets (
PetID int identity(1,1) primary key ,
[Name] nvarchar(50) not null,    
Age int not null,        
Breed nvarchar(100) not null, 
[Type] nvarchar(50) not null,    
AvailableForAdoption bit not null)
print 'Table "pets" created';
END
ELSE
BEGIN
print 'Table already exists';
end

if not exists ( select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME='shelters' AND TABLE_TYPE='BASE TABLE')
BEGIN
create table shelters(
ShelterID int identity(10,1) Primary Key,
[Name] nvarchar(100) not null,
[Location] nvarchar(150) not null)
print 'Table "shelters" created';
END
ELSE
BEGIN
print 'Table already exists';
end


if not exists ( select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME='donations' AND TABLE_TYPE='BASE TABLE')
BEGIN
create table donations(
DonationID int identity(20,1) Primary Key,
DonorName nvarchar(50) not null,
DonationType nvarchar(50) not null,
DonationAmount decimal,
DonationItem nvarchar(50),
DonationDate datetime not null)
print 'Table "Donations" created';
END
ELSE
BEGIN
print 'Table already exists';
end

if not exists ( select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME='adoptionEvents' AND TABLE_TYPE='BASE TABLE')
BEGIN
create table adoptionEvents(
EventID int identity(30,1) Primary Key,
EventName nvarchar(100) not null,
EventDate datetime not null,
[Location] nvarchar(150) not null)
print 'Table "adoptionEvents" created';
END
ELSE
BEGIN
print 'Table already exists';
end

if not exists ( select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME='participants' AND TABLE_TYPE='BASE TABLE')
BEGIN
create table participants(
ParticipantID int identity(40,1) primary key,
ParticipantName nvarchar(50) not null,
ParticipantType nvarchar(50) not null,
EventID int not null,
Foreign Key (EventID) References adoptionEvents(EventID))
print 'Table "participants" created';
END
ELSE
BEGIN
print 'Table already exists';
end

--inserting values into all tables

INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption) VALUES 
('Buddy', 3, 'Labrador', 'Dog', 1),
('Whiskers', 2, 'Siamese', 'Cat', 1),
('Max', 5, 'Golden Retriever', 'Dog', 0),
('Luna', 1, 'Persian', 'Cat', 1);

INSERT INTO Donations (DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES 
('Alice', 'Cash', 500.00, NULL, '2025-06-10 10:30:00'),
('Bob', 'Item', NULL, 'Dog Food', '2025-06-12 14:15:00'),
('Charlie', 'Cash', 1000.00, NULL, '2025-06-15 09:00:00');

INSERT INTO AdoptionEvents (EventName, EventDate, Location) VALUES 
('Summer Pet Fair', '2025-07-01 10:00:00', 'Marina Park'),
('Adoptathon 2025', '2025-08-05 09:00:00', 'Cubbon Grounds'),
('Furry Friends Meet', '2025-09-10 11:00:00', 'Necklace Road Grounds');

INSERT INTO Shelters (Name, Location) VALUES
('Paw Haven', 'Chennai'),
('Fur Friends', 'Bangalore'),
('Safe Paws', 'Hyderabad'),
('John Doe','Chennai')

INSERT INTO Participants (ParticipantName, ParticipantType, EventID) VALUES 
('Paw Haven', 'Shelter', 30),
('Fur Friends', 'Shelter', 31),
('Safe Paws', 'Shelter', 30),
('John Doe', 'Adopter', 30),
('Priya Singh', 'Adopter', 31),
('Rahul Verma', 'Adopter', 32);

--Q3 check while creation whether the database or tables already exist. 

--Q4 primary key and foreign key created during table creation and rest were added according to query
alter table donations add shelterid int
constraint fk_donations_shelterid foreign key (shelterid) references shelters(shelterid)

ALTER TABLE pets
ADD shelterID INT CONSTRAINT FK_shelterid FOREIGN KEY (shelterID) REFERENCES Shelters(ShelterID);

alter table participants
add shelterid int constraint fk_partcipant_shelterid foreign key (shelterid) references shelters(shelterid)

--values were added for those columns in table

--adding shelterid in donations table for Q8
update donations set shelterid= 10 where donationid=20
update donations set shelterid= 11 where donationid=21
update donations set shelterid= 12 where donationid=22
insert into shelters values('Cat Guys','Chennai')

--add shelter id values to pet for Q9
update pets set shelterID=10 where petid=1
update pets set shelterId=11 where petid=2
update pets set shelterId=12 where petid=3
update pets set shelterId=10 where petid=4

--updating shelter id to participants to find shelter location from participants of adoption event for Q13
update participants set shelterid = 10 where participantname='Paw Haven';
update participants set shelterid = 11 where participantname='Fur Friends';
update participants set shelterid = 12 where participantname='Safe Paws';

--adding more data to get output for Q18
insert into pets values
('Buddy', 3, 'Labrador', 'Dog', 1, 10),
('Max', 2, 'Labrador', 'Dog', 0, 10),
('Lucy', 4, 'Persian', 'Cat', 1, 10),
('Bella', 1, 'Labrador', 'Dog', 1, 11),
('Charlie', 5, 'Beagle', 'Dog', 0, 10),
('Rocky', 2, 'Labrador', 'Dog', 1, 10);
('Rina',5,'Persian','Cat',1,null)

--Q5
select  name, age, breed, type from pets where 
AvailableForAdoption=1;

--Q6
declare @eventid int =30;
select participantname,participanttype
from participants p join adoptionevents a on a.eventid=p.eventid
where a.eventid = @eventid;

--Q7 created procedure in stored procedure file and called here
exec updateShelterWithId 17,'Paw Haven','Chennai' --invalid id
exec updateShelterWithId 10,'Paw Haven','Chennai' --valid id

--Q8 
select s.name as sheltername, isnull(sum(d.donationamount), 0) as totaldonationamount
from shelters s
left join donations d on s.shelterid = d.shelterid
group by s.name;

--Q9(no owner id in any table so shelterid is used to find if the pet is owned or not)
select  name, age, breed, type from pets where 
shelterId IS NOT NULL;

--Q10
select format(DonationDate,'yyyy-MM') AS MonthYear, SUM(DonationAmount) AS TotalDonations
from donations
group by format(DonationDate, 'yyyy-MM')

--Q 11
select distinct breed
from pets
where (age between 1 and 3) or (age > 5)

--Q12
select P.name AS PetName, S.name AS ShelterName
FROM Pets P JOIN shelters S ON P.shelterID = S.shelterID
WHERE P.AvailableForAdoption = 1;

--Q 13
select count(ParticipantID) AS TotalParticipants
from Participants
join AdoptionEvents ON Participants.EventID = AdoptionEvents.EventID
join shelters on shelters.shelterid=participants.shelterid
where shelters.Location = 'Chennai';

--Q14
select distinct Breed
from Pets
where Age BETWEEN 1 AND 5;

--Q15(not adopted pets since there is no ownerid used, availabilty for adoption and lack of shelter is used as criteria)
select  name, age, breed, type from pets where 
AvailableForAdoption=1 AND shelterid is  null


--Q16 adoption and user table was not mentioned to be created in sql schema given


--Q17
select S.Name AS ShelterName, COUNT(P.PetID) AS AvailablePets
FROM Shelters S
left join Pets P ON S.ShelterID = P.ShelterID AND P.AvailableForAdoption = 1
group by S.name

---Q18
SELECT p1.PetID, p2.PetID, p1.Breed, p1.ShelterID
FROM Pets p1 JOIN Pets p2 ON p1.Breed = p2.Breed AND p1.ShelterID = p2.ShelterID AND p1.PetID < p2.PetID;

--Q19
SELECT Shelters.Name AS ShelterName, AdoptionEvents.EventName
FROM Shelters
cross join AdoptionEvents

--Q20

select Top 1 s.Name AS ShelterName, count(p.PetID) AS AdoptedPetsCount
from Pets p
join Shelters s ON p.ShelterID = s.ShelterID
where p.AvailableForAdoption = 0
group by s.Name
order by AdoptedPetsCount DESC

