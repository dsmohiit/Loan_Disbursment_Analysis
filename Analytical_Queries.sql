-- Total Loan Applications.
SELECT COUNT(id) AS "total_loan_applications" 
FROM bank_loan_analysis;

-- Last Month Loan Application (Month to Date).
SELECT COUNT(id) AS "MTD_total_loan_applications" 
FROM bank_loan_analysis
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

-- Month on Month Loan Application.
SELECT COUNT(id) "loan_applications", 
LAG(COUNT(id)) OVER(ORDER BY EXTRACT(MONTH FROM issue_date)) AS "prev_month_applications", 
EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;

-- Total Funded Amount.
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS "total_loan_amount" 
FROM bank_loan_analysis;

-- Month on Month Loan Amount.
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS "loan_amount", EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;

-- Total Amount Received.
SELECT SUM(total_payment) AS "total_amount_received" 
FROM bank_loan_analysis; 

-- Month on Month Amount Received.
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS "total_amount_received", EXTRACT(MONTH FROM issue_date) AS month 
FROM bank_loan_analysis
GROUP BY month
ORDER BY month;

-- Average Interest Rate.
SELECT ROUND((AVG(int_rate) * 100)::NUMERIC, 2) AS "avg_int_rate"
FROM bank_loan_analysis;

-- Average DTI (Debt To Income Ratio).
SELECT ROUND((AVG(dti) * 100)::NUMERIC, 2) AS "avg_dti"
FROM bank_loan_analysis;

-- Number of good loans.
SELECT COUNT(id) AS no_of_good_loans
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');

-- Percent of Good Loans.
SELECT 
	COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100 / COUNT(id) AS "good_loan_percentage"
FROM bank_loan_analysis;

-- Good loan funded.
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS good_loan_funded
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');

-- Good loan's total re-payment.
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS total_good_loan_repaid
FROM bank_loan_analysis
WHERE loan_status IN ('Fully Paid', 'Current');

-- Number of bad loans.
SELECT COUNT(id) AS no_of_bad_loans
FROM bank_loan_analysis
WHERE loan_status IN ('Charged Off');

-- Percent of Bad Loans
SELECT 
		COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100 / COUNT(id) AS "bad_loan_percentage"
FROM bank_loan_analysis;

-- Bad loan funded.
SELECT ROUND(SUM(loan_amount)::NUMERIC, 2) AS bad_loan_funded
FROM bank_loan_analysis
WHERE loan_status NOT IN ('Fully Paid', 'Current');

-- Bad loan's total re-payment.
SELECT ROUND(SUM(total_payment)::NUMERIC, 2) AS total_bad_loan_repaid
FROM bank_loan_analysis
WHERE loan_status NOT IN ('Fully Paid', 'Current');

-- Overall Loan Status Report.
SELECT loan_status,
	   COUNT(id) AS Loan_Count, 
	   ROUND(SUM(loan_amount)::NUMERIC, 2)  AS Total_Amount_Funded, 
       ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received,
	   ROUND(AVG(int_rate)::NUMERIC, 2) * 100 AS Avg_Interest_Rate,
	   ROUND(AVG(dti)::NUMERIC, 2) * 100 AS Avg_DTI
FROM bank_loan_analysis
GROUP BY loan_status
ORDER BY Total_Amount_Received DESC;

-- Month By Month Loan Status Report
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

-- Analysis By State.
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY address_state
ORDER BY Total_Amount_Received DESC;

-- Loan Report On The Basis of Term.
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY term
ORDER BY term;

-- Working History of Customer.
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY emp_length
ORDER BY Total_Amount_Received;

-- Purpose of Loan.
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	ROUND(SUM(loan_amount)::NUMERIC, 2) AS Total_Funded_Amount,
	ROUND(SUM(total_payment)::NUMERIC, 2) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY purpose
ORDER BY Total_Amount_Received;