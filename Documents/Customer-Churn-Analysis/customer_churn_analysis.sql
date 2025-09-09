DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
    customerID TEXT,
    gender TEXT,
    SeniorCitizen TEXT,
    Partner TEXT,
    Dependents TEXT,
    tenure TEXT,
    PhoneService TEXT,
    MultipleLines TEXT,
    InternetService TEXT,
    OnlineSecurity TEXT,
    OnlineBackup TEXT,
    DeviceProtection TEXT,
    TechSupport TEXT,
    StreamingTV TEXT,
    StreamingMovies TEXT,
    Contract TEXT,
    
    PaperlessBilling TEXT,
    PaymentMethod TEXT,
    MonthlyCharges TEXT,
    TotalCharges TEXT,
    Churn TEXT
);


INSERT INTO customer_new (
    customerID, gender, SeniorCitizen, Partner, Dependents,
    tenure, PhoneService, MultipleLines, InternetService,
    OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport,
    StreamingTV, StreamingMovies, Contract, PaperlessBilling,
    PaymentMethod, MonthlyCharges, TotalCharges, Churn
)
SELECT
    TRIM(customerID),
    TRIM(gender),
    NULLIF(SeniorCitizen, '')::INT,
    TRIM(Partner),
    TRIM(Dependents),
    NULLIF(tenure, '')::INT,
    TRIM(PhoneService),
    TRIM(MultipleLines),
    TRIM(InternetService),
    TRIM(OnlineSecurity),
    TRIM(OnlineBackup),
    TRIM(DeviceProtection),
    TRIM(TechSupport),
    TRIM(StreamingTV),
    TRIM(StreamingMovies),
    TRIM(Contract),
    TRIM(PaperlessBilling),
    TRIM(PaymentMethod),
    NULLIF(MonthlyCharges, '')::NUMERIC,
    NULLIF(TotalCharges, '')::NUMERIC,
    TRIM(Churn)
FROM raw_customers;


DELETE FROM raw_customers
WHERE customerID = 'customerID';




INSERT INTO customer_new (
    customerID, gender, SeniorCitizen, Partner, Dependents,
    tenure, PhoneService, MultipleLines, InternetService,
    OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport,
    StreamingTV, StreamingMovies, Contract, PaperlessBilling,
    PaymentMethod, MonthlyCharges, TotalCharges, Churn
)
SELECT
    TRIM(customerID),
    TRIM(gender),
    NULLIF(TRIM(SeniorCitizen), '')::INT,
    TRIM(Partner),
    TRIM(Dependents),
    NULLIF(TRIM(tenure), '')::INT,
    TRIM(PhoneService),
    TRIM(MultipleLines),
    TRIM(InternetService),
    TRIM(OnlineSecurity),
    TRIM(OnlineBackup),
    TRIM(DeviceProtection),
    TRIM(TechSupport),
    TRIM(StreamingTV),
    TRIM(StreamingMovies),
    TRIM(Contract),
    TRIM(PaperlessBilling),
    TRIM(PaymentMethod),
    NULLIF(TRIM(MonthlyCharges), '')::NUMERIC,
    NULLIF(TRIM(TotalCharges), '')::NUMERIC,
    TRIM(Churn)
FROM raw_customers;

SELECT COUNT(*) FROM customer_new;
SELECT * FROM customer_new LIMIT 10;

SELECT COUNT(*) AS total_customers
FROM customer_new;

SELECT gender, COUNT(*) AS count
FROM customer_new
GROUP BY gender;

SELECT SeniorCitizen, COUNT(*) AS count
FROM customer_new
GROUP BY SeniorCitizen;

--Average tenure (in months)
SELECT ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM customer_new;

--Average monthly and total charges
SELECT 
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly,
    ROUND(AVG(TotalCharges), 2) AS avg_total
FROM customer_new;

--Churn distribution
SELECT Churn, COUNT(*) AS count
FROM customer_new
GROUP BY Churn;

--Overall churn rate 
SELECT 
    ROUND(100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM customer_new;


-- Churn by Contract Type
SELECT
  TRIM(Contract) AS contract,
  COUNT(*) AS total_customers,
  COUNT(*) FILTER (WHERE TRIM(UPPER(Churn)) = 'YES') AS churned_customers,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE TRIM(UPPER(Churn)) = 'YES')::numeric
    / NULLIF(COUNT(*),0), 2
  ) AS churn_percent
FROM customer_new
GROUP BY TRIM(Contract)
ORDER BY churn_percent DESC;

--Churn by Payment Method
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_percent
FROM customer_new
GROUP BY PaymentMethod
ORDER BY churn_percent DESC;


--Churn by Internet Service
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_percent
FROM customer_new
GROUP BY InternetService
ORDER BY churn_percent DESC;






