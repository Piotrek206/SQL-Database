use [Conferensions]
GO
/****** Object:  View [dbo].[ClientsThatDidntFullfilledTheirReservation]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
CREATE VIEW [dbo].[ClientsThatDidntFullfilledTheirReservation]
AS
SELECT        dbo.Clients.ClientID, dbo.Clients.Name, dbo.Clients.Phone, dbo.Clients.Email, dbo.Clients.IsCompany AS [Is company], 
                        dbo.ConferenceReservations.ReservationDate AS [Booking date], dbo.ConferenceReservations.PlacesReserved 
						AS [Places reserved]
FROM            dbo.Clients INNER JOIN
                         dbo.ConferenceReservations ON dbo.Clients.ClientID = dbo.ConferenceReservations.ClientID
						 INNER JOIN Participants AS P ON Clients.ClientID = P.ParticipantID
WHERE		  P.FirstName IS NULL OR P.LastName IS NULL OR P.CompanyID IS NULL OR Clients.Email IS NULL

GO

/****** Object:  View [dbo].[AvailableWorkshops]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
CREATE VIEW [dbo].[AvailableWorkshops]
AS
SELECT        C.Title AS 'Conference name', W.EventDescription AS 'Workshop Description', DATEADD(day, CD.DayNumber - 1, C.StartDate) 
						 AS 'Workshop date', C.Region+' '+C.City+' '+C.Address AS 'Conference place', 
                         W.Address AS 'Workshop place', W.EventStartTime, W.EventEndTime, dbo.GetNumberOfFreePlacesForWorkshop(W.WorkshopID)
						 AS 'Places left', W.EventPrice, W.StudentDiscount, 
                         W.WorkshopID, CD.ConferenceDayID, C.ConferenceID
FROM            dbo.Workshops AS W INNER JOIN
                         dbo.ConferenceDay AS CD ON W.ConferenceDayID = CD.ConferenceDayID INNER JOIN
                         dbo.Conferences AS C ON CD.ConferenceID = C.ConferenceID
WHERE        (dbo.GetNumberOfFreePlacesForWorkshop(W.WorkshopID) > 0)



GO
/****** Object:  View [dbo].[FVforClients]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
CREATE VIEW [dbo].[TotalPriceforClients]
AS
SELECT C.ClientID, CR.ReservationID, CR.PlacesReserved, 
	    CR.PlacesReserved*P.Price*(1-P.StudentDiscount)+WR.PlacesReserved*W.EventPrice*(1-W.StudentDiscount) AS 'Total'
FROM Clients AS C INNER JOIN ConferenceReservations AS CR ON C.ClientID = CR.ClientID
		INNER JOIN ConferenceDay AS CD ON CR.ConferenceDayID = CD.ConferenceDayID INNER JOIN Prices AS P ON CD.ConferenceDayID = P.ConferenceDayID
		INNER JOIN WorkshopsReservations AS WR ON CR.ReservationID = WR.ReservationID INNER JOIN Workshops AS W ON WR.WorkshopID = W.WorkshopID


GO
/****** Object:  View [dbo].[FVforClients]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
CREATE VIEW [dbo].[FVforClients]
AS
SELECT C.ConferenceID, C.Title, CR.ConferenceDayID, C.StartDate, (C.StartDate+CD.DayNumber) AS 'EndDate', P.Price,
		CR.ReservationID, CR.ReservationDate, P.StudentDiscount, P.PriceID, WR.PlacesReserved, WR.ConferenceReservationDay,
		W.EventPrice, W.EventStartTime, W.EventEndTime, W.EventPrice*(1-W.StudentDiscount)+P.Price*(1-P.StudentDiscount) AS 'Total'
FROM ConferenceReservations AS CR INNER JOIN ConferenceDay AS CD ON CR.ConferenceDayID = CD.ConferenceDayID 
		INNER JOIN Conferences AS C ON CD.ConferenceID = C.ConferenceID INNER JOIN Prices AS P ON CD.ConferenceDayID = P.ConferenceDayID
		INNER JOIN WorkshopsReservations AS WR ON CR.ReservationID = WR.ReservationID INNER JOIN Workshops AS W 
		ON WR.WorkshopID = W.WorkshopID WHERE P.ConferenceDayID = CR.ConferenceDayID
		and (P.ExpiryDate-CR.ReservationDate)>0 and CR.ReservationDate BETWEEN P.ExpiryDate-30 AND P.ExpiryDate
		




GO
/****** Object:  View [dbo].[ConferenceDayPayingInfo]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
CREATE VIEW [dbo].[ConferenceDayPayingInfo]
AS
SELECT        CR.ReservationID, C.ConferenceID, CR.ConferenceDayID, CR.ClientID, CR.ReservationDate, CR.PlacesReserved AS 'Places reserved', COUNT(CR.ReservationID) 
                         AS [Places assigned], COUNT(S.ParticipantID) AS Students, CAST(PRI.price * ((COUNT(CR.ReservationID) - COUNT(S.ParticipantID)) + COUNT(S.ParticipantID) 
                         * PRI.StudentDiscount) AS numeric(10, 2)) AS 'Conference day act price', dbo.GetPriceStageForDate(CR.ReservationDate, CR.ConferenceDayID) 
                         * CR.PlacesReserved AS 'Conference day max price'
FROM            dbo.ConferenceReservations AS CR INNER JOIN
                         dbo.ConferenceDay AS CD ON CR.ConferenceDayID = CD.ConferenceDayID INNER JOIN
                         dbo.Conferences AS C ON CD.ConferenceID = C.ConferenceID LEFT OUTER JOIN
                         dbo.Students AS S ON CR.ClientID = S.ParticipantID AND DATEDIFF(day, C.StartDate, S.ExpiryDate) >= 0 INNER JOIN
                         dbo.Prices AS PRI ON PRI.PriceID = dbo.GetPriceIdForDate(CR.ReservationDate, CR.ConferenceDayID) LEFT OUTER JOIN
                             (SELECT    CR.ReservationID AS ConferenceReservations
                               FROM     dbo.WorkshopsReservations INNER JOIN ConferenceReservations AS CR ON CR.ReservationID = WorkshopsReservations.ReservationID
                               GROUP BY CR.ReservationID) AS WR ON CR.ReservationID = WR.ConferenceReservations


GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[WorkshopReservationPayingInfo]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WorkshopReservationPayingInfo]
AS
SELECT        WR.ReservationID, WR.PlacesReserved, COUNT(WR.ReservationID) AS [Places assigned], W.EventPrice AS [Price for normal place], 
                         W.StudentDiscount, COUNT(S.ParticipantID) AS [Students included], CAST(W.EventPrice * ((COUNT(WR.ReservationID) - COUNT(S.ParticipantID)) 
                         + COUNT(S.ParticipantID) * (1 - W.StudentDiscount)) AS numeric(10, 2)) AS 'Price for reserved places', W.EventPrice * WR.PlacesReserved AS 'Price at the most'
FROM            dbo.WorkshopsReservations AS WR INNER JOIN
                         dbo.Workshops AS W ON WR.WorkshopID = W.WorkshopID INNER JOIN
                         dbo.ConferenceDay AS CD ON W.ConferenceDayID = CD.ConferenceDayID INNER JOIN
                         dbo.Conferences AS C ON CD.ConferenceID = C.ConferenceID INNER JOIN
						 dbo.ConferenceReservations AS CR ON CD.ConferenceDayID = CR.ConferenceDayID INNER JOIN
						 dbo.Clients AS CLT ON CR.ClientID = CLT.ClientID INNER JOIN
						 dbo.Participants AS PT ON CLT.ClientID = PT.ParticipantID INNER JOIN
						 dbo.Students AS S ON PT.ParticipantID = S.ParticipantID 
						 AND DATEDIFF(day, C.StartDate, S.ExpiryDate) >= 0
GROUP BY WR.ReservationID, WR.PlacesReserved, W.EventPrice, W.StudentDiscount


GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[ConferencePayingInfo]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ConferencePayingInfo]
AS
-- ============================================= 
-- Author: Piotr Jaworski 
-- =============================================
SELECT ClientID,ConferenceID, cast((sum([Conference day act price])+sum([Workshops act price])) as numeric(10,2)) 
		as 'Act price to pay for conference', cast((sum([Conference day max price])+sum([Workshops max price])) 
		as numeric(10,2)) as 'Max price to pay for conference'
FROM ConferenceDayPayingInfo 
GROUP BY ClientID,ConferenceID
