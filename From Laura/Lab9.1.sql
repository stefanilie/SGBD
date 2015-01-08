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
  from employees join jobs using (job_id)
  where employee_id=p_id;
end;


variable sal number;
variable titlu varchar2(50);
execute pb10(186,:sal,:titlu);
print sal;
print titlu;

--12
-- supraincarcare - nr de arg este diferit, tipuri dif de parametri 
-- doar pt functii locale
set serveroutput on;
declare
function medie(dep number) return number is
sal employees.salary%type;
begin
  select nvl(avg(salary),0) into sal
  from employees
  where department_id=dep;
  return sal;
end;

function medie(dep number, job varchar2) return number is
sal employees.salary%type;
begin
  select nvl(avg(salary),0) into sal
  from employees
  where department_id=dep and job_id=job;
  return sal;
end;

begin
  dbms_output.put_line(medie(50)||' '||medie(50,'ST_CLERK')); 
end;

--17
create or replace function factorial(nr number) return number is
begin
  if nr<2 then return 1;
  else return nr*factorial(nr-1);
  end if;
end;

select factorial(5) from dual;

--tema: lab4 - 16 (bogdan, alina si eu )