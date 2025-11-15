# 📊 Job Seeker SQL Analysis  
A complete SQL-based Exploratory Data Analysis (EDA) project focusing on job seekers, job listings, and job application behavior.  
This project demonstrates analytics skills relevant to HR Analytics, Recruitment Analytics, and Workforce Insights.

---

## 🔍 Project Overview  
The goal of this project is to extract insights from job seeker and application data using SQL.  
It helps answer business questions such as:

- Which job roles attract the highest number of applicants?
- How many applications does each candidate submit on average?
- Which categories or locations have the highest job demand?
- What are the applicant success metrics (shortlist/hire rates)?
- Which job types or candidates perform better?

---

## 🗂️ Dataset Structure  
This project assumes the following tables:

### **1. jobs**
| Column | Description |
|--------|-------------|
| job_id | Unique job identifier |
| title | Job title/role |
| category | Job category (IT, Finance, Marketing...) |
| location | City or region |
| posting_date | Date job was posted |

### **2. candidates**
| Column | Description |
|--------|-------------|
| candidate_id | Unique candidate identifier |
| name | Candidate name |
| skills | Candidate skills |
| experience_years | Total experience |

### **3. applications**
| Column | Description |
|--------|-------------|
| application_id | Unique application ID |
| candidate_id | FK → candidates |
| job_id | FK → jobs |
| apply_date | Date the application was submitted |
| status | Applied / Shortlisted / Rejected / Hired |

---

## 🧠 Key Insights Generated
- Applications per job and per candidate  
- Most competitive job roles  
- Most active candidates  
- Category-wise job demand  
- Success rates & funnel analysis  
- Experience vs application outcome  
- Time-based application patterns  

---

## 🛠️ Technologies Used
- SQL (MySQL / PostgreSQL)
- Joins, aggregations, filtering  
- Window functions (advanced version)  
- CTEs  
- Subqueries  

---

## 📈 KPIs Computed (Advanced)
- **Application Rate**
- **Shortlist Rate**
- **Hire Rate**
- **Average Applications per Candidate**
- **Application Trend per Month**
- **Top 10 Most Applied Jobs**
- **Candidate Activity Ranking**

---
