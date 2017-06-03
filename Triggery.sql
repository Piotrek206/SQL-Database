--====================================
-- Author:		Piotr Jaworski
-- Description:	Sprawdza, czy nie zosta³ przekroczony limit osob w dniu konferencji.
--====================================
USE Conferensions
GO

CREATE TRIGGER LimitOfParticipantsOnConference
ON ConferenceReservations
AFTER INSERT,UPDATE AS
BEGIN
IF EXISTS (SELECT CR.ConferenceDayID FROM ConferenceReservations AS CR INNER JOIN ConferenceDay AS CD
			ON CR.ConferenceDayID = CD.ConferenceDayID WHERE (CD.PlacesQuantity-(
			SELECT SUM(CR2.PlacesReserved) FROM ConferenceReservations AS CR2 GROUP BY CR2.ConferenceDayID))<=0)
BEGIN
RAISERROR ('Nie mozna wpisac wiecej osob na ta konferencje.', 16, 1)
ROLLBACK TRANSACTION
END
END


--====================================
-- Author:		Piotr Jaworski
-- Description:	Sprawdza, czy nie zosta³ przekroczony limit osob na warsztat.
--====================================
GO

CREATE TRIGGER LimitOfParticipantsOnWorkshop
ON WorkshopsReservations
AFTER INSERT,UPDATE AS
BEGIN
IF EXISTS (SELECT WR.WorkshopID FROM WorkshopsReservations AS WR INNER JOIN Workshops AS W ON
			WR.WorkshopID = W.WorkshopID WHERE (W.PlacesQuantity-(SELECT SUM(WR2.PlacesReserved) FROM WorkshopsReservations AS WR2
			GROUP BY WorkshopID)<=0)
)
BEGIN
RAISERROR ('Nie mozna wpisac wiecej osob na ten warsztat.', 16, 1)
ROLLBACK TRANSACTION
END
END


--====================================
-- Author:		Piotr Jaworski
-- Description:	Sprawdza, czy ju¿ wp³acono wystarczaj¹c¹ kwotê, i nie przyjmuje kolejnych.
--====================================
GO

CREATE TRIGGER ControlPayments
ON Payments
AFTER INSERT,UPDATE AS
BEGIN
IF EXISTS (SELECT P.Paid FROM Payments AS P INNER JOIN ConferenceReservations AS CR ON P.ReservationID = CR.ReservationID
	INNER JOIN WorkshopsReservations AS WR ON P.ReservationID = WR.ReservationID 
	INNER JOIN Workshops AS W ON W.WorkshopID = WR.WorkshopID INNER JOIN ConferenceDay AS CD
	ON CR.ConferenceDayID = CD.ConferenceDayID INNER JOIN Prices AS PRC ON CD.ConferenceDayID = PRC.ConferenceDayID
    WHERE P.Paid >= ((PRC.Price+W.EventPrice)*(1-PRC.StudentDiscount)))
BEGIN
RAISERROR ('Juz oplacono wystarczajaca kwote.', 16, 1)
ROLLBACK TRANSACTION
END
END

--====================================
-- Author:		Piotr Jaworski
-- Description:	Sprawdza, czy nie probujemy dodac konferencji, ktora zaczyna sie w przeszlosci lub dzis
--====================================
GO
CREATE TRIGGER ForbidToSpecifyConferencesFromThePast
ON Conferences
AFTER INSERT,UPDATE AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from 
	-- interfering with SELECT statements. 
	SET NOCOUNT ON; 
	
	DECLARE @Date date = (SELECT StartDate FROM Conferences) 
	IF((DATEDIFF(day,GETDATE(),@Date) <= 0))
	BEGIN ;
	THROW 52000,'The conference is starting today or has already started! You can only specify future conferences.',1 
	ROLLBACK TRANSACTION 
END 
END

-- ============================================= 
-- Author: Piotr Jaworski 
-- Description: Sprawdzamy, czy dlugosc trwania warsztatu jest prawidlowa
-- ============================================= 
GO
CREATE TRIGGER StartHourBeforeEndHourWorkshops
ON Workshops
AFTER INSERT,UPDATE AS 
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from 
	-- interfering with SELECT statements. 
	SET NOCOUNT ON; 
	DECLARE @start time(0) = (SELECT EventStartTime FROM inserted) 
	DECLARE @end time(0) = (SELECT EventEndTime FROM inserted) 
	IF((SELECT DATEDIFF(minute,@start,@end))<5) 
	BEGIN ;
	THROW 52000,'Workshop has to last at least 5 minutes.',1 
	ROLLBACK TRANSACTION 
	END 
END


-- ============================================= 
-- Author: Piotr Jaworski 
-- Description: Sprawdza czy ilosc miejsc na warsztat nie jest wieksza od ilosci na konferencje
-- ============================================= 
GO
CREATE TRIGGER WorkshopPlacessLessThanConferenceDayPlaces
ON Workshops
AFTER INSERT,UPDATE AS 
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from 
	-- interfering with SELECT statements. 
	SET NOCOUNT ON; 
	DECLARE @WorkshopPlaces int = (SELECT PlacesQuantity FROM inserted) 
	DECLARE @ConferenceDayPlaces int = (SELECT C.PlacesQuantity FROM inserted as I 
								INNER JOIN ConferenceDay as C ON I.ConferenceDayID = C.ConferenceDayID)
	IF(@WorkshopPlaces > @ConferenceDayPlaces) 
BEGIN ;
	THROW 52000,'For this workshop are more places than for conference day.',1 
	ROLLBACK TRANSACTION 
	END 
END


-- ============================================= 
-- Author: Piotr Jaworski 
-- Description: Blokuje transakcje jesli chcemy zarezerwowac za duzo miejsc
-- ============================================= 
GO
CREATE TRIGGER ForbidToBookPlacesForFullConferenceDay
ON ConferenceReservations
AFTER INSERT, UPDATE AS 
BEGIN 
	DECLARE @ConferenceDayId int = (SELECT ConferenceDayID FROM inserted) 
	IF (dbo.GetNumberOfFreePlacesForConferenceDay(@ConferenceDayId) < 0) 
	BEGIN 
	DECLARE @FreePlaces int = dbo.GetNumberOfFreePlacesForConferenceDay(@ConferenceDayId)
		+ (SELECT PlacesReserved FROM inserted) DECLARE @message varchar(100) = 'There are only '+
		CAST(@FreePlaces as varchar(10))+' places left for this conference day.' ;
	THROW 52000,@message,1 
	ROLLBACK TRANSACTION 
	END 
 END


 -- ============================================= 
 -- Author: Piotr Jaworski
 -- Description: sprawdza, czy nie chcemy dodac wiecej uczestnikow niz zarezerwowanych miejsc
 -- ============================================= 
 GO
 CREATE TRIGGER ForbidToOverreservePlacesForConferenceDay 
 ON ConferenceReservations
 AFTER INSERT, UPDATE AS 
 BEGIN 
	DECLARE @ConferenceDayBookingId int = (SELECT ReservationID FROM inserted) 
	DECLARE @PlacesBooked int = (SELECT PlacesReserved FROM ConferenceReservations WHERE ReservationID = @ConferenceDayBookingId) 
	 IF (@PlacesBooked < (SELECT COUNT(ReservationID) FROM ConferenceReservations 
		WHERE (ReservationID = @ConferenceDayBookingId))) 
	BEGIN ;
	THROW 53000, 'All places has been reserved for this booking',1
	ROLLBACK TRANSACTION 
	END 
 END




 -- ============================================= 
 -- Author: Piotr Jaworski
 -- Description: sprawdza, czy wszystkie dane w tabeli participants sa uzupelnione
 -- ============================================= 
 GO
 CREATE TRIGGER CheckInformationAboutParticipants
 ON Participants
 AFTER INSERT, UPDATE AS 
 BEGIN 
	DECLARE @CompanyID int = (SELECT CompanyID from inserted) 
	DECLARE @FirstName nchar(10) = (SELECT FirstName FROM inserted where CompanyID = @CompanyID) 
	DECLARE @LastName nchar(10) = (SELECT LastName FROM inserted) 
	DECLARE @ConferenceStartDate datetime = (SELECT C.StartDate FROM ConferenceReservations AS CR INNER JOIN ConferenceDay AS CD 
										ON CR.ConferenceDayID = CD.ConferenceDayID INNER JOIN Conferences AS C ON CD.ConferenceID = C.ConferenceID)
	 IF (GETDATE() - @ConferenceStartDate  <= 7 AND @CompanyID IS NULL AND @FirstName IS NULL AND @LastName IS NULL)
	BEGIN ;
	THROW 53000, 'Please fullfill information about participant',1
	ROLLBACK TRANSACTION 
	END 
 END




/*
IF EXISTS(
  SELECT *
    FROM sys.triggers
   WHERE name = N'<trigger_name, sysname, table_alter_drop_safety>'
     AND parent_class_desc = N'DATABASE'
)
	DROP TRIGGER <trigger_name, sysname, table_alter_drop_safety> ON DATABASE
GO

CREATE TRIGGER <trigger_name, sysname, table_alter_drop_safety> ON DATABASE 
	FOR <data_definition_statements, , DROP_TABLE, ALTER_TABLE> 
AS 
IF IS_MEMBER ('db_owner') = 0
BEGIN
   PRINT 'You must ask your DBA to drop or alter tables!' 
   ROLLBACK TRANSACTION
END
GO*/