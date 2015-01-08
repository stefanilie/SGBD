--PL/SQL
/*
select sum(rownum) 
from dual
where rownum >= &a and rownum =< &b;*/
-- intoarce o sg linie ->> 1

select level+&&a-1   
from dual
connect by &a+level-1<=&b;
undefine a;


declare 
s number:=0;
begin
select sum(level+&&a-1) into s -- s=suma; nu se scrie fara INTO !!!!!!!!!!!!!!!!!!!!!!! 
from dual
connect by &a+level-1<=&b;
dbms_output.put_line(s); 
end;
/
undefine a;


--sau
set serveroutput on
declare 
s number:=0;
begin
select sum(level+&&a-1) into s -- s=suma; nu se scrie fara INTO !!!!!!!!!!!!!!!!!!!!!!! 
from dual
connect by &a+level-1<=&b; 
dbms_output.put_line(s);
end;
/
undefine a;

-- cu functii
create or replace function suma(a number, b number) return number is
s number:=0;
begin
select sum(level+a-1) into s 
from dual
connect by a+level-1<=b; 
return s;
end;

-- apelare
select suma(2,11)
from dual;

--afisare nr din interval
set serveroutput on
declare 
type vector is array(30) of number;
v vector;
s number:=0;
begin
select level+&&a-1 bulk collect into v
from dual
connect by &a+level-1<=&b;
for i in 1..v.count loop
  dbms_output.put_line(v(i));
end loop;
end;
/
undefine a;

--tema din lab 1 (ang 102)
create or replace view J102 as
select job_id
from employees
where employee_id=102
union
select job_id
from job_history
where employee_id=102;

select * from j102;

select *
from 
    ( select employee_id, job_id
      from employees
      union
      select employee_id, job_id
      from job_history )
where job_id in ( select * from j102 ); -- and job_id=!102

insert into job_history(employee_id,job_id,start_date,end_date)
values(103,'AD_VP',sysdate-345,sysdate-50);
commit;

select *
from employees x
where not exists
( select job_id
  from employees
  where employee_id=x.employee_id
  union
  select job_id
  from job_history
  where employee_id=x.employee_id
  minus
  (select * from j102) and 
  (not exists 
  select * from j102
  minus 
  ( select job_id
  from employees
  where employee_id=x.employee_id)
  union
 ( select job_id
  from job_history
  where employee_id=x.employee_id)));