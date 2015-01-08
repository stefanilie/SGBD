--lab 4--laborator 1

--7
/*
variable dep number;
/
begin
select max(department_id) into :dep
from departments;
end;
/
print dep;
*/
/*
--8
/
begin
insert into departments(department_id, department_name)
values(:dep+10,'dep_nou');
end;
/
select * 
from departments
where department_id= :dep+10;
*/
/*
----- var urm nu este corecta se foloseste ca mai sus :dep+10 in insert
/
begin
:dep:=:dep+10;
insert into departments(department_id, department_name)
values(:dep,'dep_nou');
end;
/
select * 
from departments
where department_id= :dep+10;

-------
begin 
:dep:=:dep+10;
end;
/
print dep;
*/

--9
/*
/
begin
insert into departments(department_id, department_name)
values(:dep+10,'dep_nou');
--:dep:=:dep+10; -- nu are nici un efect
end;
/
select * 
from departments
where department_id= :dep+10;
/
begin 
update departments
set location_id=1100
where department_id=:dep+10;
end;
/
select * 
from departments
where department_id= :dep+10;
--10
/
begin
delete from departments
where department_id=:dep+10;
end;
/
select *
from departments
where department_id=:dep+10;
/
*/
--------------
variable dep number;
/
set serveroutput on
declare x number;
begin
select max(department_id) into :dep
from departments;
:dep:=:dep+10;
dbms_output.put_line('etc......: '||nvl(:dep,-1));
end;
/
---- in ex de mai sus blocul dep este null ; dep se schimba cand iese din pl/sql
print dep;
/
----------------------------
variable dep number;
/
begin
--dbms_output.put_line(nvl(:dep,-3));
/*
select max(employee_id) into :dep
from employees;*/
--:dep:=10; -- merge 
:dep:=:dep+10;-- nu tine minte -- transporta niste valori din pl/sql in sql
--^----nu se poate folosi precum variabila pe pl/sql
-- se foloseste o singura data ; nu se pot face operatii
end;
/

print dep;
/

--4
set serveroutput on
declare
cod employees.employee_id%type:=&cod;
sal employees.salary%type;
com number(2,2);

begin
select salary into sal
from emp
where employee_id=cod;

if sal is null then com:=0;
  elsif sal<1000 then com:=0.1;
  elsif sal<=1500 then com:=0.15;
  else com:=0.2;
end if;

update emp
set commission_pct=com
where employee_id=cod;

end;

--------------------------------------------

--4
set serveroutput on
declare
cod employees.employee_id%type:=&cod;
sal employees.salary%type;
com number(2,2);
v number(1);
begin
-- count (null) = 0
--verif daca exista sau nu angajat cu employee_id =cod
select count(employee_id) into v
from emp
where employee_id=cod;

if v=0 then dbms_output.put_line('Angajatul nu exista');
else
select salary into sal
from emp
where employee_id=cod;

if sal is null then com:=0;
  elsif sal<1000 then com:=0.1;
  elsif sal<=1500 then com:=0.15;
  else com:=0.2;
end if;

update emp
set commission_pct=com
where employee_id=cod;

if sql%found then
  dbms_output.put_line(sql%rowcount);
end if;
end if;
end;


--------

--5/6

create table org_tablm
(cod_tab number, text_tab varchar2(10));

begin
for i in 1..70 loop
  if mod(i,2)=0 then
    INSERT INTO org_tablm VALUES(1,'par');
  else 
    INSERT INTO org_tablm VALUES(1,'impar');
  end if;
end loop;
end;

