-- ����������� ������� ������� ������������� � ������� users
SELECT ceil(avg(datediff(NOW(), birthday_at)/365.24)) from users u;
-- ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. 
-- ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.
select dayname(makedate(year(current_date()), day(birthday_at))) day_of_week, count(*) from users
group by day_of_week;
-- (�� �������) ����������� ������������ ����� � ������� �������.
select exp(sum(ln(value))) from tbl;


