--lab 10

--lab 5 -- trigger-i

--poate o func sa intoarca un record??

create or replace type obj is
object(nr number, info varchar2(20));

create or replace function test_obj return obj is
x obj:=obj(12,'etc');
begin
  return x;
end;

select test_obj
from dual;

-- de la vers 10g in sus merge.

set serveroutput on;
declare  -- ca sa fim siguri ca o sa mearga !!!
v obj;
begin
  v:=test_obj;
  dbms_output.put_line(v.nr||' '||v.info);
end;

--------------------------------------------------------------

create or replace function test_obj return number is
begin
  update emp
  set salary=salary+2;
  return SQL%ROWCOUNT;
end;

select test_obj --- nu este corect /// da eroare // daca vrem sa testam tb sa apelam intr-un bloc pl/sql
from dual;    ^---- operatii de tip dml in intermediul functiilor

set serveroutput on;
declare
begin
  dbms_output.put_line(test_obj);
end;

rollback;

--------------------------------------------------------

-- in pb pt test ex 4) "functie" se refera la func stocata sau locala

--trigger-i

--ex 1

create or replace trigger pb1
before insert on emp
begin 
  if to_char(sysdate,'d') in (1,7) or to_char(sysdate,'hh24') not between 8 and 18 then
    raise_application_error(-20457,'Nu ai voie!!');
  end if;
end;

insert into emp
(select * from employees);

--Error report:
--SQL Error: ORA-20457: Nu ai voie!!
--ORA-06512: la "LAURA_MOTOC.PB1", linia 3
--ORA-04088: eroare în timpul executiei triggerului 'LAURA_MOTOC.PB1'

--ex 2
create or replace trigger pb1
before insert or update or delete on emp
begin 
  if to_char(sysdate,'d') in (1,7) or to_char(sysdate,'hh24') not between 8 and 18 then
  if inserting then
    raise_application_error(-20457,'Nu ai voie sa inserezi!!');
  elsif deleting then
       raise_application_error(-20467,'Nu ai voie sa stergi!!');
  elsif updating('salary') then
        raise_application_error(-20477,'Nu ai voie sa actualizezi sal!!');
  elsif updating then
       raise_application_error(-20487,'Nu ai voie sa actualizezi!!');
  end if;
  end if;
end;

insert into emp
(select * from employees);

delete from emp;

update emp 
set salary=salary+2;

--ex 7

create or replace trigger check_sal 
before insert or update of salary, job_id on emp
for each row
when (new.job_id <>'AD_PRES')
declare
min_s number;
max_s number;
begin
  select min_salary, max_salary into min_S, max_s
  from jobs
  where job_id=:new.job_id;
  
  if :new.salary not between min_s and max_s then
    raise_application_error(-20354,'Salariu gresit');
  end if;
end;                   

update emp
set salary=salary+9999
where job_id='AD_PRES';

update emp
set salary=salary+9999
where job_id='IT_PROG';

rollback;

--------------------------------------------------------

create or replace trigger b_t_test
before update of salary on emp 
begin
  dbms_output.put_line('before table');
end;

create or replace trigger b_r_test
before update of salary on emp 
for each row
begin
  dbms_output.put_line('before row');
end;

create or replace trigger a_r_test
after update of salary on emp 
for each row
begin
  dbms_output.put_line('after row');
end;

create or replace trigger a_t_test
after update of salary on emp 
begin
  dbms_output.put_line('after table');
end;


update emp
set salary=salary-1;

rollback;

update emp x
set salary=(select (min_salary-max_salary)/2
            from jobs
            where job_id=x.job_id)
where employee_id>0;
