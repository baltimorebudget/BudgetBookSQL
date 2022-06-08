--///////////////////////Positions - Planning, Projection and Prior Years //////////////////
SELECT D.[FY23 Agency], D.[FY23 Service Name], D.[FY23 Activity Name], 
D.[Job Changed?], 
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN COUNT(D.[FY22 Job Number])
	ELSE 0
	END AS '# Jobs Abolished',
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN FORMAT(SUM(D.[FY22 Total Cost]), 'C', 'en-us')
	ELSE 'N/A'
	END AS 'Total $ for Abolished Positions',
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Service Name]
	WHEN D.[Service Changed?] = 'Yes' THEN D.[FY22 Service Name]
	ELSE 'N/A'
	END AS 'FY22 Service',
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Activity Name]
	ELSE 'N/A'
	END AS 'FY22 Activity',
D.[Service Changed?], D.[Fund Changed?], D.[Class Changed?], 
ISNULL(D.[Salary Changed?], 'N/A') AS 'Salary Changed?', ISNULL(D.[OPCs Changed?], 'N/A') AS 'OPCs Changed?',
D.[Significant Change?],
SUM(D.[Salary Difference]) AS 'Salary Change Amount',
SUM(D.[OPC Difference]) AS 'OPC Change Amount',
--COUNT(D.[FY23 Job Number]) + COUNT(D.[FY22 Job Number]) AS 'Total # Jobs',
COUNT(D.[FY23 Job Number]) AS 'FY23 # Jobs'
--COUNT(D.[FY22 Job Number]) AS 'FY22 # Jobs'
FROM (
SELECT CASE WHEN Pln.[JOB NUMBER] IS NULL THEN 'Yes (abolished)'
			WHEN Pri.[JOB NUMBER] IS NULL THEN 'Yes (new)'
			ELSE 'No'
			END AS 'Job Changed?',
		CASE WHEN Pln.[PROGRAM NAME] != Pri.[FY22 Service Name] THEN 'Yes'
			ELSE 'No' 
			END AS 'Service Changed?',
		CASE WHEN Pln.[FUND NAME] != Pri.[FY22 Fund Name] THEN 'Yes'
			ELSE 'No' 
			END AS 'Fund Changed?',
		CASE WHEN Pln.[CLASSIFICATION ID] != Pri.[FY22 Class ID] THEN 'Yes'
			ELSE 'No'
			END AS 'Class Changed?',
		Pln.Salary - Pri.[FY22 Salary] AS 'Salary Difference',
		CASE WHEN Pln.Salary > Pri.[FY22 Salary] THEN 'Salary increased'
			WHEN Pln.Salary < Pri.[FY22 Salary] THEN 'Salary decreased'
			WHEN Pln.Salary = Pri.[FY22 Salary] THEN 'No'
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
		Pln.[JOB NUMBER] AS 'FY23 Job Number',
		Pri.[FY22 Job Number],
		Pln.[ADOPTED] AS 'FY23 Adopted Status',
		Pln.[AGENCY NAME] AS 'FY23 Agency',
		Pri.[FY22 Agency],
		Pri.[FY22 Service Name],
		Pln.[PROGRAM NAME] AS 'FY23 Service Name',
		Pri.[FY22 Activity Name],
		Pln.[ACTIVITY NAME] AS 'FY23 Activity Name',
		Pln.[ACTIVITY ID] AS 'FY23 Activity ID',
		Pri.[FY22 Class Name],
		Pln.[CLASSIFICATION NAME] AS 'FY23 Class Name',
		Pri.[FY22 Salary] AS 'FY22 Salary',
		Pln.[SALARY] AS 'FY23 Salary',
		Pri.[TOTAL COST] AS 'FY22 Total Cost',
		Pln.[TOTAL COST]AS 'FY23 Total Cost',
		CASE WHEN Pln.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
                ELSE Pln.[Fund Name] END AS 'FY23 Fund Name', 
		Pri.[FY22 Fund Name],
        CASE WHEN Pln.[Fund Id] = 4001 THEN 4000 
                ELSE Pln.[Fund Id] END AS 'FY23 Fund ID',
		Pri.[FY22 Fund ID],
		Pln.[DETAILED FUND NAME] AS 'FY23 Detailed Fund',
		Pln.[GRADE] AS 'FY23 Compensation Grade',
		Pln.[UNION NAME] AS 'FY23 Union',
		Pln.[SI NAME] AS 'FY23 Special Indicator',
		Pln.[STATUS] AS 'FY23 Status',
		FORMAT(Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235], 'C', 'en-us') AS 'FY22 OSO Total',
		FORMAT(Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235], 'C', 'en-us') AS 'FY23 OSO Total',
		FORMAT(Pln.[OSO 101], 'C', 'en-us') AS 'FY23 Subobject 101',
		FORMAT(Pln.[OSO 103], 'C', 'en-us') AS 'FY23 Subobject 103',
		FORMAT(Pln.[OSO 161], 'C', 'en-us') AS 'FY23 Subobject 161',
		FORMAT(Pln.[OSO 162], 'C', 'en-us') AS 'FY23 Subobject 162',
		FORMAT(Pln.[OSO 201], 'C', 'en-us') AS 'FY23 Subobject 201',
		FORMAT(Pln.[OSO 202], 'C', 'en-us') AS 'FY23 Subobject 202',
		FORMAT(Pln.[OSO 203], 'C', 'en-us') AS 'FY23 Subobject 203',
		FORMAT(Pln.[OSO 205], 'C', 'en-us') AS 'FY23 Subobject 205',
		FORMAT(Pln.[OSO 207], 'C', 'en-us') AS 'FY23 Subobject 207',
		FORMAT(Pln.[OSO 210], 'C', 'en-us') AS 'FY23 Subobject 210',
		FORMAT(Pln.[OSO 212], 'C', 'en-us') AS 'FY23 Subobject 212',
		FORMAT(Pln.[OSO 213], 'C', 'en-us') AS 'FY23 Subobject 213',
		FORMAT(Pln.[OSO 231], 'C', 'en-us') AS 'FY23 Subobject 231',
		FORMAT(Pln.[OSO 233], 'C', 'en-us') AS 'FY23 Subobject 233',
		FORMAT(Pln.[OSO 235], 'C', 'en-us') AS 'FY23 Subobject 235',
		CASE WHEN ABS(((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235]))) > 5000 THEN 'Yes'
			WHEN ABS(Pln.Salary - Pri.[FY22 Salary]) > 5000 THEN 'Yes'
			ELSE 'No' END AS 'Significant Change?'
  FROM planningyear23.PositionsSalariesOpcs_BOE Pln
  FULL JOIN (
          SELECT Prj.*,
				Prj.[JOB NUMBER] AS 'FY22 Job Number',
				Prv.[JOB NUMBER] AS 'FY21 Job Number',
                Prj.[CLASSIFICATION ID] AS 'FY22 Class ID',
                Prv.[CLASSIFICATION ID] AS 'FY21 Class ID',
                Prj.[CLASSIFICATION NAME] AS 'FY22 Class Name',
                Prv.[CLASSIFICATION NAME] AS 'FY21 Class Name',
				Prj.[PROGRAM NAME] AS 'FY22 Service Name',
				Prv.[PROGRAM NAME] AS 'FY21 Service Name',
				Prj.[ACTIVITY NAME] AS 'FY22 Activity Name',
                Prj.[GRADE] AS 'FY22 Grade',
                Prv.[GRADE] AS 'FY21 Grade',
				Prj.[AGENCY NAME] AS 'FY22 Agency',
				Prv.[FY21 Fund ID],
				Prv.[FY21 Fund Name],
				Prj.[Salary] AS 'FY22 Salary',
				CASE WHEN Prj.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
					ELSE Prj.[Fund Name] END AS 'FY22 Fund Name', 
				CASE WHEN Prj.[Fund Id] = 4001 THEN 4000 
					ELSE Prj.[Fund Id] END AS 'FY22 Fund ID'
                FROM planningyear22.PositionsSalariesOpcs_COU Prj
                FULL JOIN (
                                --DECLARE @FiscalYear NVARCHAR(4)
                                --UPDATE planningyear21.PositionsSalariesOpcs_COU 
                                --SET @FiscalYear = 21 WHERE @FiscalYear IS NULL
                                SELECT --@FiscalYear AS 'Fiscal Year', 
                                        *,
										CASE WHEN [Fund Name] LIKE '%Rescue%' THEN 'Federal'
											ELSE [Fund Name] END AS 'FY21 Fund Name', 
										CASE WHEN [Fund Id] = 4001 THEN 4000 
											ELSE [Fund Id] END AS 'FY21 Fund ID'
                                        FROM planningyear21.PositionsSalariesOpcs_COU
                                ) Prv
                ON Prv.[Job Number] = Prj.[Job Number]
        ) Pri 
ON Pri.[JOB NUMBER] = Pln.[JOB NUMBER]
WHERE (CASE WHEN Pln.[JOB NUMBER] IS NULL THEN 'Yes (old)'
			WHEN Pri.[JOB NUMBER] IS NULL THEN 'Yes (new)'
			ELSE 'No'
			END LIKE 'Yes%' OR
		CASE WHEN Pln.[PROGRAM NAME] != Pri.[FY22 Service Name] THEN 'Yes'
			ELSE 'No' 
			END = 'Yes' OR
		CASE WHEN Pln.[FUND NAME] != Pri.[FY22 Fund Name] THEN 'Yes'
			ELSE 'No' 
			END = 'Yes' OR
		CASE WHEN Pln.[CLASSIFICATION ID] != Pri.[FY22 Class ID] THEN 'Yes'
			ELSE 'No'
			END = 'Yes' OR
		CASE WHEN Pln.Salary > Pri.[FY22 Salary] THEN 'Salary increased'
			WHEN Pln.Salary < Pri.[FY22 Salary] THEN 'Salary decreased'
			WHEN Pln.Salary = Pri.[FY22 Salary] THEN 'No change'
			END LIKE 'Salary%' OR
		CASE WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) > 0 THEN 'OPCs increased'
			WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) < 0 THEN 'OPCs decreased'
			ELSE 'No'
			END LIKE 'OPC%') ) D
WHERE (D.[FY23 Agency] = 'Health' ) OR (D.[FY22 Agency] = 'Health')
AND (D.[Significant Change?] = 'Yes' OR D.[FY23 Agency] IS NULL)
GROUP BY D.[FY23 Agency], D.[FY23 Service Name], D.[FY23 Activity Name], 
D.[Job Changed?], 
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Service Name]
	WHEN D.[Service Changed?] = 'Yes' THEN D.[FY22 Service Name]
	ELSE 'N/A'
	END,
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Activity Name]
	ELSE 'N/A'
	END,
D.[Service Changed?], D.[Fund Changed?], D.[Class Changed?], D.[Salary Changed?], D.[OPCs Changed?], D.[Significant Change?]

ORDER BY D.[FY23 Agency], D.[FY23 Service Name], D.[FY23 Activity Name], 
D.[Job Changed?],
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Service Name]
	WHEN D.[Service Changed?] = 'Yes' THEN D.[FY22 Service Name]
	ELSE 'N/A'
	END,
CASE WHEN D.[Job Changed?] = 'Yes (abolished)' THEN D.[FY22 Activity Name]
	ELSE 'N/A'
	END,
D.[Service Changed?], D.[Fund Changed?], D.[Class Changed?], D.[Salary Changed?], D.[OPCs Changed?], D.[Significant Change?]