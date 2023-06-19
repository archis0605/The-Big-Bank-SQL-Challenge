/* 1. What are the names of all the customers who live in New York? */
select concat(firstname, " ", lastname) as name
from customers
where city = "New York";

/* 2. What is the total number of accounts in the Accounts table? */
select count(*) as total_accounts
from accounts;

/* 3. What is the total balance of all checking accounts? */
select sum(balance) as total_balance
from accounts
where accounttype = "Checking";

/* 4. What is the total balance of all accounts associated with customers who live in Los Angeles? */
select sum(balance) as total_balance
from accounts a
inner join customers c using(customerid)
where c.city = "Los Angeles";

/* 5. Which branch has the highest average account balance? */
select branchid, round(avg(balance),2) as average_balance
from accounts
group by 1 order by 2 limit 1;

/* 6. Which customer has the highest current balance in their accounts? */
select concat(firstname, " ", lastname) as fullname, max(balance) as highest_current_balance
from accounts a
inner join customers c using(customerid)
where a.accounttype = "Checking"
group by 1 order by 2 desc limit 1;

/* 7. Which customer has made the most transactions in the Transactions table? */
select concat(firstname," ", lastname) as fullname
from customers
where customerid in (
	with cte as (
		select a.customerid, count(*) as no_of_transactions
		from transactions t
		inner join accounts a using(accountid)
		group by 1)
	select customerid
	from cte
	where no_of_transactions = (select max(no_of_transactions) from cte)
);

/* 8.Which branch has the highest total balance across all of its accounts? */
select b.branchname, sum(balance) as total_balance
from accounts a
inner join branches b using(branchid)
group by 1 order by 2 desc limit 1;

/* 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts? */
select concat(firstname," ", lastname) as fullname, sum(balance) as total_balance
from accounts a
inner join customers c using(customerid)
where a.accounttype in ("Savings", "Checking")
group by 1 order by 2 desc limit 1;

/* 10. Which branch has the highest number of transactions in the Transactions table? */
select branchname
from branches
where branchid in (
	with cte as (
		select branchid, count(distinct transactionid) as no_of_transaction
		from transactions t
		left join accounts a using(accountid)
		group by 1)
	select branchid
	from cte
	where no_of_transaction = (select max(no_of_transaction) from cte)
);