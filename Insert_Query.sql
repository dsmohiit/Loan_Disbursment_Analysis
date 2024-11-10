-- CREATING TABLE
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

