--///////////////////////Positions - Planning, Projection and Prior Years //////////////////
IF OBJECT_ID(N'tempdb..#temp_table') IS NOT NULL
BEGIN
DROP TABLE #temp_table_position
END
GO

SELECT * 
INTO #temp_table_position
FROM (

SELECT D.[End Agency], 
D.[End Service Name], 
D.[End Activity Name], 
D.[Job Changed?], 
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN COUNT(D.[Start Job Number])
	ELSE 0
	END AS 'Jobs Abolished',
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN FORMAT(SUM(D.[End Total Cost]), 'C', 'en-us')
	ELSE 'N/A'
	END AS 'Total $ for Abolished Positions',
D.[Service Changed?],
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[Start Service Name]
	WHEN D.[Service Changed?] = 'Yes' THEN D.[Start Service Name]
	ELSE 'N/A'
	END AS 'Start Service',
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[Start Activity Name]
	ELSE 'N/A'
	END AS 'Start Activity',
D.[Fund Changed?],
CASE WHEN D.[Fund Changed?] = 'Yes' THEN CONCAT('From ', D.[Start Fund Name], ' to ', D.[End Fund Name])
	ELSE 'N/A'
	END AS 'Fund Transfer',
D.[Class Changed?], 
ISNULL(D.[Salary Changed?], 'N/A') AS 'Salary Changed?', ISNULL(D.[OPCs Changed?], 'N/A') AS 'OPCs Changed?',
D.[Significant Change?],
SUM(D.[Salary Difference]) AS 'Salary Change Amount',
SUM(D.[OPC Difference]) AS 'OPC Change Amount',
COUNT(D.[End Job Number]) AS 'End # Jobs'
FROM (
SELECT CASE WHEN Pln.[JOB NUMBER] IS NULL THEN 'Yes (abolished)'
			WHEN Pri.[JOB NUMBER] IS NULL THEN 'Yes (new)'
			ELSE 'No'
			END AS 'Job Changed?',
		CASE WHEN Pln.[PROGRAM NAME] != Pri.[PROGRAM NAME] THEN 'Yes'
			ELSE 'No' 
			END AS 'Service Changed?',
		CASE WHEN Pln.[FUND NAME] != Pri.[FUND NAME] THEN 'Yes'
			ELSE 'No' 
			END AS 'Fund Changed?',
		CASE WHEN Pln.[CLASSIFICATION ID] != Pri.[CLASSIFICATION ID] THEN 'Yes'
			ELSE 'No'
			END AS 'Class Changed?',
		Pln.Salary - Pri.[Salary] AS 'Salary Difference',
		CASE WHEN Pln.Salary > Pri.[Salary] THEN 'Salary increased'
			WHEN Pln.Salary < Pri.[Salary] THEN 'Salary decreased'
			WHEN Pln.Salary = Pri.[Salary] THEN 'No'
			END AS 'Salary Changed?',
		((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) AS 'OPC Difference',
		CASE WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) > 0 THEN 'OPCs increased'
			WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) < 0 THEN 'OPCs decreased'
			ELSE 'No'
			END AS 'OPCs Changed?',
		CASE WHEN (Pln.[OSO 101] > Pri.[OSO 101]) OR (Pln.[OSO 103] > Pri.[OSO 103]) 
					OR (Pln.[OSO 161] > Pri.[OSO 161]) OR (Pln.[OSO 162] > Pri.[OSO 162]) THEN 'Increase in employee compensation and benefits'
			WHEN Pln.[OSO 101] < Pri.[OSO 101] OR (Pln.[OSO 103] < Pri.[OSO 103]) 
					OR (Pln.[OSO 161] < Pri.[OSO 161]) OR (Pln.[OSO 162] < Pri.[OSO 162]) THEN 'Decrease in employee compensation and benefits'
			WHEN (Pln.[OSO 201] > Pri.[OSO 201]) OR (Pln.[OSO 203] > Pri.[OSO 203]) 
					OR (Pln.[OSO 202] > Pri.[OSO 202]) THEN 'Increase in pension contributions'
			WHEN (Pln.[OSO 201] < Pri.[OSO 201]) OR (Pln.[OSO 203] < Pri.[OSO 203]) 
					OR (Pln.[OSO 202] < Pri.[OSO 202]) THEN 'Increase in pension contributions'
			ELSE 'No change' END AS 'Change/Adjustment',
		Pln.[JOB NUMBER] AS 'End Job Number',
		Pri.[JOB NUMBER] AS 'Start Job Number',
		Pln.[ADOPTED] AS 'End Adopted Status',
		Pln.[AGENCY NAME] AS 'End Agency',
		Pri.[AGENCY NAME] AS 'Start Agency Name',
		Pri.[PROGRAM NAME] AS 'Start Service Name',
		Pln.[PROGRAM NAME] AS 'End Service Name',
		Pri.[Activity Name] AS 'Start Activity Name',
		Pln.[ACTIVITY NAME] AS 'End Activity Name',
		Pln.[ACTIVITY ID] AS 'End Activity ID',
		Pri.[CLASSIFICATION NAME] AS 'Start Class Name',
		Pln.[CLASSIFICATION NAME] AS 'End Class Name',
		Pri.[Salary] AS 'End Salary',
		Pln.[SALARY] AS 'Start Salary',
		Pri.[TOTAL COST] AS 'Start Total Cost',
		Pln.[TOTAL COST]AS 'End Total Cost',
		CASE WHEN Pln.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
				ELSE Pln.[Fund Name] END AS 'End Fund Name', 
		Pri.[Fund Name] AS 'Start Fund Name',
		CASE WHEN Pln.[Fund Id] = 4001 THEN 4000 
				ELSE Pln.[Fund Id] END AS 'End Fund ID',
		Pri.[Fund ID] AS 'Start Fund',
		Pln.[DETAILED FUND NAME] AS 'End Detailed Fund',
		Pln.[GRADE] AS 'End Compensation Grade',
		Pln.[UNION NAME] AS 'End Union',
		Pln.[SI NAME] AS 'End Special Indicator',
		Pln.[STATUS] AS 'End Status',
		FORMAT(Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235], 'C', 'en-us') AS 'Start OSO Total',
		FORMAT(Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235], 'C', 'en-us') AS 'End OSO Total',
		FORMAT(Pln.[OSO 101], 'C', 'en-us') AS 'End Subobject 101',
		FORMAT(Pln.[OSO 103], 'C', 'en-us') AS 'End Subobject 103',
		FORMAT(Pln.[OSO 161], 'C', 'en-us') AS 'End Subobject 161',
		FORMAT(Pln.[OSO 162], 'C', 'en-us') AS 'End Subobject 162',
		FORMAT(Pln.[OSO 201], 'C', 'en-us') AS 'End Subobject 201',
		FORMAT(Pln.[OSO 202], 'C', 'en-us') AS 'End Subobject 202',
		FORMAT(Pln.[OSO 203], 'C', 'en-us') AS 'End Subobject 203',
		FORMAT(Pln.[OSO 205], 'C', 'en-us') AS 'End Subobject 205',
		FORMAT(Pln.[OSO 207], 'C', 'en-us') AS 'End Subobject 207',
		FORMAT(Pln.[OSO 210], 'C', 'en-us') AS 'End Subobject 210',
		FORMAT(Pln.[OSO 212], 'C', 'en-us') AS 'End Subobject 212',
		FORMAT(Pln.[OSO 213], 'C', 'en-us') AS 'End Subobject 213',
		FORMAT(Pln.[OSO 231], 'C', 'en-us') AS 'End Subobject 231',
		FORMAT(Pln.[OSO 233], 'C', 'en-us') AS 'End Subobject 233',
		FORMAT(Pln.[OSO 235], 'C', 'en-us') AS 'End Subobject 235',
		CASE WHEN ABS(((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235]))) > 5000 THEN 'Yes'
			WHEN ABS(Pln.Salary - Pri.[Salary]) > 5000 THEN 'Yes'
			ELSE 'No' END AS 'Significant Change?'
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>END POINT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
  FROM planningyear23.PositionsSalariesOpcs_BOE Pln
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
  FULL JOIN (
		  SELECT Prj.*,
			CASE WHEN Prj.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
				ELSE Prj.[Fund Name] END AS 'Start Fund Name', 
			CASE WHEN Prj.[Fund Id] = 4001 THEN 4000 
				ELSE Prj.[Fund Id] END AS 'Start Fund ID'
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>START POINT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
			FROM planningyear22.PositionsSalariesOpcs_COU Prj
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
		WHERE Prj.[Fund ID] = 1001
		) Pri 
ON Pri.[JOB NUMBER] = Pln.[JOB NUMBER]
WHERE (Pln.[Fund ID] = 1001 OR Pri.[Fund ID] = 1001) AND
(CASE WHEN Pln.[JOB NUMBER] IS NULL THEN 'Yes (old)'
			WHEN Pri.[JOB NUMBER] IS NULL THEN 'Yes (new)'
			ELSE 'No'
			END LIKE 'Yes%' OR
		CASE WHEN Pln.[PROGRAM NAME] != Pri.[PROGRAM NAME] THEN 'Yes'
			ELSE 'No' 
			END = 'Yes' OR
		CASE WHEN Pln.[FUND NAME] != Pri.[Start Fund Name] THEN 'Yes'
			ELSE 'No' 
			END = 'Yes' OR
		CASE WHEN Pln.[CLASSIFICATION ID] != Pri.[CLASSIFICATION ID] THEN 'Yes'
			ELSE 'No'
			END = 'Yes' OR
		CASE WHEN Pln.Salary > Pri.[Salary] THEN 'Salary increased'
			WHEN Pln.Salary < Pri.[Salary] THEN 'Salary decreased'
			WHEN Pln.Salary = Pri.[Salary] THEN 'No change'
			END LIKE 'Salary%' OR
		CASE WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) > 0 THEN 'OPCs increased'
			WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) < 0 THEN 'OPCs decreased'
			ELSE 'No'
			END LIKE 'OPC%') ) D
--WHERE (D.[Significant Change?] = 'Yes' OR D.[End Agency] IS NULL)
GROUP BY D.[End Agency], D.[End Service Name], D.[End Activity Name], 
D.[Job Changed?], 
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[Start Service Name]
	WHEN D.[Service Changed?] = 'Yes' THEN D.[Start Service Name]
	ELSE 'N/A'
	END,
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[Start Activity Name]
	ELSE 'N/A'
	END,
D.[Service Changed?], D.[Fund Changed?], 
CASE WHEN D.[Fund Changed?] = 'Yes' THEN CONCAT('From ', D.[Start Fund Name], ' to ', D.[End Fund Name])
	ELSE 'N/A'
	END,
D.[Class Changed?], D.[Salary Changed?], D.[OPCs Changed?], D.[Significant Change?]
) AS ChangeTable

--//////////Add dynamic column names//////////////
DECLARE @start NVARCHAR(20) = 'BOE'
DECLARE @end NVARCHAR(20) = 'COU'
DECLARE @sql VARCHAR(MAX)

--SET @sql = '
SELECT 
CASE WHEN [Job Changed?] LIKE 'Yes%' THEN [Start Service]
	ELSE [End Agency] 
	END AS 'Agency', 
CASE WHEN [Job Changed?] LIKE 'Yes%' THEN [Start Service]
	ELSE [End Service Name] 
	END AS 'Service',
CONCAT(CAST([Jobs Abolished] AS VARCHAR), ' jobs removed from ', [Start Service]) AS 'Job Abolishment',
CONCAT(CAST([End # Jobs] AS VARCHAR), ' created in ', [End Service Name]) as 'Job Creation',
CASE WHEN [Service Changed?] = 'Yes' THEN CONCAT(CAST([End # Jobs] AS VARCHAR), ' moved from ', [Start Service], ' to ', [End Service Name])
	END AS 'Job Transfer',
[Fund Transfer]
FROM #temp_table_position
WHERE (
CONCAT(CAST([Jobs Abolished] AS VARCHAR), ' jobs removed from ', [Start Service]) IS NOT NULL OR
CONCAT(CAST([End # Jobs] AS VARCHAR), ' created in ', [End Service Name]) IS NOT NULL OR
CASE WHEN [Service Changed?] = 'Yes' THEN CONCAT(CAST([End # Jobs] AS VARCHAR), ' moved from ', [Start Service], ' to ', [End Service Name])
	END IS NOT NULL OR
[Fund Transfer] IS NOT NULL
)
GROUP BY 
CASE WHEN [Job Changed?] LIKE 'Yes%' THEN [Start Service]
	ELSE [End Agency] 
	END, 
CASE WHEN [Job Changed?] LIKE 'Yes%' THEN [Start Service]
	ELSE [End Service Name] 
	END,
CONCAT(CAST([Jobs Abolished] AS VARCHAR), ' jobs removed from ', [Start Service]),
CONCAT(CAST([End # Jobs] AS VARCHAR), ' created in ', [End Service Name]),
CASE WHEN [Service Changed?] = 'Yes' THEN CONCAT(CAST([End # Jobs] AS VARCHAR), ' moved from ', [Start Service], ' to ', [End Service Name])
	END,
[Fund Transfer]

SELECT * FROM #temp_table_position
--'
--EXECUTE(@sql)

--PowerShell Command
--Invoke-Sqlcmd -InputFile "C:\Users\sara.brumfield2\Documents\SQL Server Management Studio\BudgetBook\BudgetBook\ChangeTables.sql" | Out-File -FilePath "C:\Users\sara.brumfield2\Documents\SQL Server Management Studio\BudgetBook\BudgetBook\Test.rpt"

