# DataScienceSalaries

Challenge: Data Science Salaries. Tool: SQL - MySQL

Salaries of jobs in the Data Science domain

About Dataset

Content

Column	Description

* Work_year	The year the salary was paid.
* Experience_level	The experience level in the job during the year with the following possible values: EN Entry-level / Junior MI Mid-level / Intermediate SE Senior-level / Expert EX Executive-level / Director
* Employment_type	The type of employment for the role: PT Part-time FT Full-time CT Contract FL Freelance
* Job_title	The role worked during the year.
* Salary	The total gross salary amount paid.
* Salary_currency	The currency of the salary paid as an ISO 4217 currency code.
* Salary_in_usd	The salary in USD (FX rate divided by avg. USD rate for the respective year via fxdata.foorilla.com).
* Employee_residence	Employee's primary country of residence in during the work year as an ISO 3166 country code.
* Remote_ratio	The overall amount of work done remotely, possible values are as follows: 0 No remote work (less than 20%) 50 Partially remote 100 Fully remote (more than 80%)
* Company_location	The country of the employer's main office or contracting branch as an ISO 3166 country code.
* Company_size	The average number of people that worked for the company during the year: S less than 50 employees (small) M 50 to 250 employees (medium) L more than 250 employees (large)

Questions 

1. How many countries are in the dataset?
2. How many entries are there for non-US countries and the US?
3. What is the highest and lowest salary for US entries?
4. What is the highest and lowest salary for non-US entries?
5. What is the average salary for US and non-US countries?
6. What is the salary median for the US?
7. What is the average salary for entries by experience level?
8. What is the average salary for each year?
9. How many senior and executive positions are in the dataset for each year?
10. What is the difference in entries amount for each year?
11. How many remote/hybrid/office positions are in each group?
12. What group has the highest percentage of remote positions?
13. Does the remote option affect the salary?
14. What is the percentage of different experience positions working 100 remotely?
15. What is the percentage among different experience levels?
16. How many entries are there for different employment types and what is the average salary?
17. What is the percentage of different employment types for each group US vs. non-US?
18. How many different titles are there in the dataset and what data position is the most frequent?
19. Is the average salary higher for bigger companies? 
20. How many data-related positions there are by company size?
21. Do large companies have more people working in senior and executive positions than small companies?
22. How many people are in a different country than it is the company headquarters?
23. Do bigger companies allow remote positions more than small or medium companies?

💭 Interesting insights
1.	Salary from US companies is twice as high as salaries from non-US companies.
2.	Median salary in USD for US companies is 135,000 USD and for non-US companies 62,689 USD.
3.	The salary is comparable in US companies for all 3 years. For non-US companies, a jump in average salary is recorded in 2022.
4.	75% of positions in US companies are remote and only 46% of positions in nonUS companies are remote.
5.	Average salary for remote positions is slightly higher in US companies, for non-US companies the average salary is not affected by remote work conditions.
6.	In the US 94% of executive-level positions are working remotely, for non-US only 30% of executive-level positions are working remotely.
7.	Large non-US companies are more likely to offer a hybrid position. Small and medium nonUS and all sizes of US companies are prone to offer a remote position.
8.	Full-time contract is the most common type of employment for both groups.
9.	The most common job titles are data scientist, data engineer, and data analyst.
10.	 Vast majority of employees are residents of the same country as the company location.

🎯 Conclusion
Even though the dataset contains only a limited amount of data, it still offers an interesting insight into data science employment conditions. The most interesting outcome is the huge difference between the salary that is offered by companies in the US and outside the US. On average it is 144,000 USD for US companies compared to 67,500 USD for companies located outside the US.
A big difference can be also seen in the approach to remote work. In the US 75% of positions are remote. Companies outside the US slowly follow with the trend with only 46% remote positions and 31% hybrid positions. Those numbers clearly show that data science and analysis can be done remotely and that the idea of shorter/less frequent commutes is getting more and more popular. In fact, remote positions are often better paid (applies to US-based companies).
In general, large companies are more likely to offer higher salaries compare to medium and small-size companies. A full-time contract is the most common type of employment.
The numbers also show that the majority of employees (91,6%) reside in the same country as the company headquarters. It could be very interesting to see whether this is caused by company policies and contract conditions, as many job ads are published as remote within a specific country/state, or by employees’ decisions.



