select * from user;
select * from user_address;
select * from user_salary;

select u.user_id, ua.city, us.salary, 
dense_rank() over(partition by ua.city order by us.salary desc) as rnk
from user as u
join user_address as ua on u.user_id = ua.user_id
join user_salary as us on ua.user_id = us.user_id; 


SELECT ua.country, u.username, ua.city, us.salary, 
       AVG(us.salary) OVER (PARTITION BY ua.country) AS avg_country_salary
FROM user u
JOIN user_address ua ON u.user_id = ua.user_id
JOIN user_salary us ON u.user_id = us.user_id
ORDER BY ua.country, u.username;
