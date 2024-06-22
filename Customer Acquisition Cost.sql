-- Creating database to upload and create the necessary tables
create database customer;

-- Let's have a look at the uploaded table
select * from customer_acquisition_cost_dataset;

-- Let's see how much has been spent for each category of marketing
select Marketing_Channel, sum(Marketing_Spend) as total_spend from customer_acquisition_cost_dataset
group by Marketing_Channel 
order by total_spend desc;
-- So, the Marketing_Spend of Referral is the highest and social media is the lowest.

-- Calculating the cost spent to acquire one customer
select *, Marketing_Spend/New_Customers as CAC from customer_acquisition_cost_dataset;

-- Creating a new table to include the new column
create table customer_acquisition as
select *, Marketing_Spend/New_Customers as CAC from customer_acquisition_cost_dataset;

-- Let's have a look at the new table
select * from customer_acquisition;

-- Calculating the CAC for each marketing category 
select Marketing_Channel, sum(CAC) 
from customer_acquisition  
group by Marketing_Channel 
order by 2 desc;
-- So, the customer acquisition cost of Email marketing is the highest and social media is the lowest.

-- Let's find out the relation b/w no. of new customers acquired and the CAC
select New_Customers, sum(CAC) from customer_acquisition 
group by New_Customers 
order by 1 desc;
-- It's clear that as the no. of new customers are increasing, the CAC is decreasing. 
-- Which means as marketing efforts become more effective in acquiring customers, the cost per customer tends to decrease.

-- We will have a look at the Descriptive Statistics of our data
select Marketing_Channel, 
count(CAC) as count, avg(CAC) as mean, 
std(CAC) as sd, min(CAC) as min, max(CAC) as max 
from customer_acquisition 
group by Marketing_Channel;
-- Use the mean CAC values to compare the average cost of customer acquisition across different Marketing Channels.
-- Use the standard deviation to assess the consistency of CAC within each channel.
-- Likewise, the minimum and maximum CAC values give you an idea of the range of costs associated with each channel, helping you understand the potential cost extremes.

-- Creating a new table to include the new column
create table customer_acquisition_data as 
select *, (New_Customers/Marketing_Spend) * 100 as Conversion_Rate 
from customer_acquisition; 

-- Let's have a look at the new table
select * from customer_acquisition_data;
-- Here as you can see we have a new column Conversion Rate
-- It's basically the calculation of how many are acquired by spending 100 units of money.

-- We will have a look at the Total Conversion Rate for each Marketing Channel
select Marketing_Channel, sum(Conversion_Rate) as Total_Conversion_Rate 
from customer_acquisition_data 
group by Marketing_Channel;
-- We can see how many customers are acquired through each marketing channel by spending 100 uits of money.

-- We will calculate the Break-even customers for this marketing campaign
select *, Marketing_Spend/CAC as Break_Even_Customers from customer_acquisition_data;
-- Break-even customers refer to the number of new customers that a company needs to acquire 
-- through a specific marketing channel to cover the costs associated with that marketing channel.

-- Let's create a new table to include the new column
create table customer_acquisition_cost_data as 
select *, Marketing_Spend/CAC as Break_Even_Customers from customer_acquisition_data;

-- Let's have a look at our data
select * from customer_acquisition_cost_data;
-- So, this shows a positive result of the marketing campaign as the actual customers 
-- acquired from all marketing channels exactly match the break-even customers.

-- If the actual customers acquired were short of the break-even point, it would have indicated a need 
-- to reassess marketing strategies or allocate additional resources to those channels.