use [QAECECRM_DA_MayFT1-2025-8-12-18-9]


-- Collection table not found

select * from NationalAgency   -- isactive exist
select * from dbo.BlueCard  -- agentId exist
select * from dbo.Presenter -- agentId exist
select * from dbo.LuLineOfBusiness   -- isactive exist
select * from dbo.Lead -- agentId exist

select * from dbo.LuOffice
select * from dbo.LuExpensePaymentStatus
select * from dbo.LuExpensePaymentType
select * from dbo.LuLineOfBusiness
select * from dbo.Presenter -- isactive exist
select * from dbo.AgentCommission   
select * from dbo.AgentPayrollLog -- agentid, LOBid exist
select * from dbo.PayrollPayment   -- agentid exist
select * from dbo.ContractTransaction   -- agentid, LOB exist



-- Project Instructions
-- Time-Based Performance Trends
-- Monthly Revenue, Expense, Profit Trend

-- "What is the total revenue, expense, and profit grouped by month and year?"

select Year(a.CreatedDate) as ByYear,month(a.CreatedDate) as ByMonth, sum(a.GrossAmount) as TotalRevenue,
sum(a.NetAmount) as TotalExpense, (sum(a.GrossAmount) - sum(a.NetAmount)) as TotalProfit
from dbo.ContractTransaction c
inner join dbo.AgentPayrollLog a on c.ContractTransactionId = a.ContractTransactionId
group by month(a.CreatedDate), Year(a.CreatedDate)
order by ByYear, ByMonth;


-- Contracts, Leads, Blue Cards, and Collections

-- "How many contracts, leads, blue cards, collections per marketplace/month?"
select * from dbo.Lead;
select * from dbo.Contract;
select * from dbo.BlueCard;

-- Contracts, Leads, Blue Cards per month


with ContractCounts AS (
    select month(CreatedDate) AS MonthNumber,
           COUNT_BIG(*) AS TotalContracts
    from dbo.Contract
    group by  month(CreatedDate)
),
LeadCounts AS (
    select month(CreatedDate) AS MonthNumber,
           COUNT_BIG(*) AS TotalLeads
    from dbo.Lead
    group by month(CreatedDate)
),
BlueCardCounts AS (
    select month(CreatedDate) AS MonthNumber,
           COUNT_BIG(*) AS TotalBlueCards
    from dbo.BlueCard
    group by month(CreatedDate)
)
select 
    COALESCE(c.MonthNumber, l.MonthNumber, b.MonthNumber) AS MonthNumber,
    ISNULL(c.TotalContracts, 0) AS TotalContracts,
    ISNULL(l.TotalLeads,     0) AS TotalLeads,
    ISNULL(b.TotalBlueCards, 0) AS TotalBlueCards
from ContractCounts c
full OUTER JOIN LeadCounts    l ON c.MonthNumber = l.MonthNumber
full OUTER JOIN BlueCardCounts b ON COALESCE(c.MonthNumber, l.MonthNumber) = b.MonthNumber
order by  MonthNumber;



-- Drill-down by Company, Office, LOB, Agent, Presenter

-- "What are revenue and expense by company, office location, line of business, agent, and presenter?"

select * from dbo.LuOffice;
select * from dbo.BlueCard;

sp_help 'dbo.LuOffice';
sp_help 'dbo.BlueCard';
sp_help 'dbo.Presenter'
sp_help 'dbo.ContractTransaction';
sp_help 'dbo.AgentPayrollLog';
sp_help 'dbo.LuLineOfBusiness';






-- Company, Office, LOB, Agent, Presenter

-- "What are revenue and expense by company?"
select b.OrganizationName, sum(a.GrossAmount) as Reevenue, 
sum(a.NetAmount) as Expense
from dbo.BlueCard b
inner join AgentPayrollLog a on b.AgentId = a.AgentId
group by b.OrganizationName;


-- -- "What are revenue and expense by line of business?"

select l.LineOfBusinessId,  sum(a.GrossAmount) as Reevenue, sum(a.NetAmount) as Expense
from LuLineOfBusiness l
inner join AgentPayrollLog a on l.LineOfBusinessId = a.LineOfBusinessId
group by l.LineOfBusinessId;


-- -- "What are revenue and expense by presenter?"

select p.PresenterId, sum(a.GrossAmount) as Reevenue, sum(a.NetAmount) as Expense
from Presenter p
inner join AgentPayrollLog a on a.AgentId = p.AgentId
group by p.PresenterId;



-- -- "What are revenue and expense by office location?"

select l.Name, l.MailingAddress1,
sum(a.GrossAmount) as Revenue, sum(a.NetAmount) as Expense
from AgentPayrollLog a
inner join Contract c on a.ContractId = c.ContractId
inner join LuOffice l on l.OfficeId = c.OfficeId
group by l.Name, l.MailingAddress1;



-- "What is profit by company, office location, line of business, agent, and presenter?"


select b.OrganizationName, SUM(a.GrossAmount) - SUM(a.NetAmount) as Profit
from dbo.BlueCard b
inner join AgentPayrollLog a on b.AgentId = a.AgentId
group by b.OrganizationName;


select l.Name AS OfficeName, l.MailingAddress1, SUM(a.GrossAmount) - SUM(a.NetAmount) as Profit
from AgentPayrollLog a
inner join Contract c on a.ContractId = c.ContractId
inner join LuOffice l on l.OfficeId = c.OfficeId
group by l.Name, l.MailingAddress1;


select  l.LineOfBusinessId, l.Name AS LineOfBusinessName,
    SUM(a.GrossAmount) - SUM(a.NetAmount) AS Profit
from AgentPayrollLog a
inner join LuLineOfBusiness l on l.LineOfBusinessId = a.LineOfBusinessId
group by l.LineOfBusinessId, l.Name;



select p.PresenterId as Presenter, sum(a.GrossAmount) - sum(a.NetAmount) as Profit
from Presenter p
inner join AgentPayrollLog a on a.AgentId = p.AgentId
group by p.PresenterId;



-- Total Revenue by Agent

-- "What is the total revenue generated by each agent?"
select a.AgentId as Agent, sum(a.GrossAmount) as Total_Revenue
from AgentPayrollLog a
group by a.AgentId;

-- Year-over-Year Agent Revenue

-- "What is the revenue per agent per year?"
select a.AgentId, Year(a.CreatedDate) as RevenueYear, sum(a.GrossAmount) as Revenue
from AgentPayrollLog a 
group by a.AgentId, Year(a.CreatedDate)
order by a.AgentId, RevenueYear;


-- artist wise market sales
select * from AgentPayrollLog;
select * from BlueCardArtist;
select * from Artist;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Artist'
ORDER BY ORDINAL_POSITION;

select * from ContractTransaction;
select * from AgentPayrollLog;
select * from Artist;
select * from ContractArtist;
select * from BlueCardArtist;
select * from ExpensePayment;
select * from BlueCardArtist;
select * from dbo.BlueCard;
select * from AgentCommission;
select * from AppUser
where AppUserId=0;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ContractDeposit'
ORDER BY ORDINAL_POSITION;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BlueCard'
ORDER BY ORDINAL_POSITION;


SELECT 
    YEAR(CreatedDate) AS Year,
    MONTH(CreatedDate) AS Month,
    SUM(Gross) AS TotalRevenue,
    SUM(Net) AS TotalExpense,
    SUM(Gross - Net) AS TotalProfit
FROM 
    BlueCardArtist
WHERE 
    IsDeleted = 0
GROUP BY 
    YEAR(CreatedDate),
    MONTH(CreatedDate)
ORDER BY 
    Year, Month;



select * from contract;
select * from Lead;
select * from BlueCard;
select * from ContractArtist;
select * from ContractTransaction;

SELECT
    ca.ArtistId,
    ca.ArtistName,
    SUM(ca.Gross) AS TotalRevenue
FROM ContractArtist ca
GROUP BY ca.ArtistId, ca.ArtistName
ORDER BY TotalRevenue DESC;



SELECT 
    COALESCE(b.VenuePhysicalCity, c.VenuePhysicalCity, l.EventCity) AS Marketplace,
    FORMAT(COALESCE(c.CreatedDate, b.CreatedDate, l.CreatedDate), 'yyyy-MM') AS Month,
    COUNT(DISTINCT l.LeadId) AS Total_Leads,
    COUNT(DISTINCT b.BlueCardId) AS Total_BlueCards,
    COUNT(DISTINCT c.ContractId) AS Total_Contracts
FROM Lead l
LEFT JOIN BlueCard b ON l.LeadId = b.LeadId
LEFT JOIN Contract c ON b.BlueCardId = c.BlueCardId
GROUP BY 
    COALESCE(b.VenuePhysicalCity, c.VenuePhysicalCity, l.EventCity),
    FORMAT(COALESCE(c.CreatedDate, b.CreatedDate, l.CreatedDate), 'yyyy-MM')
ORDER BY Month, Marketplace;


-- Total revenue generated by each agent.


SELECT 
    ct.AgentId,
    SUM(ct.PaidAmount) AS Total_Revenue
FROM ContractTransaction ct
WHERE ct.IsExpense = 0 
GROUP BY ct.AgentId
ORDER BY Total_Revenue DESC;





-- Total revenue by marketplace or sales channel.


SELECT 
    ct.AgentId,
    YEAR(ct.PaidDate) AS Revenue_Year,
    SUM(ct.PaidAmount) AS Total_Revenue
FROM ContractTransaction ct
WHERE ct.IsExpense = 0 AND ct.PaidDate IS NOT NULL
GROUP BY ct.AgentId, YEAR(ct.PaidDate)
ORDER BY ct.AgentId, Revenue_Year;



;WITH yearly_customers AS (
    SELECT 
        ct.AgentId,
        YEAR(ct.PaidDate) AS Revenue_Year,
        COUNT(DISTINCT ct.ArtistId) AS Unique_Customers
    FROM ContractTransaction ct
    WHERE ct.PaidDate IS NOT NULL
    GROUP BY ct.AgentId, YEAR(ct.PaidDate)
)
SELECT 
    curr.AgentId,
    curr.Revenue_Year,
    curr.Unique_Customers AS Current_Year_Customers,
    prev.Unique_Customers AS Previous_Year_Customers,
    CASE 
        WHEN prev.Unique_Customers IS NULL OR prev.Unique_Customers = 0 THEN NULL
        ELSE ROUND(
            (curr.Unique_Customers - prev.Unique_Customers) * 100.0 / prev.Unique_Customers, 2
        )
    END AS Retention_Percentage
FROM yearly_customers curr
LEFT JOIN yearly_customers prev 
    ON curr.AgentId = prev.AgentId 
    AND curr.Revenue_Year = prev.Revenue_Year + 1
ORDER BY curr.AgentId, curr.Revenue_Year;


-- Year-over-year revenue trend per agent.


select * from BlueCard;

SELECT l.FirstName as Agent,SUM(ct.PaidAmount) AS Total_Revenue 
FROM ContractTransaction ct 
join Lead l on l.AgentId = ct.AgentId
WHERE ct.IsExpense = 0 
GROUP BY l.FirstName
ORDER BY Total_Revenue DESC;




-- Customer retention/attrition per agent per year.


WITH yearly_customers AS (
    SELECT 
        ct.AgentId,
        YEAR(ct.PaidDate) AS Revenue_Year,
        COUNT(DISTINCT ct.ArtistId) AS UniqueCustomers
    FROM dbo.ContractTransaction ct
    WHERE ct.PaidDate IS NOT NULL
    GROUP BY ct.AgentId, YEAR(ct.PaidDate)
),
joined_data AS (
    SELECT 
        curr.AgentId,
        curr.Revenue_Year,
        curr.UniqueCustomers AS CurrentYearCustomers,
        prev.UniqueCustomers AS PreviousYearCustomers
    FROM yearly_customers curr
    LEFT JOIN yearly_customers prev 
        ON curr.AgentId = prev.AgentId 
        AND curr.Revenue_Year = prev.Revenue_Year + 1
)
SELECT 
    jd.AgentId,
    jd.Revenue_Year,
    jd.CurrentYearCustomers,
    ISNULL(jd.PreviousYearCustomers, 0) AS PreviousYearCustomers,
    CASE 
        WHEN ISNULL(jd.PreviousYearCustomers, 0) = 0 THEN NULL
        ELSE ROUND(
            (jd.CurrentYearCustomers * 100.0 / jd.PreviousYearCustomers), 2
        )
    END AS Retention_Percentage,
    CASE 
        WHEN ISNULL(jd.PreviousYearCustomers, 0) = 0 THEN NULL
        WHEN jd.PreviousYearCustomers > jd.CurrentYearCustomers 
            THEN ROUND(
                (jd.PreviousYearCustomers - jd.CurrentYearCustomers) * 100.0 / jd.PreviousYearCustomers, 2
            )
        ELSE 0 
    END AS Attrition_Percentage
FROM joined_data jd
ORDER BY jd.AgentId, jd.Revenue_Year;