use Conferensions
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfFreePlacesForConferenceDay]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Zwraca liczbe pozostalych miejsc na dany dzien konferencji
-- =============================================
CREATE FUNCTION [dbo].[GetNumberOfFreePlacesForConferenceDay]
(
	@ConferenceDayID int=0
)
RETURNS int
AS
BEGIN
	IF not exists (SELECT ConferenceDay.ConferenceDayID
					FROM ConferenceDay
					WHERE ConferenceDay.ConferenceDayID = @ConferenceDayId)
	BEGIN
		RETURN 0
	END
	ELSE
	BEGIN
		-- Declare the return variable here
		DECLARE @FreePlaces int
		DECLARE curs CURSOR LOCAL FOR
			SELECT PlacesReserved
				FROM ConferenceReservations
				WHERE ConferenceDayID = @ConferenceDayId
		DECLARE @PlacesReserved int


		-- Get whole amount of free places
		SET @FreePlaces = (SELECT CD.PlacesQuantity
							FROM ConferenceDay as CD
							WHERE CD.ConferenceDayID = @ConferenceDayId)


		-- Substract booked places
		SET @PlacesReserved = (SELECT sum(PlacesReserved) 
								FROM ConferenceReservations
								WHERE (ConferenceDayID = @ConferenceDayId) AND (cancelled = 0)
								GROUP BY ConferenceDayID )

		IF(@PlacesReserved is not null)
			SET @FreePlaces -= @PlacesReserved
		END

	-- Return the result of the function
	RETURN @FreePlaces
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfFreePlacesForWorkshop]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski	
-- Description:	Zwraca liczbê wolnych miejsc na warsztaty
-- =============================================
CREATE FUNCTION [dbo].[GetNumberOfFreePlacesForWorkshop]
(
	@WorkshopID int
)
RETURNS int
AS
BEGIN
	IF not exists (SELECT WorkshopID
					FROM Workshops
					WHERE WorkshopID = @WorkshopId)
	BEGIN
		RETURN 0
	END
	ELSE
	BEGIN
		-- Get whole amount of free places
		DECLARE @FreePlaces int = (SELECT PlacesQuantity
									FROM Workshops
									WHERE WorkshopID = @WorkshopId)
		DECLARE curs CURSOR LOCAL FOR
			SELECT PlacesReserved
				FROM WorkshopsReservations
				WHERE WorkshopID = @WorkshopId
		DECLARE @PlacesReserved int

		-- Substract booked places
		SET @PlacesReserved = (SELECT sum(@PlacesReserved) 
								FROM WorkshopsReservations
								WHERE (WorkshopID = @WorkshopId) AND (cancelled = 0)
								GROUP BY WorkshopID )

		IF (@PlacesReserved is not null)
			SET @FreePlaces -= @PlacesReserved

		END

	-- Return the result of the function
	RETURN @FreePlaces
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPriceInfoIdForDate]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Zwraca ID ceny na dany dzien konferencji
-- =============================================
CREATE FUNCTION [dbo].[GetPriceIdForDate]
(
	@Date date,
	@ConferenceDayId int
)
RETURNS smallmoney
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PriceId smallmoney = (SELECT TOP 1 PriceID FROM Prices
									WHERE (ConferenceDayID = @ConferenceDayId) AND (DATEDIFF(day,@date,ExpiryDate) >= 0)
									ORDER BY ExpiryDate)

	-- Return the result of the function
	RETURN @PriceId

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPriceStageForDate]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Zwraca cene na dany dzien konferencji
-- =============================================
CREATE FUNCTION [dbo].[GetPriceStageForDate]
(
	@Date date,
	@ConferenceDayId int
)
RETURNS smallmoney
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Price smallmoney = (SELECT TOP 1 price FROM Prices
									WHERE (ConferenceDayID = @ConferenceDayId) AND (DATEDIFF(day,@date,ExpiryDate) >= 0)
									ORDER BY ExpiryDate)

	-- Return the result of the function
	RETURN @Price

END