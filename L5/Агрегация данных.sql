-- ѕодсчитайте средний возраст пользователей в таблице users
SELECT ceil(avg(datediff(NOW(), birthday_at)/365.24)) from users u;
-- ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели. 
-- —ледует учесть, что необходимы дни недели текущего года, а не года рождени€.
select dayname(makedate(year(current_date()), day(birthday_at))) day_of_week, count(*) from users
group by day_of_week;
-- (по желанию) ѕодсчитайте произведение чисел в столбце таблицы.
select exp(sum(ln(value))) from tbl;


