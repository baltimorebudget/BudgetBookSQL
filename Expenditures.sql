-->>>>>>>>>>>>>>>>>>>>>>>>AGENCY AND FUND<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SELECT [agency_id] AS 'Agency ID'
      ,[agency_name] AS 'Agency Name'
      ,[fund_id] AS 'Fund ID'
      ,[fund_name] AS 'Fund Name'
      ,FORMAT(SUM([prior_adopted]), 'C', 'en-us') AS 'FY21 Adopted'
      ,FORMAT(SUM([prior_actual]), 'C', 'en-us') AS 'FY21 Actual'
      ,FORMAT(SUM([prior_ytd_actual]), 'C', 'en-us') AS 'FY21 YTD Actual'
      ,FORMAT(SUM([curr_adopted]), 'C', 'en-us') AS 'FY22 Adopted'
      ,FORMAT(SUM([carry_fwd_a]), 'C', 'en-us') AS 'Carry Forward A'
      ,FORMAT(SUM([carry_fwd_b]), 'C', 'en-us') AS 'Carry Forward B'
      ,FORMAT(SUM([carry_fwd_total]), 'C', 'en-us') AS 'Carry Forward Total'
      ,FORMAT(SUM([app_adj]), 'C', 'en-us') AS 'Appropriations Adjustment'
      ,FORMAT(SUM([tot_budget]), 'C', 'en-us') AS 'Total Budget'
      ,FORMAT(SUM([jul]), 'C', 'en-us') AS 'July'
      ,FORMAT(SUM([aug]), 'C', 'en-us') AS 'August'
      ,FORMAT(SUM([sep]), 'C', 'en-us') AS 'September'
      ,FORMAT(SUM([oct]), 'C', 'en-us') AS 'October'
      ,FORMAT(SUM([nov]), 'C', 'en-us') AS 'November'
      ,FORMAT(SUM([dec]), 'C', 'en-us') AS 'December'
      ,FORMAT(SUM([jan]), 'C', 'en-us') AS 'January'
      ,FORMAT(SUM([feb]), 'C', 'en-us') AS 'February'
      ,FORMAT(SUM([mar]), 'C', 'en-us') AS 'March'
      ,FORMAT(SUM([apr]), 'C', 'en-us') AS 'April'
      ,FORMAT(SUM([may]), 'C', 'en-us') AS 'May'
      ,FORMAT(SUM([jun]), 'C', 'en-us') AS 'June'
      ,FORMAT(SUM([ytd_exp]), 'C', 'en-us') AS 'BAPS YTD Expenditures'
      ,FORMAT(SUM([tot_enc]), 'C', 'en-us') AS 'Total Encumbrance'
      ,FORMAT(SUM([cur_acc]), 'C', 'en-us') AS 'Current Accrual'
  FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]
  GROUP BY [agency_id], [agency_name], [fund_id], [fund_name]
  ORDER BY [agency_id], [agency_name],  [fund_id], [fund_name]

  -->>>>>>>>>>>>>>>>>>>>>>>>>SERVICE FOR PILLARS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
  SELECT 
		ISNULL(B.[Objective Name], 'Other') AS 'Pillar'
      ,[program_id] AS 'Service ID'
      ,[program_name] AS 'Service Name'
      ,FORMAT(SUM([prior_adopted]), 'C', 'en-us') AS 'FY21 Adopted'
      ,FORMAT(SUM([prior_actual]), 'C', 'en-us') AS 'FY21 Actual'
      ,FORMAT(SUM([prior_ytd_actual]), 'C', 'en-us') AS 'FY21 YTD Actual'
      ,FORMAT(SUM([curr_adopted]), 'C', 'en-us') AS 'FY22 Adopted'
      ,FORMAT(SUM([carry_fwd_a]), 'C', 'en-us') AS 'Carry Forward A'
      ,FORMAT(SUM([carry_fwd_b]), 'C', 'en-us') AS 'Carry Forward B'
      ,FORMAT(SUM([carry_fwd_total]), 'C', 'en-us') AS 'Carry Forward Total'
      ,FORMAT(SUM([app_adj]), 'C', 'en-us') AS 'Appropriations Adjustment'
      ,FORMAT(SUM([tot_budget]), 'C', 'en-us') AS 'Total Budget'
      ,FORMAT(SUM([jul]), 'C', 'en-us') AS 'July'
      ,FORMAT(SUM([aug]), 'C', 'en-us') AS 'August'
      ,FORMAT(SUM([sep]), 'C', 'en-us') AS 'September'
      ,FORMAT(SUM([oct]), 'C', 'en-us') AS 'October'
      ,FORMAT(SUM([nov]), 'C', 'en-us') AS 'November'
      ,FORMAT(SUM([dec]), 'C', 'en-us') AS 'December'
      ,FORMAT(SUM([jan]), 'C', 'en-us') AS 'January'
      ,FORMAT(SUM([feb]), 'C', 'en-us') AS 'February'
      ,FORMAT(SUM([mar]), 'C', 'en-us') AS 'March'
      ,FORMAT(SUM([apr]), 'C', 'en-us') AS 'April'
      ,FORMAT(SUM([may]), 'C', 'en-us') AS 'May'
      ,FORMAT(SUM([jun]), 'C', 'en-us') AS 'June'
      ,FORMAT(SUM([ytd_exp]), 'C', 'en-us') AS 'BAPS YTD Expenditures'
      ,FORMAT(SUM([tot_enc]), 'C', 'en-us') AS 'Total Encumbrance'
      ,FORMAT(SUM([cur_acc]), 'C', 'en-us') AS 'Current Accrual'
  FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE] A
  LEFT JOIN (SELECT [Program Name], [Program Id], [Objective Id],[Objective Name] FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]) B
  ON A.program_id = B.[Program Id]
  GROUP BY B.[Objective Name], [program_id], [program_name]
  ORDER BY B.[Objective Name], [program_id], [program_name]

  -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>BUDGET BOOK DATA PREP<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

  SELECT A.[Agency Name] AS 'Agency Name', A.[Agency Id] AS 'Agency ID', 
        A.[Program Name] AS 'Service Name', A.[Program Id] AS 'Service ID', 
        A.[Activity Name] AS 'Activity Name', FORMAT(CONVERT(INT, A.[Activity Id]), '000') AS 'Activity ID', 
        A.[Subactivity Name] AS 'Subactivity Name', A.[Subactivity Id] AS 'Subactivity ID', 
        CASE WHEN A.[Fund Name] LIKE '%Rescue%' THEN 'Federal'
                ELSE A.[Fund Name] END AS 'Fund Name', 
        CASE WHEN A.[Fund Id] = 4001 THEN 4000 
                ELSE A.[Fund Id] END AS 'Fund ID', 
        A.[DetailedFund Name] AS 'Detailed Fund Name', A.[DetailedFund Id] AS 'Detailed Fund ID',
        A.[Object Name] AS 'Object Name', A.[Object ID] AS 'Object ID', 
        A.[Subobject Name] AS 'Subobject Name', A.[Subobject Id] AS 'Subobject ID',
        A.[Objective Name] AS 'Objective Name', A.[Objective Id] AS 'Objective ID',
        FORMAT(SUM(ISNULL(C.[FY21 Actual], 0)), 'C', 'en-us') AS 'FY21 Actual', 
        FORMAT(SUM(ISNULL(C.[FY21 Budget], 0)), 'C', 'en-us') AS 'FY21 Budget',
        -- FORMAT(SUM(ISNULL(C.[FY22 Actual], 0)), 'C', 'en-us') AS 'FY22 Actual',
        FORMAT(SUM(ISNULL(C.[FY22 Budget], 0)), 'C', 'en-us') AS 'FY22 Budget',
        FORMAT(SUM(ISNULL(A.[FY23 CLS], 0)), 'C', 'en-us') AS 'FY23 CLS',
        FORMAT(SUM(ISNULL(A.[FY23 Proposal], 0)), 'C', 'en-us') AS 'FY23 Proposal', 
        FORMAT(SUM(ISNULL(A.[FY23 TLS], 0)), 'C', 'en-us') AS 'FY23 TLS', 
        FORMAT(SUM(ISNULL(A.[FY23 FinRec], 0)), 'C', 'en-us') AS 'FY23 FinRec',
        FORMAT(SUM(ISNULL(A.[FY23 BoE], 0)), 'C', 'en-us') AS 'FY23 Budget'
 FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE] A
 LEFT JOIN (
     --MAIN START
     SELECT agency_id AS 'Agency ID', program_id AS 'Service ID', activity_id AS 'Activity ID',
            subactivity_id AS 'Subactivity ID', fund_id AS 'Fund ID', detailed_fund_id AS 'Detailed Fund ID',
            object_id AS 'Object ID', subobject_id AS 'Subobject ID',
            -- [2012] AS 'FY12 Actual', [2013] AS 'FY13 Actual', [2014] AS 'FY14 Actual', [2015] AS 'FY15 Actual', [2016] AS 'FY16 Actual',
            -- [2017] AS 'FY17 Actual',
            -- [2018] AS 'FY18 Actual', [2019] AS 'FY19 Actual', [2020] AS 'FY20 Actual', 
            B.[FY21 Actual] , B.[FY22 Actual], B.[FY21 Budget], B.[FY22 Budget]
            FROM 
            --SUB1 START
                (SELECT ACTUALS.*, BUDGETS.[FY21 Budget], BUDGETS.[FY22 Budget]
                --SUB2 START
                FROM (SELECT agency_id , program_id, activity_id,
                        subactivity_id, fund_id, detailed_fund_id,
                        object_id, subobject_id,
                        ISNULL(SUM([2021]), 0) AS 'FY21 Actual', ISNULL(SUM([2022]), 0) AS 'FY22 Actual'
                        FROM 
                        --SUB3A START
                            (SELECT *
                            FROM [Finance_BPFS].[planningyear23].[BUDGETS_N_ACTUALS_CLEAN_DF]
                                        WHERE Fiscal_Year > 2020) P 
                        --SUB3A END
                PIVOT (SUM(actual) FOR Fiscal_Year in ([2021], [2022])) AS P2 
                GROUP BY agency_id, program_id, activity_id, subactivity_id, fund_id, detailed_fund_id, object_id, subobject_id  ) ACTUALS
                JOIN (SELECT agency_id , program_id, activity_id,
                        subactivity_id, fund_id, detailed_fund_id,
                        object_id, subobject_id,
                        -- SUM([2012]) AS 'FY12 Actual', SUM([2013]) AS 'FY13 Actual', [2014] AS 'FY14 Actual', [2015] AS 'FY15 Actual', [2016] AS 'FY16 Actual',
                        -- [2017] AS 'FY17 Actual',
                        -- SUM([2018]) AS 'FY18 Actual', SUM([2019]) AS 'FY19 Actual', SUM([2020]) AS 'FY20 Actual', 
                        ISNULL(SUM([2021]), 0) AS 'FY21 Budget', ISNULL(SUM([2022]), 0) AS 'FY22 Budget'
                        FROM 
                        --SUB3B START
                            (SELECT *
                            FROM [Finance_BPFS].[planningyear23].[BUDGETS_N_ACTUALS_CLEAN_DF]
                                        WHERE Fiscal_Year > 2020) P 
                        --SUB3B END
                        PIVOT (SUM(adopted) FOR Fiscal_Year in ([2021], [2022])) AS P2
                        GROUP BY agency_id, program_id, activity_id, subactivity_id, fund_id, detailed_fund_id, object_id, subobject_id ) BUDGETS
                        ON ACTUALS.agency_id = BUDGETS.agency_id AND ACTUALS.program_id = BUDGETS.program_id AND ACTUALS.activity_id = BUDGETS.activity_id
                        AND ACTUALS.fund_id = BUDGETS.fund_id AND ACTUALS.detailed_fund_id = BUDGETS.detailed_fund_id AND ACTUALS.subactivity_id = BUDGETS.subactivity_id
                        AND ACTUALS.subobject_id = BUDGETS.subobject_id AND ACTUALS.object_id = BUDGETS.object_id
            --SUB1 END
            ) B
            --MAIN END
            ) C
ON A.[Agency Id] = C.[Agency ID] AND A.[Program Id] = C.[Service ID] AND A.[Activity Id] = C.[Activity ID]
AND A.[Fund Id] = C.[Fund ID] AND A.[DetailedFund Id] = C.[Detailed Fund ID]
AND A.[Object ID] = C.[Object ID] AND A.[Subobject Id] = C.[Subobject ID]
WHERE C.[FY21 Budget] IS NOT NULL AND C.[FY22 Budget] IS NOT NULL AND A.[FY23 BoE] IS NOT NULL
GROUP BY A.[Agency Name], A.[Agency Id], A.[Program Name], A.[Program Id], A.[Activity Name], A.[Activity Id], 
        A.[Subactivity Name], A.[Subactivity Id], A.[Fund Name], A.[Fund Id], A.[DetailedFund Name], A.[DetailedFund Id],
        A.[Object Name], A.[Object ID], A.[Subobject Name], A.[Subobject Id], A.[Objective Name], A.[Objective Id]
ORDER BY A.[Agency Id], A.[Program Id], A.[Activity Id], A.[Subactivity Id], A.[Fund Id], A.[DetailedFund Id], A.[Object ID], A.[Subobject Id]