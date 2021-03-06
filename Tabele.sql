USE [master]
GO
/****** Object:  Database [Conferensions]    Script Date: 23.01.2016 19:35:32 ******/
CREATE DATABASE [Conferensions]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Conferensions', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Conferensions.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Conferensions_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Conferensions_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Conferensions] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Conferensions].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Conferensions] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Conferensions] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Conferensions] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Conferensions] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Conferensions] SET ARITHABORT OFF 
GO
ALTER DATABASE [Conferensions] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Conferensions] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Conferensions] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Conferensions] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Conferensions] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Conferensions] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Conferensions] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Conferensions] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Conferensions] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Conferensions] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Conferensions] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Conferensions] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Conferensions] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Conferensions] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Conferensions] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Conferensions] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Conferensions] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Conferensions] SET RECOVERY FULL 
GO
ALTER DATABASE [Conferensions] SET  MULTI_USER 
GO
ALTER DATABASE [Conferensions] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Conferensions] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Conferensions] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Conferensions] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Conferensions] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Conferensions]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 23.01.2016 19:35:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[IsCompany] [bit] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[Region] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ConferenceDay]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferenceDay](
	[ConferenceDayID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceID] [int] NOT NULL,
	[DayNumber] [int] NOT NULL,
	[PlacesQuantity] [int] NOT NULL,
 CONSTRAINT [PK_ConferenceDay] PRIMARY KEY CLUSTERED 
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConferenceReservations]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferenceReservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[PlacesReserved] [int] NOT NULL,
	[ReservationDate] [datetime] NOT NULL,
	[CencellationDate] [datetime] NULL,
	[CencellationReason] [text] NULL,
	[Cancelled] [bit] NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Conferences]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Conferences](
	[ConferenceID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [text] NOT NULL,
	[City] [varchar](50) NOT NULL,
	[Region] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[DaysQuantity] [int] NOT NULL,
 CONSTRAINT [PK_Conference] PRIMARY KEY CLUSTERED 
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Participants]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participants](
	[ParticipantID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[FirstName] [nchar](10) NOT NULL,
	[LastName] [nchar](10) NOT NULL,
 CONSTRAINT [PK_ConferenceDetails] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payments]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[Paid] [money] NULL,
	[FeeDate] [datetime] NULL,
	[ReservationID] [int] NOT NULL,
 CONSTRAINT [PK_Payments_1] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Prices]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prices](
	[PriceID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[StudentDiscount] [decimal](4, 2) NOT NULL,
 CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED 
(
	[PriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Students](
	[ParticipantID] [int] NOT NULL,
	[StudentCardID] [varchar](50) NOT NULL,
	[ExpiryDate] [date] NOT NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Workshops]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Workshops](
	[WorkshopID] [int] IDENTITY(1,1) NOT NULL,
	[EventDescription] [text] NULL,
	[ConferenceDayID] [int] NOT NULL,
	[EventStartTime] [datetime] NOT NULL,
	[EventEndTime] [datetime] NOT NULL,
	[EventPrice] [money] NOT NULL,
	[PlacesQuantity] [int] NOT NULL,
	[StudentDiscount] [decimal](4, 2) NULL,
	[Address] [varchar](50) NULL,
 CONSTRAINT [PK_ConferenceEvent] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WorkshopsReservations]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopsReservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[PlacesReserved] [int] NULL,
	[Cancelled] [bit] NULL,
	[CencellationDate] [datetime] NULL,
	[CencellationReason] [datetime] NULL,
	[ReservationDate] [datetime] NOT NULL,
	[WorkshopID] [int] NOT NULL,
	[ConferenceReservationDay] [int] NOT NULL,
 CONSTRAINT [PK_WorkshopsReservations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_ConferenceDay]    Script Date: 23.01.2016 19:35:33 ******/
CREATE NONCLUSTERED INDEX [IX_ConferenceDay] ON [dbo].[ConferenceDay]
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConferenceDay]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceDay_Conference] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [FK_ConferenceDay_Conference]
GO
ALTER TABLE [dbo].[ConferenceDay]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceDay_Prices] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[Prices] ([PriceID])
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [FK_ConferenceDay_Prices]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceReservation_ConferenceDay] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDay] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[ConferenceReservations] CHECK CONSTRAINT [FK_ConferenceReservation_ConferenceDay]
GO
ALTER TABLE [dbo].[ConferenceReservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Client] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ConferenceReservations] CHECK CONSTRAINT [FK_Reservation_Client]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceDetails_Client1] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_ConferenceDetails_Client1]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_ConferenceReservation] FOREIGN KEY([PaymentID])
REFERENCES [dbo].[ConferenceReservations] ([ReservationID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_ConferenceReservation]
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Student_Participants] FOREIGN KEY([ParticipantID])
REFERENCES [dbo].[Participants] ([ParticipantID])
GO
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Student_Participants]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceEvent_ConferenceDay] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDay] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [FK_ConferenceEvent_ConferenceDay]
GO
ALTER TABLE [dbo].[WorkshopsReservations]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopsReservations_ConferenceReservation] FOREIGN KEY([ConferenceReservationDay])
REFERENCES [dbo].[ConferenceReservations] ([ReservationID])
GO
ALTER TABLE [dbo].[WorkshopsReservations] CHECK CONSTRAINT [FK_WorkshopsReservations_ConferenceReservation]
GO
ALTER TABLE [dbo].[WorkshopsReservations]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopsReservations_Workshops] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshops] ([WorkshopID])
GO
ALTER TABLE [dbo].[WorkshopsReservations] CHECK CONSTRAINT [FK_WorkshopsReservations_Workshops]
GO
/****** Object:  StoredProcedure [dbo].[AddClient]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddConference]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddConferenceDay]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddParticipant]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddPayment]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Dodaj płatność
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
/****** Object:  StoredProcedure [dbo].[AddPrice]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddStudentData]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[AddWorkshop]    Script Date: 23.01.2016 19:35:33 ******/
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
/****** Object:  StoredProcedure [dbo].[ReservePlacesForConferenceDay]    Script Date: 23.01.2016 19:35:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Piotr Jaworski
-- Description:	Rezerwuje miejsca na dzień konferencji
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
/****** Object:  StoredProcedure [dbo].[ReservePlacesForWorkshop]    Script Date: 23.01.2016 19:35:33 ******/
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
USE [master]
GO
ALTER DATABASE [Conferensions] SET  READ_WRITE 
GO
