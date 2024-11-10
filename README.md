# Loan_Disbursment_Analysis

## Project Overview

**Project Title**: Loan Disbursment Analysis   

This project provides an in-depth analysis of loan applications, funding trends, and repayment performance based on data from the `loan_disbursment_analysis` table. 
The goal is to generate actionable insights about loan application volume, funded amounts, repayment rates, loan quality (good vs. bad loans), and demographic breakdowns such as state and employment length. 
This data-driven approach will support decision-making in optimizing loan approval processes, identifying trends, and enhancing customer segmentation.

![Library_project](https://github.com/dsmohiit/Loan_Disbursment_Analysis/blob/main/360_F_419885324_JKHW8JXx5hRYo8V8NKThb6MV8i3BLgaV.jpg)

## Objectives

1. **Loan Application Volume Analysis**
2. **Funding and Repayment Analysis**
3. **Detailed Loan Status Report**
4. **State-Level and Demographic Insights**

# Project Structure

## Database Creation:

```sql
CREATE TABLE bank_loan_analysis (
	id INT4,
	address_state VARCHAR(20),
	application_type VARCHAR(50),
	emp_length VARCHAR(50),
	emp_title VARCHAR(100),
	grade VARCHAR(10),
	home_ownership VARCHAR(100),
	issue_date DATE,
	last_credit_pull_date DATE,
	last_payment_date DATE,
	loan_status VARCHAR(50),
	next_payment_date DATE,
	member_id INT,
	purpose VARCHAR(50),
	sub_grade VARCHAR(10),
	term VARCHAR(50),
	verification_status VARCHAR(100),
	annual_income FLOAT4,
	dti FLOAT4,
	installment FLOAT4,  
	int_rate FLOAT4,
	loan_amount FLOAT4,
	total_acc FLOAT4,
	total_payment FLOAT4
);

SELECT * FROM bank_loan_analysis;
```

## Analytical Queries:

**1: Total Loan Applications** 
```sql
SELECT COUNT(id) AS "total_loan_applications" 
FROM bank_loan_analysis;
```

**2: Last Month Loan Application (Month to Date)**
```sql
SELECT COUNT(id) AS "MTD_total_loan_applications" 
FROM bank_loan_analysis
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;
```

**3: Month on Month Loan Application**
```sql
SELECT COUNT(id) "loan_applications", 
LAG(COUNT(id)) OVER(ORDER BY EXTRACT(MONTH FROM issue_date)) AS "prev_month_applications", 
EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;
```

**4: Total Funded Amount**
```sql
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS "total_loan_amount" 
FROM bank_loan_analysis;
```

**5: Month on Month Loan Amount**
```sql
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS "loan_amount", EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;
```

**6: Total Amount Received**
```sql
SELECT SUM(total_payment) AS "total_amount_received" 
FROM bank_loan_analysis;
```

**7: Month on Month Amount Received**
```sql
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS "total_amount_received", EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;
```

**8: Average Interest Rate**
```sql
SELECT ROUND((AVG(int_rate) * 100)::NUMERIC, 2) AS "avg_int_rate"
FROM bank_loan_analysis;
```

**9: Average DTI (Debt To Income Ratio)**
```sql
SELECT ROUND((AVG(dti) * 100)::NUMERIC, 2) AS "avg_dti"
FROM bank_loan_analysis;
```

**10: Number of Good Loans**
```sql
SELECT COUNT(id) AS no_of_good_loans
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');
```

**11: Percent of Good Loans**
```sql
SELECT 
	COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100 / COUNT(id) AS "good_loan_percentage"
FROM bank_loan_analysis;
```

**12: Good Loan Funded**
```sql
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS good_loan_funded
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');
```

**13: Good Loan's Total Re-payment**
```sql
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS total_good_loan_repaid
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');
```

**14: Number of Bad Loans**
```sql
SELECT COUNT(id) AS no_of_bad_loans
FROM bank_loan_analysis
WHERE loan_status IN ('Charged Off');
```

**15: Percent of Bad Loans**
```SQL
SELECT 
		COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100 / COUNT(id) AS "bad_loan_percentage"
FROM bank_loan_analysis;
```

**16: Bad Loan Funded**
```sql
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS bad_loan_funded
FROM bank_loan_analysis
WHERE loan_status NOT IN ('Fully Paid', 'Current');
```

**17: Bad Loan's Total Re-payment**
```SQL
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS total_bad_loan_repaid
FROM bank_loan_analysis
WHERE loan_status NOT IN ('Fully Paid', 'Current');
```

**18: Overall Loan Status Report**
```sql
SELECT loan_status,
	   COUNT(id) AS Loan_Count, 
	   ROUND(SUM(loan_amount)::NUMERIC, 2)  AS Total_Amount_Funded, 
       ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received,
	   ROUND(AVG(int_rate)::NUMERIC, 2) * 100 AS Avg_Interest_Rate,
	   ROUND(AVG(dti)::NUMERIC, 2) * 100 AS Avg_DTI
FROM bank_loan_analysis
GROUP BY loan_status
ORDER BY Total_Amount_Received DESC;
```

**19: Month By Month Loan Status Report**
```sql
SELECT EXTRACT(MONTH FROM issue_date) AS Month_Number,
       TO_CHAR(issue_date, 'Month') AS Month_Name,
       COUNT(id) AS Loan_Count, 
       ROUND(SUM(loan_amount)::NUMERIC, 2)  AS Total_Amount_Funded, 
       ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received,
       ROUND(AVG(int_rate)::NUMERIC, 2) * 100 AS Avg_Interest_Rate,
       ROUND(AVG(dti)::NUMERIC, 2) * 100 AS Avg_DTI
FROM bank_loan_analysis
GROUP BY EXTRACT(MONTH FROM issue_date), TO_CHAR(issue_date, 'Month')
ORDER BY month_number;
```

**20: Analysis By State**
```sql
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY address_state
ORDER BY Total_Amount_Received DESC;
```

**21: Loan Report On The Basis of Term**
```sql
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY term
ORDER BY term;
```

**22: Working History of Customer**
```sql
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY emp_length
ORDER BY Total_Amount_Received;
```

**23: Purpose of Loan**
```sql
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY purpose
ORDER BY Total_Amount_Received;
```

## Expected Outcomes
1. **Comprehensive monthly and overall loan performance reports.**
2. **Insights into state-wise loan applications and funding patterns.**
3. **Analysis to guide adjustments in loan approval criteria and optimize targeting strategies based on loan purpose and borrower demographics.**
4. **Identification of potential risk factors and success metrics associated with good and bad loans.**

**This analysis will help the banks optimize its loan product offerings, improve customer segmentation, and strengthen risk management by understanding key patterns and trends in loan applications, funding, and repayment.**

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone https://github.com/dsmohiit/Loan_Disbursment_Analysis.git
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `Insert.sql`.
3. **Run the Queries**: Use the SQL queries in the `Analytical_Queries.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - Mohit Soni

This project showcases SQL skills essential for database management and analysis.
