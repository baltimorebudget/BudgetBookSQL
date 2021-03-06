-->>>>>>>>>>>>>>>>>>>>>>>>>TOTALS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

--Operating Budget
 SELECT FORMAT(SUM([FY23 BOE]), 'C0', 'en-us') AS 'FY23 Budget', FORMAT(SUM([FY22 Adopted]), 'C0', 'en-us') AS 'FY22 Budget'
 FROM [Finance_BPFS].[planningyear23].[LINE_ITEM_REPORT_BOE]

 --Expenditures
 SELECT FORMAT(SUM([ytd_exp]), 'C0', 'en-us') AS 'FY22 YTD Expenditures', FORMAT(SUM([prior_ytd_actual]), 'C0', 'en-us') AS 'FY21 YTD Expenditures'
 FROM [Finance_BPFS].[planningyear23].[CURRENT_YEAR_EXPENDITURE]