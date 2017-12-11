IF OBJECT_ID(N'dbo.BankHoliday',N'u') IS NOT NULL
	DROP TABLE dbo.BankHoliday
GO

CREATE TABLE dbo.BankHoliday (
	ID int identity(1,1) primary key,
	HOLIDAY_DATE date,
	HOLIDAY_NAME nvarchar(50)
)

CREATE INDEX HOLIDAY_DATE_IX ON dbo.BankHoliday (HOLIDAY_DATE)

INSERT INTO dbo.BankHoliday VALUES 
	('2018-01-01','Nowy Rok'),
	('2018-01-06','Trzech Kr�li'),
	('2018-04-01','Niedziela Wielkanocna'),
	('2018-04-02','Poniedzia�ek Wielkanocny'),
	('2018-05-01','�wi�to Pracy'),
	('2018-05-03','�wi�to Konstytucji 3 maja'),
	('2018-05-20','Zielone �wiatki'),
	('2018-05-31','Bo�e Cia�o'),
	('2018-08-15','�wi�to Wojska Polskiego'),
	('2018-11-01','Wszystkich �wi�tych'),
	('2018-11-11','Dzie� Niepodleg�o�ci'),
	('2018-12-25','Bo�e Narodzenie'),
	('2018-12-26','Drugi dzie� �wi�t Bo�ego Narodzenia')


IF OBJECT_ID(N'dbo.WorkingDays',N'FN') IS NOT NULL
	DROP FUNCTION dbo.WorkingDays
GO

CREATE FUNCTION dbo.WorkingDays (
	@StartDate date = '2018-01-01',
	@StopDate date = '2018-12-31'
)
RETURNS int
AS
BEGIN
	DECLARE @WorkingDays int
	DECLARE @BankHolidays int
	DECLARE @WeekendDays int = 0
	SET @WorkingDays = DATEDIFF(day,@StartDate,@StopDate)
	SET @BankHolidays = (SELECT count(ID) FROM dbo.BankHoliday 
						 WHERE HOLIDAY_DATE>=@StartDate 
						 AND HOLIDAY_DATE<=@StopDate
						 )
	WHILE @StartDate<=@StopDate
		BEGIN
			IF (DATENAME(WEEKDAY,@StartDate)=DATENAME(WEEKDAY,5) OR DATENAME(WEEKDAY,@StartDate)=DATENAME(WEEKDAY,6)) AND
				@StartDate NOT IN (SELECT HOLIDAY_DATE FROM BankHoliday)
				SET @WeekendDays = @WeekendDays+1
			SET @StartDate = DATEADD(DAY,1,@StartDate)
		END;
	RETURN(@WorkingDays-@BankHolidays-@WeekendDays)
END;

GO

SELECT dbo.WorkingDays(default,default) as 'Working Days'
