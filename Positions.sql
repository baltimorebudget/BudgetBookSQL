--///////////////////////Positions - Planning, Projection and Prior Years //////////////////

SELECT CASE WHEN Pln.[JOB NUMBER] IS NULL THEN 'Yes (old)'
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
		FORMAT(Pln.Salary - Pri.[FY22 Salary], 'C', 'en-us') AS 'Salary Difference',
		CASE WHEN Pln.Salary > Pri.[FY22 Salary] THEN 'Salary increased'
			WHEN Pln.Salary < Pri.[FY22 Salary] THEN 'Salary decreased'
			WHEN Pln.Salary = Pri.[FY22 Salary] THEN 'No'
			END AS 'Salary Changed?',
		FORMAT(((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])), 'C', 'en-us') AS 'OPC Difference',
		CASE WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) > 0 THEN 'OPCs increased'
			WHEN ((Pln.[OSO 101] + Pln.[OSO 103] + Pln.[OSO 161] + Pln.[OSO 162] + Pln.[OSO 201] + Pln.[OSO 202] + Pln.[OSO 203] + Pln.[OSO 205] + Pln.[OSO 207] + Pln.[OSO 210] + Pln.[OSO 212] + Pln.[OSO 213] + Pln.[OSO 231] + Pln.[OSO 231] + Pln.[OSO 233] + Pln.[OSO 235]) - (Pri.[OSO 101] + Pri.[OSO 103] + Pri.[OSO 161] + Pri.[OSO 162] + Pri.[OSO 201] + Pri.[OSO 202] + Pri.[OSO 203] + Pri.[OSO 205] + Pri.[OSO 207] + Pri.[OSO 210] + Pri.[OSO 212] + Pri.[OSO 213] + Pri.[OSO 231] + Pri.[OSO 231] + Pri.[OSO 233] + Pri.[OSO 235])) < 0 THEN 'OPCs decreased'
			ELSE 'No'
			END AS 'OPCs Changed?',
		Pln.[JOB NUMBER] AS 'FY23 Job Number',
		Pri.[FY22 Job Number],
		Pln.[ADOPTED] AS 'FY23 Adopted Status',
		Pln.[AGENCY NAME] AS 'FY23 Agency',
		Pri.[FY22 Service Name],
		Pln.[PROGRAM NAME] AS 'FY23 Service Name',
		Pri.[FY22 Class Name],
		Pln.[CLASSIFICATION NAME] AS 'FY23 Class Name',
		FORMAT(Pri.[FY22 Salary], 'C', 'en-us') AS 'FY22 Salary',
		FORMAT(Pln.[SALARY], 'C', 'en-us') AS 'FY23 Salary',
		FORMAT(Pri.[TOTAL COST], 'C', 'en-us') AS 'FY22 Total Cost',
		FORMAT(Pln.[TOTAL COST], 'C', 'en-us') AS 'FY23 Total Cost',
		CASE WHEN Pln.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
                ELSE Pln.[Fund Name] END AS 'FY23 Fund Name', 
		Pri.[FY22 Fund Name],
        CASE WHEN Pln.[Fund Id] = 4001 THEN 4000 
                ELSE Pln.[Fund Id] END AS 'FY23 Fund ID',
		Pri.[FY22 Fund ID],
		Pln.[DETAILED FUND NAME] AS 'FY23 Detailed Fund',
		Pln.[GRADE] AS 'FY23 Compensation Grade',
		Pln.[UNION NAME] AS 'FY23 Union',
		Pln.[Activity id] AS 'FY23 Activity ID',
		Pln.[ACTIVITY NAME] AS 'FY23 Activity Name',
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
		FORMAT(Pln.[TOTAL COST], 'C', 'en-us') AS 'FY23 Total Cost'
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
                Prj.[GRADE] AS 'FY22 Grade',
                Prv.[GRADE] AS 'FY21 Grade',
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
--adjust filter
WHERE Pln.[CLASSIFICATION ID] != Pri.[FY22 Class ID]
