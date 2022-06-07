--///////////////////////Positions - Planning, Projection and Prior Years //////////////////

SELECT Pln.*, Pri.*
  FROM planningyear23.PositionsSalariesOpcs_BOE Pln
  FULL JOIN (
          SELECT Prj.[JOB NUMBER] AS 'Job Number',
                Prj.[CLASSIFICATION ID] AS 'FY22 Class ID',
                Prv.[CLASSIFICATION ID] AS 'FY21 Class ID',
                Prj.[CLASSIFICATION NAME] AS 'FY22 Class Name',
                Prv.[CLASSIFICATION NAME] AS 'FY21 Class Name',
                Prj.[GRADE] AS 'FY22 Grade',
                Prv.[GRADE] AS 'FY21 Grade'
                FROM planningyear22.PositionsSalariesOpcs_COU Prj
                FULL JOIN (
                                --DECLARE @FiscalYear NVARCHAR(4)
                                --UPDATE planningyear21.PositionsSalariesOpcs_COU 
                                --SET @FiscalYear = 21 WHERE @FiscalYear IS NULL
                                SELECT --@FiscalYear AS 'Fiscal Year', 
                                        * 
                                        FROM planningyear21.PositionsSalariesOpcs_COU
                                ) Prv
                ON Prv.[Job Number] = Prj.[Job Number]
        ) Pri 
ON Pri.[JOB NUMBER] = Pln.[JOB NUMBER]
