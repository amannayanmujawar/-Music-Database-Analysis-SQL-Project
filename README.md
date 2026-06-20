# -Music-Database-Analysis-SQL-Project
SQL analysis of a digital music store — 

DataBase Structure 

- Worked with 11 interconnected tables: customer, invoice, invoice_line,
  track, album, artist, genre, employee
- Built and queried relationships using primary and foreign keys

Business Problem Solved 

- Identified the highest-revenue city for a promotional music festival
- Found the best customer by total spending
- Segmented Rock music listeners for targeted marketing
- Ranked top 10 Rock artists by track count
- Determined most popular genre per country (with tie handling)
- Identified top-spending customer per country (with tie handling)
- Calculated each customer's spending per artist using CTEs

Key Learning 

- Practiced thinking like a Data Analyst — translating business 
  questions into SQL logic
- Learned to handle tied rankings using window functions instead
  of simple ORDER BY + LIMIT
- Improved query readability using CTEs over nested subqueries

How to Run

1. Clone this repository
2. Import music_database.sql into MySQL Workbench
3. Run queries from the file in order (organized by difficulty)
