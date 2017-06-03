USE [Conferensions]
GO
/****** Object:  StoredProcedure [dbo].[AddClient]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje klienta
-- =============================================
CREATE PROCEDURE [dbo].[AddClient]
	@Name varchar(50),
	@Phone varchar(50),
	@Email varchar(50),
	@Login varchar(50),
	@City varchar(50),
	@Region varchar(50),
	@Address varchar(50),
	@Password varchar(50),
	@IsCompany bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Clients(Name, Phone, Email, Login, City, Region, Address, Password, IsCompany)
			VALUES(@Name, @Phone, @Email, @Login, @City, @Region, @Address, @Password, @IsCompany)
END
GO

/****** Object:  StoredProcedure [dbo].[AddConference]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje konferencje
-- =============================================
CREATE PROCEDURE [dbo].[AddConference] 
	@Title text,
	@City varchar(50),
    @Region varchar(50),
	@Address varchar(50),
	@StartDate datetime,
	@DaysQuantity int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Conferences(Title, City, Region, Address, StartDate, DaysQuantity)
			VALUES(@Title, @City, @Region, @Address, @StartDate, @DaysQuantity)
END
GO

/****** Object:  StoredProcedure [dbo].[AddConferenceDay]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje dzien konferencji
-- =============================================
CREATE PROCEDURE [dbo].[AddConferenceDay] 
	@ConferenceId int,
	@DayNumber int	,
	@PlacesQuantity int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO ConferenceDay(ConferenceID, DayNumber, PlacesQuantity)
			VALUES(@ConferenceId, @DayNumber, @PlacesQuantity)
END
GO

/****** Object:  StoredProcedure [dbo].[AddParticipant]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje uczestnika
-- =============================================
CREATE PROCEDURE [dbo].[AddParticipant]
	@CompanyID int,
	@FirstName varchar(50),
	@LastName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Participants(CompanyID,FirstName,LastName)
			VALUES(@CompanyID,@Firstname,@Lastname)
END
GO

/****** Object:  StoredProcedure [dbo].[AddPayment]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaj p³atnoœæ
-- =============================================
CREATE PROCEDURE [dbo].[AddPayment]
	@Paid money,
	@ReservationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Payments(Paid,FeeDate,ReservationID)
			VALUES(@Paid,GETDATE(),@ReservationId)
END
GO

/****** Object:  StoredProcedure [dbo].[AddPrice]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje prog cenowy do Prices
-- =============================================
CREATE PROCEDURE [dbo].[AddPrice]
    @ConferenceDayId int,
	@Price money,
	@ExpiryDate date,	
	@StudentDiscount decimal(4,2)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Prices(ConferenceDayID, Price, ExpiryDate, StudentDiscount)
			VALUES(@ConferenceDayId,@Price,@ExpiryDate,@StudentDiscount)
END
GO

/****** Object:  StoredProcedure [dbo].[AddStudentData]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje studenta
-- =============================================
CREATE PROCEDURE [dbo].[AddStudentData] 
	@ParticipantID int,
	@StudentCardID varchar(50),
	@ExpiryDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Students(ParticipantID, StudentCardID, ExpiryDate)
		VALUES (@ParticipantID, @StudentCardID, @ExpiryDate)
END

GO

/****** Object:  StoredProcedure [dbo].[AddWorkshop]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaje warsztaty
-- =============================================
CREATE PROCEDURE [dbo].[AddWorkshop]
	@EventDescription text,
	@ConferenceDayID int,
	@EventStartTime datetime,
	@EventEndTime datetime,
	@EventPrice money,
	@PlacesQuantity int,
	@StudentDiscount decimal(4,2),
	@Address varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO Workshops(EventDescription, ConferenceDayID, EventStartTime, EventEndTime, EventPrice, PlacesQuantity, StudentDiscount, Address)
			VALUES(@EventDescription, @ConferenceDayID, @EventStartTime, @EventEndTime, @EventPrice, @PlacesQuantity, @StudentDiscount, @Address)
END
GO

/****** Object:  StoredProcedure [dbo].[ReservePlacesForConferenceDay]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Rezerwuje miejsca na dzieñ konferencji
-- =============================================
CREATE PROCEDURE [dbo].[ReservePlacesForConferenceDay] 
	@ClientId int,
	@ConferenceDayId int,
	@PlacesQuantity int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	INSERT INTO ConferenceReservations(ClientID, ConferenceDayID, PlacesReserved, ReservationDate)
		VALUES(@ClientId, @ConferenceDayId, @PlacesQuantity, GETDATE())
END
GO

/****** Object:  StoredProcedure [dbo].[ReservePlacesForWorkshop]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Rezerwuje miejsce na warsztat
-- =============================================
CREATE PROCEDURE [dbo].[ReservePlacesForWorkshop]
	@PlacesReserved int,
	@ConferenceReservationDay int,
	@WorkshopId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		INSERT INTO WorkshopsReservations(PlacesReserved, ReservationDate, WorkshopID, ConferenceReservationDay)
			VALUES(@PlacesReserved, GETDATE(), @WorkshopId, @ConferenceReservationDay)
END
GO

/****** Object:  StoredProcedure [dbo].[CancelConferenceDayReservation]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski	
-- Description:	Anulowanie ca³ej rezerwacji na dany dzieñ konferencji
--				zawiera tak¿e anulowanie rezerwacji na warsztaty na dany dzieñ
-- =============================================
CREATE PROCEDURE [dbo].[CancelConferenceDayReservation] 
	@ConferenceReservationDay int,
	@CencellationReason text
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF not exists(SELECT * FROM ConferenceReservations
					WHERE ConferenceReservations.ReservationID = @ConferenceReservationDay)
	BEGIN
		DECLARE @message varchar(100) = 'Cannot cancel conference day booking '+@ConferenceReservationDay+'. Reason: No such booking'
		;THROW 51000,@message,1
	END
	ELSE IF ((SELECT Cancelled FROM ConferenceReservations WHERE ReservationID = @ConferenceReservationDay) = 1)
	BEGIN
		;THROW 52000,'This booking has already been cancelled.',1
	END
	ELSE
		DECLARE @WorkshopReservationID int
		DECLARE curs CURSOR LOCAL FOR	SELECT WorkshopsReservations.ReservationID 
									 	 FROM WorkshopsReservations
										 WHERE WorkshopsReservations.ConferenceReservationDay = @ConferenceReservationDay
		OPEN curs
		BEGIN TRY
			BEGIN TRAN
			--Preparing data to cancel
			
	
			--Deleting each workshop booking
			
				FETCH NEXT FROM curs INTO @WorkshopReservationID

				WHILE @@FETCH_STATUS = 0 BEGIN
					BEGIN TRY 
						exec CancelWorkshopBooking @WorkshopReservationID, @CencellationReason
					END TRY
					BEGIN CATCH
						PRINT 'It seems that booking '+@WorkshopReservationID+' has been removed from database. During cancelling operation'
					END CATCH

					FETCH NEXT FROM curs INTO @WorkshopReservationID
				END
			

	
				--=========================
				--cancelling ConferenceDayReservations
				--=========================
			
				UPDATE ConferenceReservations
					SET Cancelled = 1,
						CencellationReason = @CencellationReason,
						CencellationDate = GETDATE()
					WHERE ReservationID = @ConferenceReservationDay

				CLOSE curs
				DEALLOCATE curs
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			CLOSE curs
			DEALLOCATE curs
			print error_message()
			ROLLBACK TRANSACTION
		END CATCH
END

GO

/****** Object:  StoredProcedure [dbo].[CancelWorkshopBooking]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Anulowanie warsztatow
-- =============================================
CREATE PROCEDURE [dbo].[CancelWorkshopBooking] 
	@ReservationID int,
	@CencellationReason text
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		IF((SELECT Cancelled FROM WorkshopsReservations WHERE ReservationID = @ReservationID)=1)
		BEGIN
			;THROW 52000,'This booking has already been cancelled',1
		END
		ELSE
			BEGIN TRY
				BEGIN TRAN
					UPDATE WorkshopsReservations
						SET WorkshopsReservations.Cancelled = 1,
							WorkshopsReservations.CencellationReason = @CencellationReason,
							WorkshopsReservations.CencellationDate = GETDATE()
						WHERE WorkshopsReservations.ReservationID = @ReservationID
				COMMIT
			END TRY
			BEGIN CATCH
				print error_message()
				ROLLBACK TRANSACTION
			END CATCH
END

GO

/****** Object:  StoredProcedure [dbo].[CancelUnapaidConferenceDayBookings]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Anulowanie niezaplaconych rezerwacji konferencji
-- =============================================
CREATE PROCEDURE [dbo].[CancelUnapaidConferenceDayBookings]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE curs CURSOR LOCAL FOR (SELECT CR.ReservationID, CR.ReservationDate FROM ConferenceReservations as CR
									inner join Payments as P ON (CR.ReservationID = P.ReservationID) 
									AND (P.Paid < ((SELECT EventPrice FROM Workshops AS W)+(SELECT Price FROM Prices)))
									where CR.Cancelled = 0 )
	
	/*(SELECT CI.booking_id, CI.booking_date
											FROM ConferenceDayPayingInfo as CI
											LEFT OUTER JOIN PaymentsDiffInfo as PAI
												ON (CI.booking_id = PAI.[Conference day booking id])AND(PAI.[Paid money] < (CI.[Conference day act price]+CI.[Workshops act price]))
											INNER JOIN Conference_day_bookings as CD
												ON (CI.booking_id = CD.booking_id)AND((CD.cancelled = 0)))*/
	DECLARE @ReservationID int, @ReservationDate datetime

	OPEN curs
		FETCH NEXT FROM curs INTO @ReservationID, @ReservationDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(DATEDIFF(day,@ReservationDate,GETDATE()) > 7)
			BEGIN
				exec CancelConferenceDayReservation @ReservationID, 'Minimum payment was not received in 7 days. Or no place has been booked.'
			END
			FETCH NEXT FROM curs INTO @ReservationID, @ReservationDate
		END
	CLOSE curs
	DEALLOCATE curs
END
GO


/****** Object:  StoredProcedure [dbo].[ChangeNumberOfBookedPlacesForWorkshop]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Prodedura do zmiany zarezerwowanych miejsc na warsztat
-- =============================================
CREATE PROCEDURE [dbo].[ChangeNumberOfReservedPlacesForWorkshop]
	@ReservationID int,
	@PlacesReserved int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE WorkshopsReservations
		SET PlacesReserved = @PlacesReserved
		WHERE ReservationID = @ReservationID	
END
GO

/****** Object:  StoredProcedure [dbo].[ExtendPlacesAmountForConferenceDay]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Extending number of places available to book for conference day
-- =============================================
CREATE PROCEDURE [dbo].[ExtendPlacesAmountForConferenceDay] 
	-- Add the parameters for the stored procedure here
	@ConferenceDayID int,
	@PlacesQuantity int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@PlacesQuantity <= (SELECT PlacesQuantity FROM ConferenceDay WHERE ConferenceDayID = @ConferenceDayId))
	BEGIN
		;THROW 52000,'You can only extend number places for conference day',1
	END
    -- Insert statements for procedure here
	ELSE
		UPDATE ConferenceDay
			SET PlacesQuantity = @PlacesQuantity
			WHERE ConferenceDayID = @ConferenceDayId
END
GO

/****** Object:  StoredProcedure [dbo].[ExtendPlacesAmountForWorkshop]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Zwieksza ilosc dostepnych miejsc do zarezerwowania na warsztat
-- =============================================
CREATE PROCEDURE [dbo].[ExtendPlacesAmountForWorkshop]
	-- Add the parameters for the stored procedure here
	@WorkshopID int,
	@PlacesQuantity int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@PlacesQuantity <= (SELECT PlacesQuantity FROM Workshops WHERE WorkshopID = @WorkshopId))
	BEGIN
		;THROW 52000,'You can only extend number places for workshop.',1
	END
    -- Insert statements for procedure here
	ELSE
		UPDATE Workshops
			SET PlacesQuantity = @PlacesQuantity
			WHERE WorkshopID = @WorkshopId
END

GO

/****** Object:  StoredProcedure [dbo].[NarrowDownNumberOfBookedPlacesForConferenceDay]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Changes the number of booked places for conference day
-- =============================================
CREATE PROCEDURE [dbo].[NarrowDownNumberOfBookedPlacesForConferenceDay]
	@ConferenceReservationDay int,
	@PlacesQuantity int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF((SELECT PlacesReserved FROM ConferenceReservations WHERE ReservationID = @ConferenceReservationDay) < @PlacesQuantity)
	BEGIN
		;THROW 52000, 'You can onnly narrow down the number of places reserved for conference_day. If you want to add places. Please add a new booking.',1
	END
	ELSE
	BEGIN
		UPDATE ConferenceReservations
			SET PlacesReserved = @PlacesQuantity
			WHERE ReservationID = @ConferenceReservationDay
	END
END
GO

/****** Object:  StoredProcedure [dbo].[RemoveParticipantReservationForConferenceDay]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Usuwa uczestnika z rezerwacji na konferencje
-- =============================================
CREATE PROCEDURE [dbo].[RemoveParticipantReservationForConferenceDay]
	@ReservationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
			DELETE FROM WorkshopsReservations
				WHERE ConferenceReservationDay = @ReservationId

			DELETE FROM ConferenceReservations
				WHERE ReservationID = @ReservationId
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK TRANSACTION
	END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[RemoveParticipantReservationForWorkshop]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Usuwa uczestnika z rezerwacji na warsztat
-- =============================================
CREATE PROCEDURE [dbo].[RemoveParticipantReservationForWorkshop]
	@ReservationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
			DELETE FROM WorkshopsReservations
				WHERE ReservationID = @ReservationId
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK TRANSACTION
	END CATCH
END

GO

/****** Object:  StoredProcedure [dbo].[UnCancelWorkshopBooking]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Odanulowanie rezerwacji na warsztat
-- =============================================
CREATE PROCEDURE [dbo].[UnCancelWorkshopBooking] 
	@ReservationID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF((SELECT Cancelled FROM WorkshopsReservations WHERE ReservationID = @ReservationID) = 0)
	BEGIN
		;THROW 52000,'This booking is active.',1
	END
	ELSE
		UPDATE WorkshopsReservations
			SET WorkshopsReservations.Cancelled = 0,
				WorkshopsReservations.CencellationReason = null,
				WorkshopsReservations.CencellationDate = null
			WHERE WorkshopsReservations.ReservationID = @ReservationID
END


