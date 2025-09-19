use [QAECECRM_DA_MayFT1-2025-8-12-18-9]




select * from dbo.BlueCard;
select * from dbo.Contract;




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









