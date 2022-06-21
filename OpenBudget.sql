--///////////////////////OpenBudget Summary Tables//////////////////

-->>>>>>>>>>>>>>>>>>>>>AGENCY AND FUND<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

SELECT [Agency Name], [Fund Name], 
SUM([FY23 BOE]) AS 'FY23 Budget', 
SUM([FY22 Adopted]) AS 'FY22 Budget',
(NULLIF(SUM([FY22 Adopted]), 0) - NULLIF(SUM([FY23 BOE]), 0)) / SUM([FY22 Adopted]) AS '% Change'
FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
WHERE NOT([FY23 BoE] = 0 AND [FY22 Adopted] = 0)
GROUP BY [Agency Name], [Fund Name]
ORDER BY [Agency Name], [Fund Name]

SELECT CASE WHEN A.[Agency Name] IS NULL THEN B.agency_name
		WHEN B.agency_name IS NULL THEN A.[Agency Name]
		ELSE A.[Agency Name] END AS 'Agency Name',
		CASE WHEN A.[Fund Name] IS NULL THEN B.fund_name
		WHEN B.fund_name IS NULL THEN A.[Fund Name]
		ELSE A.[Fund Name] END AS 'Fund Name',
		ISNULL(A.[FY22 Budget], 0) AS 'FY22 Budget', 
		ISNULL(B.[FY22 YTD Expenditures], 0) AS 'FY22 YTD Spent', 
		ISNULL(A.[FY23 Budget], 0) AS 'FY23 Budget'
FROM(
	SELECT [Agency Name], [Fund Name], 
	SUM([FY23 BOE]) AS 'FY23 Budget', 
	SUM([FY22 Adopted]) AS 'FY22 Budget'
	 FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
	 GROUP BY [Agency Name], [Fund Name]) A
FULL JOIN (
	SELECT agency_name, fund_name, SUM([ytd_exp]) AS 'FY22 YTD Expenditures'
	FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]
	GROUP BY agency_name, fund_name) B
ON (A.[Agency Name] = B.agency_name AND A.[Fund Name] = B.fund_name)
WHERE CASE WHEN A.[Agency Name] IS NULL THEN B.agency_name
		WHEN B.agency_name IS NULL THEN A.[Agency Name]
		ELSE A.[Agency Name] END IS NOT NULL
AND NOT (ISNULL(A.[FY22 Budget], 0) = 0 AND ISNULL(B.[FY22 YTD Expenditures], 0) = 0 AND ISNULL(A.[FY23 Budget], 0) = 0)
ORDER BY CASE WHEN A.[Agency Name] IS NULL THEN B.agency_name
		WHEN B.agency_name IS NULL THEN A.[Agency Name]
		ELSE A.[Agency Name] END,
		CASE WHEN A.[Fund Name] IS NULL THEN B.fund_name
		WHEN B.fund_name IS NULL THEN A.[Fund Name]
		ELSE A.[Fund Name] END

-->>>>>>>>>>>>>>>>>>PILLAR AND SERVICE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

SELECT [Objective Name] AS 'Pillar', 
		CONCAT([Agency Name], ': ', [Program Name]) AS 'Service Name',
SUM([FY23 BOE]) AS 'FY23 Budget',
SUM([FY22 Adopted]) AS 'FY22 Budget'
FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
WHERE NOT([FY23 BoE] = 0 AND [FY22 Adopted] = 0)
GROUP BY [Objective Name], CONCAT([Agency Name], ': ', [Program Name])
ORDER BY [Pillar], [Service Name]

SELECT 	CASE WHEN A.[Objective Name] IS NULL THEN 'Other'
		ELSE A.[Objective Name] END AS 'Pillar',
		CASE WHEN A.[Program Name] IS NULL THEN CONCAT(B.[agency_name], ': ', B.[program_name])
		WHEN B.[program_name] IS NULL THEN CONCAT(A.[Agency Name], ': ', A.[Program Name])
		ELSE CONCAT(A.[Agency Name], ': ', A.[Program Name]) END AS 'Service Name',
		ISNULL(A.[FY22 Budget], 0) AS 'FY22 Budget', 
		ISNULL(B.[FY22 YTD Expenditures], 0) AS 'FY22 YTD Spent', 
		ISNULL(A.[FY23 Budget], 0) AS 'FY23 Budget'
FROM(
	SELECT [Objective Name], [Agency Id], [Agency Name], [Program Name],
	[Program Id],
	SUM([FY23 BOE]) AS 'FY23 Budget', 
	SUM([FY22 Adopted]) AS 'FY22 Budget'
	 FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
	 GROUP BY [Agency Id], [Agency Name], [Objective Name], [Program Name], [Program Id]
	 ) A
FULL JOIN (
	SELECT [agency_id], [agency_name], [PROGRAM_NAME], 
	[program_id], 
	SUM([ytd_exp]) AS 'FY22 YTD Expenditures'
	FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]
	GROUP BY [agency_id], [agency_name], [PROGRAM_NAME], program_id
	) B
ON (A.[Program Id] = B.[program_id] AND A.[Program Name] = B.[program_name])
WHERE CASE WHEN A.[Program Name] IS NULL THEN CONCAT(B.[agency_name], '-', B.[program_name])
		WHEN B.[program_name] IS NULL THEN CONCAT(A.[Agency Name], '-', A.[Program Name])
		ELSE CONCAT(A.[Agency Name], '-', A.[Program Name]) END IS NOT NULL
AND NOT (ISNULL(A.[FY22 Budget], 0) = 0 AND ISNULL(B.[FY22 YTD Expenditures], 0) = 0 AND ISNULL(A.[FY23 Budget], 0) = 0)
ORDER BY CASE WHEN A.[Objective Name] IS NULL THEN 'Other'
		ELSE A.[Objective Name] END,
CASE WHEN A.[Program Name] IS NULL THEN CONCAT(B.[agency_name], '-', B.[program_name])
		WHEN B.[program_name] IS NULL THEN CONCAT(A.[Agency Name], '-', A.[Program Name])
		ELSE CONCAT(A.[Agency Name], '-', A.[Program Name]) END

-->>>>>>>>>>>>>>>>>>>>>>>Totals Check<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

SELECT SUM([FY23 BoE]) AS 'FY23 Budget', 
	SUM([FY22 Adopted]) AS 'FY22 Budget'
FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
WHERE NOT([FY23 BoE] = 0 AND [FY22 Adopted] = 0)


SELECT [FY22 Adopted], [FY23 BoE]
FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
WHERE NOT([FY23 BoE] = 0 AND [FY22 Adopted] = 0)


SELECT SUM([ytd_exp]) AS 'FY22 YTD Expenditures'
FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]

SELECT * 
FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]
ORDER BY agency_id, program_id, fund_id
