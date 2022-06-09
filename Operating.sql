--///////////////////////Operating Budget Current and Historical//////////////////
--utf8 encoding for service name
--service changes missing?
DECLARE @Phase VARCHAR(10) = 'BOE'

-->>>>>>>>>>>>>>>>>>>>>AGENCY AND FUND<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

SELECT CASE WHEN A.[Agency Name] IS NULL THEN B.agency_name
		WHEN B.agency_name IS NULL THEN A.[Agency Name]
		ELSE A.[Agency Name] END AS 'Agency Name',
		CASE WHEN A.[Fund Name] IS NULL THEN B.fund_name
		WHEN B.fund_name IS NULL THEN A.[Fund Name]
		ELSE A.[Fund Name] END AS 'Fund Name',
		A.[FY22 Budget], B.[FY22 YTD Expenditures], A.[FY23 Budget]
FROM(
	SELECT [Agency Name], [Fund Name], 
	FORMAT(SUM([FY23 BOE]), 'C', 'en-us') AS 'FY23 Budget', 
	FORMAT(SUM([FY22 Adopted]), 'C', 'en-us') AS 'FY22 Budget'
	 FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]
	 GROUP BY [Agency Name], [Fund Name]) A
FULL JOIN (
	SELECT agency_name, fund_name, FORMAT(SUM([ytd_exp]), 'C', 'en-us') AS 'FY22 YTD Expenditures'
	FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]
	GROUP BY agency_name, fund_name) B
ON (A.[Agency Name] = B.agency_name AND A.[Fund Name] = B.fund_name)


-->>>>>>>>>>>>>>>>>>PILLAR AND SERVICE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--