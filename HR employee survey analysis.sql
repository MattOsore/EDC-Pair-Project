select * from survey_data;

-- counting the total number of rows in the table
SELECT COUNT(*) AS total_rows
FROM survey_data; 

-- counting how many responses are complete versus incomplete:
SELECT status, COUNT(*) AS response_count
FROM survey_data
GROUP BY status;

--counting the distribution of responses across the different departments
SELECT department, COUNT(*) AS response_count
FROM survey_data
GROUP BY department
ORDER BY response_count DESC;

--counting the number of responses from different job levels (Director, Manager, Supervisor, Staff)
SELECT 
    SUM(CAST(director AS INT)) AS director_count,
    SUM(CAST(manager AS INT)) AS manager_count,
    SUM(CAST(supervisor AS INT)) AS supervisor_count,
    SUM(CAST(staff AS INT)) AS staff_count
FROM survey_data;

--analyzing  respondents' job level for each department
SELECT 
    department,
    SUM(CAST(Director AS INT)) AS total_directors,
    SUM(CAST(Manager AS INT)) AS total_managers,
    SUM(CAST(Supervisor AS INT)) AS total_supervisors,
    SUM(CAST(Staff AS INT)) AS total_staff
FROM 
    survey_data
GROUP BY 
    department
ORDER BY 
    department;


--counts the number of responses given by each job level for each question.
SELECT 
    question,
    SUM(CAST(director AS INT)) AS director_count,
    SUM(CAST(manager AS INT)) AS manager_count,
    SUM(CAST(supervisor AS INT)) AS supervisor_count,
    SUM(CAST(staff AS INT)) AS staff_count
FROM survey_data
GROUP BY question
ORDER BY question;

--Computing the average response (on a scale of 0-4) for each of the 10 questions to see how employees generally feel about different aspects of their work environment:
SELECT question, AVG(response) AS avg_response
FROM survey_data
GROUP BY question
ORDER BY question;

--Finding the most frequent response for each of the 10 questions:
SELECT question, response_text, COUNT(*) AS frequency
FROM survey_data
GROUP BY question, response_text
ORDER BY question, frequency DESC;


--Analyzing the overall sentiment (Agree, Disagree, Strongly Agree, etc.) across all questions
SELECT response_text, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM survey_data) AS percentage
FROM survey_data
GROUP BY response_text
ORDER BY percentage DESC;

-- finding the highest and lowest average response for each question.
SELECT 
    question,
    MAX(CAST(response AS FLOAT)) AS highest_response,
    MIN(CAST(response AS FLOAT)) AS lowest_response
FROM survey_data
WHERE TRY_CAST(response AS INT) IS NOT NULL
GROUP BY question
ORDER BY question;


--computing the overall average response score across all questions
SELECT 
    AVG(CAST(response AS FLOAT)) AS overall_avg_response
FROM survey_data
WHERE TRY_CAST(response AS INT) IS NOT NULL;

--provides the total count of 'strongly agree' (4) and 'strongly disagree' (0) responses for each question.
SELECT 
    question,
    COUNT(CASE WHEN response = 4 THEN 1 END) AS strongly_agree_count,
    COUNT(CASE WHEN response = 0 THEN 1 END) AS strongly_disagree_count
FROM survey_data
GROUP BY question
ORDER BY question;

-- calculates the average response for each job level for a specific question
SELECT 
    CASE 
        WHEN director = 1 THEN 'Director'
        WHEN manager = 1 THEN 'Manager'
        WHEN supervisor = 1 THEN 'Supervisor'
        WHEN staff = 1 THEN 'Staff'
    END AS job_level,
    AVG(CAST(response AS FLOAT)) AS avg_response
FROM survey_data
WHERE TRY_CAST(response AS INT) IS NOT NULL
GROUP BY 
    CASE 
        WHEN director = 1 THEN 'Director'
        WHEN manager = 1 THEN 'Manager'
        WHEN supervisor = 1 THEN 'Supervisor'
        WHEN staff = 1 THEN 'Staff'
    END;

--analyzing the survey responses by both department and job level
SELECT 
    department,
    CASE 
        WHEN director = 1 THEN 'Director'
        WHEN manager = 1 THEN 'Manager'
        WHEN supervisor = 1 THEN 'Supervisor'
        WHEN staff = 1 THEN 'Staff'
    END AS job_level,
    COUNT(response) AS total_responses,
    AVG(CAST(response AS FLOAT)) AS avg_response
FROM survey_data
WHERE TRY_CAST(response AS INT) IS NOT NULL
GROUP BY 
    department,
    CASE 
        WHEN director = 1 THEN 'Director'
        WHEN manager = 1 THEN 'Manager'
        WHEN supervisor = 1 THEN 'Supervisor'
        WHEN staff = 1 THEN 'Staff'
    END
ORDER BY department, job_level;

--analyzing average responses to each question across different departments
SELECT 
    department,

    ROUND(AVG(CAST(CASE WHEN question = '1. I know what is expected of me at work' THEN response END AS FLOAT)), 0) AS avg_response_q1,
    ROUND(AVG(CAST(CASE WHEN question = '2. At work, I have the opportunity to do what I do best every day' THEN response END AS FLOAT)), 0) AS avg_response_q2,
    ROUND(AVG(CAST(CASE WHEN question = '3. In the last seven days, I have received recognition or praise for doing good work' THEN response END AS FLOAT)), 0) AS avg_response_q3,
    ROUND(AVG(CAST(CASE WHEN question = '4. My supervisor, or someone at work, seems to care about me as a person' THEN response END AS FLOAT)), 0) AS avg_response_q4,
    ROUND(AVG(CAST(CASE WHEN question = '5. The mission or purpose of our organization makes me feel my job is important' THEN response END AS FLOAT)), 0) AS avg_response_q5,
    ROUND(AVG(CAST(CASE WHEN question = '6. I have a best friend at work' THEN response END AS FLOAT)), 0) AS avg_response_q6,
    ROUND(AVG(CAST(CASE WHEN question = '7. This last year, I have had opportunities at work to learn & grow' THEN response END AS FLOAT)), 0) AS avg_response_q7,
    ROUND(AVG(CAST(CASE WHEN question = '8. My supervisor holds employees accountable for performance' THEN response END AS FLOAT)), 0) AS avg_response_q8,
    ROUND(AVG(CAST(CASE WHEN question = '9. My department is inclusive and demonstrates support of a diverse workforce' THEN response END AS FLOAT)), 0) AS avg_response_q9,
    ROUND(AVG(CAST(CASE WHEN question = '10. Overall I am satisfied with my job' THEN response END AS FLOAT)), 0) AS avg_response_q10

FROM 
    survey_data
WHERE 
    TRY_CAST(response AS INT) IS NOT NULL
GROUP BY 
    department
ORDER BY 
    department;

-- breakdown of response distribution for each question across different departments
SELECT 
    department,
    question,
    response,
    COUNT(response) AS response_count
FROM 
    survey_data
WHERE 
    TRY_CAST(response AS INT) IS NOT NULL
GROUP BY 
    department, question, response
ORDER BY 
    department, question;





























