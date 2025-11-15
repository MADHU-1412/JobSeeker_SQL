
CREATE DATABASE jobportal_database;
USE jobportal_database;

-- job_seekers: candidates using the portal
CREATE TABLE job_seekers (
  seeker_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(150) UNIQUE,
  city VARCHAR(100),
  country VARCHAR(100),
  experience_years DECIMAL(3,1),
  current_title VARCHAR(120),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- companies
CREATE TABLE companies (
  company_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150),
  industry VARCHAR(100),
  size_bucket VARCHAR(50), -- e.g., 1-50,51-200,201-1000,1000+
  headquarters_city VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- recruiters (company-side users)
CREATE TABLE recruiters (
  recruiter_id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  name VARCHAR(120),
  email VARCHAR(150),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- jobs
CREATE TABLE jobs (
  job_id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  title VARCHAR(200),
  description TEXT,
  location_city VARCHAR(100),
  location_country VARCHAR(100),
  seniority VARCHAR(50), -- Junior/Mid/Senior/Lead
  employment_type VARCHAR(50), -- Full-time/Part-time/Contract
  salary_min INT,
  salary_max INT,
  posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- skills master
CREATE TABLE skills (
  skill_id INT AUTO_INCREMENT PRIMARY KEY,
  skill_name VARCHAR(100) UNIQUE
);

-- seeker_skills: many-to-many
CREATE TABLE seeker_skills (
  seeker_id INT,
  skill_id INT,
  proficiency ENUM('Beginner','Intermediate','Advanced','Expert'),
  PRIMARY KEY (seeker_id, skill_id),
  FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE,
  FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

-- job_required_skills
CREATE TABLE job_required_skills (
  job_id INT,
  skill_id INT,
  importance INT DEFAULT 1, -- 1-5
  PRIMARY KEY (job_id, skill_id),
  FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
  FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

-- applications
CREATE TABLE applications (
  app_id INT AUTO_INCREMENT PRIMARY KEY,
  job_id INT,
  seeker_id INT,
  applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Applied','Screening','Interview','Offered','Hired','Rejected','Withdrawn') DEFAULT 'Applied',
  source ENUM('Website','Mobile','Referral','Recruiter') DEFAULT 'Website',
  recruiter_id INT NULL,
  resume_text TEXT,
  last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
  FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE,
  FOREIGN KEY (recruiter_id) REFERENCES recruiters(recruiter_id) ON DELETE SET NULL
);

-- interviews
CREATE TABLE interviews (
  interview_id INT AUTO_INCREMENT PRIMARY KEY,
  app_id INT,
  scheduled_at DATETIME,
  interviewer VARCHAR(150),
  mode ENUM('Phone','Video','Onsite'),
  outcome ENUM('Pending','Passed','Failed','No-show') DEFAULT 'Pending',
  feedback TEXT,
  FOREIGN KEY (app_id) REFERENCES applications(app_id) ON DELETE CASCADE
);

-- hires table
CREATE TABLE hires (
  hire_id INT AUTO_INCREMENT PRIMARY KEY,
  app_id INT,
  hired_at DATETIME,
  starting_salary INT,
  job_title_at_hire VARCHAR(200),
  FOREIGN KEY (app_id) REFERENCES applications(app_id) ON DELETE CASCADE
);

-- messages (communication between seeker and recruiter)
CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  app_id INT,
  sender VARCHAR(100), -- 'seeker' or 'recruiter'
  body TEXT,
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (app_id) REFERENCES applications(app_id) ON DELETE CASCADE
);

-- Indexes for analytics
CREATE INDEX idx_jobs_posted_at ON jobs(posted_at);
CREATE INDEX idx_applications_applied_at ON applications(applied_at);
CREATE INDEX idx_app_status ON applications(status);
CREATE INDEX idx_seekers_created_at ON job_seekers(created_at);

-- Seed skills
INSERT IGNORE INTO skills (skill_name) VALUES
('SQL'),('Python'),('Data Analysis'),('Machine Learning'),('Communication'),
('Project Management'),('Java'),('C#'),('React'),('Node.js'),('AWS'),('Docker'),
('Kubernetes'),('Excel'),('Tableau'),('Power BI'),('NoSQL'),('Linux'),('DevOps'),
('Sales'),('Marketing'),('HR'),('Design'),('Product Management'),('Golang');

select * from skills;

-- Insert some companies
INSERT INTO companies (name, industry, size_bucket, headquarters_city) VALUES
('Centric Tech','Software', '201-1000','Bengaluru'),
('FinEdge Capital','Finance','51-200','Mumbai'),
('HealthSphere','Healthcare','201-1000','Hyderabad'),
('RetailRush','Retail','1001+','New Delhi'),
('EduWave','Education','51-200','Chennai'),
('CloudBridge','Cloud Services','201-1000','Bengaluru'),
('MarketMinds','Marketing','51-200','Pune'),
('LogiTrack','Logistics','201-1000','Kolkata'),
('GreenEnergy Co','Energy','51-200','Ahmedabad'),
('SafeHome','Real Estate','51-200','Coimbatore');

select * from companies; 

-- Recruiters (one per company, plus extras)
INSERT INTO recruiters (company_id,name,email) VALUES
(1,'Madhupriya','madhupriya@centric.example.com'),
(2,'Roshini','roshini@finedge.example.com'),
(3,'Rakshana','rakshana@healthsphere.example.com'),
(4,'Sri ragavi','sriragavi@retailrush.example.com'),
(5,'Manoranjan','manoranjan@eduwave.example.com'),
(6,'Sarath Srinivasan','sarath@cloudbridge.example.com'),
(7,'Suji','suji@marketminds.example.com'),
(8,'Arun','arun@logitrack.example.com'),
(9,'Hari priys','haripriya@greenenergy.example.com'),
(10,'Karthi','karthi@safehome.example.com');

select * from recruiters;

-- Helper tables for random names and locations
CREATE TABLE tmp_names (name VARCHAR(80));
INSERT INTO tmp_names (name) VALUES
('Arjun'),('Sneha'),('Karthik'),('Madhu'),('Priya'),('Vikram'),('Aisha'),('Ramesh'),('Anita'),('Suresh'),
('Neha'),('Rahul'),('Kavya'),('Rohit'),('Aparna'),('Divya'),('Amit'),('Sanjay'),('Leena'),('Pooja');

CREATE TABLE tmp_last (lname VARCHAR(80));
INSERT INTO tmp_last (lname) VALUES
('Sharma'),('Iyer'),('Reddy'),('Kumar'),('Singh'),('Das'),('Nair'),('Prasad'),('Patel'),('Garg'),
('Bose'),('Khan'),('Mehta'),('Roy'),('Joshi');

CREATE TABLE tmp_cities (city VARCHAR(80), country VARCHAR(80));
INSERT INTO tmp_cities VALUES
('Bengaluru','India'),('Mumbai','India'),('Chennai','India'),('Kolkata','India'),('Pune','India'),
('Hyderabad','India'),('Ahmedabad','India'),('Jaipur','India'),('Lucknow','India'),('Thiruvananthapuram','India');

-- Stored procedure to generate seekers
DROP PROCEDURE IF EXISTS gen_seekers;
DELIMITER $$
CREATE PROCEDURE gen_seekers(IN n INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  WHILE i < n DO
    INSERT INTO job_seekers (first_name,last_name,email,city,country,experience_years,current_title)
    SELECT
      (SELECT name FROM tmp_names ORDER BY RAND() LIMIT 1),
      (SELECT lname FROM tmp_last ORDER BY RAND() LIMIT 1),
      CONCAT('user',FLOOR(RAND()*1000000),'@example.com'),
      (SELECT city FROM tmp_cities ORDER BY RAND() LIMIT 1),
      (SELECT country FROM tmp_cities ORDER BY RAND() LIMIT 1),
      ROUND(RAND()*15,1),
      ELT(FLOOR(RAND()*6)+1,'Data Analyst','Software Engineer','Product Manager','Sales Executive','HR Specialist','UX Designer');
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

CALL gen_seekers(1200);

DROP PROCEDURE IF EXISTS assign_seeker_skills;
DELIMITER $$
CREATE PROCEDURE assign_seeker_skills()
BEGIN
  DECLARE s INT DEFAULT 1;
  DECLARE max_seeker INT;
  DECLARE lim INT;

  SELECT MAX(seeker_id) INTO max_seeker FROM job_seekers;

  WHILE s <= max_seeker DO
    -- Each seeker gets 2-7 skills
    SET lim = FLOOR(RAND()*6)+2;

    INSERT IGNORE INTO seeker_skills (seeker_id, skill_id, proficiency)
    SELECT s, skill_id, ELT(FLOOR(RAND()*4)+1,'Beginner','Intermediate','Advanced','Expert')
    FROM skills
    ORDER BY RAND()
    LIMIT lim;

    SET s = s + 1;
  END WHILE;
END$$
DELIMITER ;

CALL assign_seeker_skills();


DROP PROCEDURE IF EXISTS gen_jobs;
DELIMITER $$
CREATE PROCEDURE gen_jobs(IN num INT)
BEGIN
  DECLARE j INT DEFAULT 0;
  DECLARE comp_count INT;

  SELECT COUNT(*) INTO comp_count FROM companies;

  WHILE j < num DO
    INSERT INTO jobs (company_id, title, description, location_city, location_country, seniority, employment_type, salary_min, salary_max, posted_at)
    SELECT
      FLOOR(RAND()*comp_count)+1,
      ELT(FLOOR(RAND()*8)+1,'Data Analyst','Senior Data Analyst','Software Engineer','Backend Engineer','Product Manager','Sales Manager','HR Generalist','UX Researcher'),
      'Auto-generated job description for analytics and engineering positions.',
      (SELECT city FROM tmp_cities ORDER BY RAND() LIMIT 1),
      'India',
      ELT(FLOOR(RAND()*4)+1,'Junior','Mid','Senior','Lead'),
      ELT(FLOOR(RAND()*3)+1,'Full-time','Contract','Part-time'),
      FLOOR(RAND()*40000)+20000,
      FLOOR(RAND()*80000)+50000,
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*120) DAY);

    SET j = j + 1;
  END WHILE;
END$$
DELIMITER ;

CALL gen_jobs(300);


DROP PROCEDURE IF EXISTS assign_job_skills;
DELIMITER $$
CREATE PROCEDURE assign_job_skills()
BEGIN
  DECLARE j INT DEFAULT 1;
  DECLARE max_job INT;
  DECLARE lim INT;

  SELECT MAX(job_id) INTO max_job FROM jobs;

  WHILE j <= max_job DO
    SET lim = FLOOR(RAND()*6)+2;

    INSERT IGNORE INTO job_required_skills (job_id, skill_id, importance)
    SELECT j, skill_id, FLOOR(RAND()*5)+1
    FROM skills
    ORDER BY RAND()
    LIMIT lim;

    SET j = j + 1;
  END WHILE;
END$$
DELIMITER ;

CALL assign_job_skills();


-- Generate applications (~6 applications per job average)
DROP PROCEDURE IF EXISTS gen_applications;
DELIMITER $$
CREATE PROCEDURE gen_applications()
BEGIN
  DECLARE j INT DEFAULT 1;
  DECLARE max_job INT;
  DECLARE max_seeker INT;
  DECLARE num_apps INT;
  DECLARE s INT;

  SELECT MAX(job_id) INTO max_job FROM jobs;
  SELECT MAX(seeker_id) INTO max_seeker FROM job_seekers;

  WHILE j <= max_job DO
    SET num_apps = FLOOR(RAND()*10)+3; -- 3-12 apps per job

    SET s = 1;
    WHILE s <= num_apps DO
      INSERT INTO applications (job_id, seeker_id, applied_at, status, source, recruiter_id, resume_text)
      VALUES (
        j,
        FLOOR(RAND()*max_seeker)+1,
        DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*90) DAY),
        ELT(FLOOR(RAND()*7)+1,'Applied','Screening','Interview','Offered','Hired','Rejected','Withdrawn'),
        ELT(FLOOR(RAND()*4)+1,'Website','Mobile','Referral','Recruiter'),
        (SELECT recruiter_id FROM recruiters ORDER BY RAND() LIMIT 1),
        'Resume: candidate with experience'
      );

      SET s = s + 1;
    END WHILE;

    SET j = j + 1;
  END WHILE;
END$$
DELIMITER ;

CALL gen_applications();

-- Generate interviews for some applications
INSERT INTO interviews (app_id, scheduled_at, interviewer, mode, outcome)
SELECT a.app_id, DATE_ADD(a.applied_at, INTERVAL FLOOR(RAND()*14)+1 DAY),
  CONCAT('Interviewer ', FLOOR(RAND()*20)+1), ELT(FLOOR(RAND()*3)+1,'Phone','Video','Onsite'),
  ELT(FLOOR(RAND()*4)+1,'Pending','Passed','Failed','No-show')
FROM applications a
WHERE RAND() < 0.45; -- ~45% of applications get an interview

-- Generate some hires for apps with status 'Hired' or 'Offered' with some randomness
INSERT INTO hires (app_id,hired_at,starting_salary,job_title_at_hire)
SELECT a.app_id, DATE_ADD(a.applied_at, INTERVAL FLOOR(RAND()*40)+3 DAY),
  ROUND((j.salary_min + j.salary_max)/2), j.title
FROM applications a
JOIN jobs j ON a.job_id = j.job_id
WHERE a.status = 'Hired' OR (a.status='Offered' AND RAND() < 0.7);

-- Generate messages
INSERT INTO messages (app_id,sender,body)
SELECT a.app_id, ELT(FLOOR(RAND()*2)+1,'seeker','recruiter'), CONCAT('Auto message for application ', a.app_id)
FROM applications a
WHERE RAND() < 0.25;


-- 5.1 Conversion funnel: applications -> interviews -> offers -> hires per company

-- View for funnel counts per company
CREATE OR REPLACE VIEW company_funnel AS
WITH app_cte AS (
  SELECT c.company_id, c.name,
    COUNT(a.app_id) AS total_applications
  FROM companies c
  LEFT JOIN jobs j ON c.company_id = j.company_id
  LEFT JOIN applications a ON j.job_id = a.job_id
  GROUP BY c.company_id
), interview_cte AS (
  SELECT c.company_id, COUNT(i.interview_id) AS total_interviews
  FROM companies c
  LEFT JOIN jobs j ON c.company_id = j.company_id
  LEFT JOIN applications a ON j.job_id = a.job_id
  LEFT JOIN interviews i ON a.app_id = i.app_id
  GROUP BY c.company_id
), offer_cte AS (
  SELECT c.company_id, COUNT(a.app_id) AS total_offers
  FROM companies c
  LEFT JOIN jobs j ON c.company_id = j.company_id
  LEFT JOIN applications a ON j.job_id = a.job_id AND a.status='Offered'
  GROUP BY c.company_id
), hire_cte AS (
  SELECT c.company_id, COUNT(h.hire_id) AS total_hires
  FROM companies c
  LEFT JOIN jobs j ON c.company_id = j.company_id
  LEFT JOIN applications a ON j.job_id = a.job_id
  LEFT JOIN hires h ON a.app_id = h.app_id
  GROUP BY c.company_id
)
SELECT a.company_id, a.name, a.total_applications, IFNULL(i.total_interviews,0) AS total_interviews,
  IFNULL(o.total_offers,0) AS total_offers, IFNULL(h.total_hires,0) AS total_hires
FROM app_cte a
LEFT JOIN interview_cte i ON a.company_id = i.company_id
LEFT JOIN offer_cte o ON a.company_id = o.company_id
LEFT JOIN hire_cte h ON a.company_id = h.company_id;

-- 5.2 Top 10 skills in demand (by required job occurrences)
SELECT s.skill_name, COUNT(*) AS required_by_jobs
FROM job_required_skills jrs
JOIN skills s ON jrs.skill_id = s.skill_id
GROUP BY s.skill_id
ORDER BY required_by_jobs DESC
LIMIT 10;

-- 5.3 Skill-gap analysis: for each skill, compare # of jobs requiring it vs # of seekers with it
SELECT s.skill_name, COALESCE(job_cnt,0) AS jobs_requiring, COALESCE(seeker_cnt,0) AS seekers_with_skill,
  (COALESCE(job_cnt,0) - COALESCE(seeker_cnt,0)) AS gap
FROM skills s
LEFT JOIN (
  SELECT skill_id, COUNT(*) AS job_cnt FROM job_required_skills GROUP BY skill_id
) j ON s.skill_id = j.skill_id
LEFT JOIN (
  SELECT skill_id, COUNT(DISTINCT seeker_id) AS seeker_cnt FROM seeker_skills GROUP BY skill_id
) ss ON s.skill_id = ss.skill_id
ORDER BY gap DESC;

-- 5.4 Time-to-hire distribution: median days from applied_at to hired_at
WITH hires_with_days AS (
    SELECT h.hire_id, DATEDIFF(h.hired_at, a.applied_at) AS days_to_hire
    FROM hires h
    JOIN applications a ON h.app_id = a.app_id
),
ranked AS (
    SELECT days_to_hire,
           ROW_NUMBER() OVER (ORDER BY days_to_hire) AS rn,
           COUNT(*) OVER () AS total_count
    FROM hires_with_days
),
median_calc AS (
    SELECT days_to_hire
    FROM ranked
    WHERE rn IN (FLOOR((total_count+1)/2), CEIL((total_count+1)/2))
)
SELECT
    AVG(days_to_hire) AS median_days_to_hire,
    (SELECT AVG(days_to_hire) FROM hires_with_days) AS avg_days_to_hire,
    MIN(days_to_hire) AS min_days,
    MAX(days_to_hire) AS max_days
FROM median_calc;

-- 5.5 Top performing recruiters by hires/offer ratio
SELECT r.recruiter_id, r.name, c.name AS company, 
  COUNT(DISTINCT h.hire_id) AS hires,
  SUM(CASE WHEN a.status='Offered' THEN 1 ELSE 0 END) AS offers,
  ROUND(COUNT(DISTINCT h.hire_id) / GREATEST(SUM(CASE WHEN a.status='Offered' THEN 1 ELSE 0 END),1),2) AS hire_offer_ratio
FROM recruiters r
LEFT JOIN applications a ON r.recruiter_id = a.recruiter_id
LEFT JOIN hires h ON a.app_id = h.app_id
LEFT JOIN companies c ON r.company_id = c.company_id
GROUP BY r.recruiter_id
ORDER BY hire_offer_ratio DESC
LIMIT 10;

-- 5.6 Candidate funnel cohort analysis: monthly cohorts of applicants and % hired within 90 days
WITH monthly_cohort AS (
  SELECT DATE_FORMAT(applied_at,'%Y-%m') AS cohort_month, seeker_id, MIN(applied_at) AS first_apply
  FROM applications
  GROUP BY seeker_id, DATE_FORMAT(applied_at,'%Y-%m')
), hires_in_90 AS (
  SELECT a.seeker_id, DATE_FORMAT(a.applied_at,'%Y-%m') AS cohort_month,
    CASE WHEN EXISTS (
      SELECT 1 FROM hires h JOIN applications a2 ON h.app_id = a2.app_id
      WHERE a2.seeker_id = a.seeker_id AND DATEDIFF(h.hired_at,a.applied_at) <= 90
    ) THEN 1 ELSE 0 END AS hired_within_90
  FROM applications a
)
SELECT m.cohort_month, COUNT(DISTINCT m.seeker_id) AS applicants,
  SUM(h.hired_within_90) AS hired_within_90,
  ROUND(100*SUM(h.hired_within_90)/GREATEST(COUNT(DISTINCT m.seeker_id),1),2) AS pct_hired_within_90
FROM monthly_cohort m
LEFT JOIN hires_in_90 h ON m.cohort_month = h.cohort_month AND m.seeker_id = h.seeker_id
GROUP BY m.cohort_month
ORDER BY m.cohort_month DESC
LIMIT 12;

-- 5.7 Recommend top 5 candidate matches for a job (skill overlap + experience proximity)
-- For a given job_id (example: 10), find top 5 seekers
SELECT js.seeker_id, CONCAT(js.first_name,' ',js.last_name) AS name, js.experience_years,
  COUNT(DISTINCT jrs.skill_id) AS matching_skills,
  ROUND((COUNT(DISTINCT jrs.skill_id) * 2) + (1/ (1+ABS(js.experience_years - 3))) ,2) AS score
FROM job_required_skills jrs
JOIN seeker_skills ss ON jrs.skill_id = ss.skill_id
JOIN job_seekers js ON ss.seeker_id = js.seeker_id
WHERE jrs.job_id = 10
GROUP BY js.seeker_id
ORDER BY score DESC
LIMIT 5;

-- 5.8 Applications aging and SLA breaches (e.g., >7 days without reply or status change)
SELECT a.app_id, a.job_id, a.seeker_id, a.status, DATEDIFF(NOW(), a.last_updated) AS days_since_update
FROM applications a
WHERE DATEDIFF(NOW(), a.last_updated) > 7
ORDER BY days_since_update DESC
LIMIT 50;

-- 5.9 Top locations by number of open roles (active jobs)
SELECT location_city, location_country, COUNT(*) AS open_roles
FROM jobs WHERE is_active = 1
GROUP BY location_city, location_country
ORDER BY open_roles DESC
LIMIT 10;

-- 5.10 Salary distribution by seniority (percentiles)
WITH salary_stats AS (
    SELECT seniority, (salary_min + salary_max)/2 AS avg_salary
    FROM jobs
    WHERE salary_min IS NOT NULL
),
ranked AS (
    SELECT seniority, avg_salary,
           ROW_NUMBER() OVER (PARTITION BY seniority ORDER BY avg_salary) AS rn,
           COUNT(*) OVER (PARTITION BY seniority) AS total_count
    FROM salary_stats
)
SELECT
    seniority,
    AVG(CASE WHEN rn = FLOOR(0.25 * total_count) OR rn = CEIL(0.25 * total_count) THEN avg_salary END) AS p25,
    AVG(CASE WHEN rn = FLOOR(0.5 * total_count) OR rn = CEIL(0.5 * total_count) THEN avg_salary END) AS median,
    AVG(CASE WHEN rn = FLOOR(0.75 * total_count) OR rn = CEIL(0.75 * total_count) THEN avg_salary END) AS p75,
    MIN(avg_salary) AS min_salary,
    MAX(avg_salary) AS max_salary
FROM ranked
GROUP BY seniority;


-- View: candidate_profile_summary
CREATE OR REPLACE VIEW candidate_profile_summary AS
SELECT js.seeker_id, CONCAT(js.first_name,' ',js.last_name) AS name, js.email, js.city, js.country, js.experience_years,
  COUNT(DISTINCT ss.skill_id) AS skill_count,
  GROUP_CONCAT(DISTINCT s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS skills
FROM job_seekers js
LEFT JOIN seeker_skills ss ON js.seeker_id = ss.seeker_id
LEFT JOIN skills s ON ss.skill_id = s.skill_id
GROUP BY js.seeker_id;

-- Stored proc: change_application_status (logs on status change)
CREATE TABLE IF NOT EXISTS application_status_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  app_id INT,
  old_status VARCHAR(50),
  new_status VARCHAR(50),
  changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS change_application_status;
DELIMITER $$
CREATE PROCEDURE change_application_status(IN app INT, IN newstat VARCHAR(50))
BEGIN
  DECLARE oldstat VARCHAR(50);
  SELECT status INTO oldstat FROM applications WHERE app_id = app;
  IF oldstat IS NOT NULL THEN
    UPDATE applications SET status = newstat WHERE app_id = app;
    INSERT INTO application_status_log (app_id, old_status, new_status) VALUES (app, oldstat, newstat);
  END IF;
END$$
DELIMITER ;

-- Trigger: auto-insert into hires if application becomes 'Hired'
DROP TRIGGER IF EXISTS after_app_status_update;
DELIMITER $$
CREATE TRIGGER after_app_status_update
AFTER UPDATE ON applications
FOR EACH ROW
BEGIN
  IF NEW.status = 'Hired' AND (OLD.status <> 'Hired') THEN
    INSERT INTO hires (app_id, hired_at, starting_salary, job_title_at_hire)
    SELECT NEW.app_id, NOW(), ROUND((j.salary_min+j.salary_max)/2), j.title FROM jobs j WHERE j.job_id = NEW.job_id;
  END IF;
END$$
DELIMITER ;


CREATE TABLE IF NOT EXISTS daily_applications_summary AS
SELECT DATE(applied_at) AS dt, COUNT(*) AS applications
FROM applications
GROUP BY DATE(applied_at);

--CTE: Applications per Job

WITH job_app_count AS (
    SELECT 
        job_id,
        COUNT(*) AS total_applications
    FROM applications
    GROUP BY job_id
)
SELECT 
    j.job_id,
    j.title,
    j.category,
    j.location,
    total_applications
FROM job_app_count jc
JOIN jobs j ON jc.job_id = j.job_id
ORDER BY total_applications DESC;


--Window Function: Rank Jobs by Popularity

SELECT 
    j.job_id,
    j.title,
    COUNT(a.application_id) AS apps,
    RANK() OVER(ORDER BY COUNT(a.application_id) DESC) AS popularity_rank
FROM jobs j
LEFT JOIN applications a ON j.job_id = a.job_id
GROUP BY j.job_id, j.title;

--Window Function: Candidate Activity Ranking

SELECT 
    c.candidate_id,
    c.name,
    COUNT(a.application_id) AS total_applied,
    DENSE_RANK() OVER(ORDER BY COUNT(a.application_id) DESC) AS activity_rank
FROM candidates c
LEFT JOIN applications a ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.name;


--KPI: Hire Rate & Shortlist Rate

SELECT 
    job_id,
    ROUND(SUM(CASE WHEN status = 'Shortlisted' THEN 1 END) * 100.0 / COUNT(*), 2) AS shortlist_rate,
    ROUND(SUM(CASE WHEN status = 'Hired' THEN 1 END) * 100.0 / COUNT(*), 2) AS hire_rate
FROM applications
GROUP BY job_id;


--Time-Series: Applications Per Month

SELECT 
    DATE_FORMAT(apply_date, '%Y-%m') AS month,
    COUNT(*) AS applications
FROM applications
GROUP BY month
ORDER BY month;


--Experience vs Success Rate

SELECT 
    c.experience_years,
    ROUND(SUM(CASE WHEN a.status = 'Hired' THEN 1 END) * 100.0 / COUNT(*), 2) AS hire_rate
FROM candidates c
JOIN applications a ON c.candidate_id = a.candidate_id
GROUP BY c.experience_years
ORDER BY experience_years;
