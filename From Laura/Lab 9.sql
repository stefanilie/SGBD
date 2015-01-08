--lab 9
--- ex lab 4
-- proceduri si functii

--6
--a)
create table jobs2 as select * from jobs;

alter table jobs2 add primary key(job_id); 

--b)
create or replace procedure add_jobs(p_id varchar2, p_title varchar2) is
begin
  insert into jobs2(job_id, job_title)
  values (p_id, p_title);
end;

execute add_jobs('IT_DBA','Data Administrator');
--1 (ca al 5 dar scrisa in declare)

--2
--comisionul este in
set serveroutput on;
declare
  p_nume varchar2(20);
  procedure pb2(p_id number, p_comision number, p_rezultat out varchar2) is
  nr number;
  eroare exception;
begin
  if p_comision is null then
    select count(employee_id) into nr
    from employees
    where employee_id=p_id;
    if nr=0 then
      raise eroare;
    else
      select last_name into p_rezultat
       from employees
       where employee_id=p_id;
    end if;
  else 
    select last_name into p_rezultat
    from employees
    where commission_pct=p_comision and
          salary = (select max(salary)
                    from employees
                    where commission_pct=p_comision); 
  end if;
  exception
     when eroare then
      raise_application_error(-20710,'angajatul nu exista');
end;
begin 
  pb2(745,null,p_nume);
  --pb2(145,0.15,p_nume);
  --pb2(null,0.15,p_nume);
  dbms_output.put_line(p_nume);
end;

--6 - 5 dar cu update
--7 - 5 dar cu delete

--8
create or replace procedure pb8(sal out number) as
begin
  select avg(salary) into sal
  from employees;
end;

variable x number;
execute pb8(:x); --: parseaza variabila in pl/sql () variabila gazda
print x;

--9 ia un munar aleator

--10
create or replace procedure pb10(p_id number, sal out number, titlu out varchar2) is
nr number;
begin
  select count(employee_id) into nr
  from employees
  where employee_id=p_id;
  if nr=0 then
    raise_application_error(-20305,'Angajatul nu exista');
  end if;
  select salary, job_title into sal, titlu
  from employees join jobs gsing (job_id)
  where employee_id=p_id;
end;


variable sal number;
variable titlu varchar2(50);
execute pb10(186,sal,titlu);
print sal;
print titlu;