create or replace type x is table of number;

create table y(id number, info x)
nested table info store as y_info;

insert into y values(3, x(2,3,4));

--PACHETE:  un pachet e cam ca o clasa. pot avea in el fct (spec + body), proc(s+b), type(s), var(s), cursoare(s)
--are 2 componente: specificatie, si body
--daca am o fct "calcul" in pachetul "x", se va putea apela x.calcul
--mai multe in lab6

--7. Să se creeze un pachet cu ajutorul căruia, utilizând un cursor şi un subprogram funcţie, să se
--obţină salariul maxim înregistrat pentru salariaţii care lucrează într-un anumit oraş şi lista salariaţilor
--care au salariul mai mare sau egal decât maximul salariilor din oraşul respectiv. 
/* aceasta este specificatia
create or replace package pb7 is
cursor lista(sal number) is
  select * 
  from employees
  where salary>=sal;
function get_max(oras varchar) return number;
end pb7;*/

create or replace package body pb7 is
function get_max(oras varchar) return number is
eroare_oras exception;
eroare_angajati exception;
nr number;
begin

  select count(city) into nr
  from locations 
  where lower(city)=lower(oras);
  if nr=0 then 
    raise eroare_oras;
  end if;
  
  select count(employee_id) into nr
  from employees join departments using(department_id)
  join locations using(location_id)
  where lower(city)=lower(oras);
  if nr=0 then 
    raise eroare_angajati;
  end if;
  
  select max(salary) into nr
  from employees join departments using(department_id)
  join locations using(location_id)
  where lower(city)=lower(oras);
  
  return nr;
  
  --sctione de tratare a erorilor
  exception 
    when eroare_oras then
      raise_application_error(-20457, 'Nu exista orasul dat');
    when eroare_angajati then
      raise_application_error(-20458, 'Nu am angajati');
  
end;
end pb7;

--utilizare functie din pachet
select pb7.get_max('Oxford')
from dual;

--utilizare cursor din pachet
set serveroutput on;
begin
  for linie in pb7.lista(5000) loop
    dbms_output.put_line(linie.last_name||' '||linie.salary);
  end loop;
end;


--10 lab 5
create or replace type dep_ang is object
(dep number, nr number);

create or replace package auxiliar is
  type lista is array(40) of dep_ang;
  v lista;
end auxiliar;

create table emp as(
select * from employees
);

-- triggerul before
create or replace trigger pb10_before
before insert or update of department_id on emp
begin
  select dep_ang(department_id, count(employee_id)), bulk collect into auxiliar.v
  from emp right join departments using(department_id)
  group by department_id;
end;

--triggeruul after
create or replace trigger pb10_after_row
after insert or update of department_id on emp
for each row
begin
  if inserting then
    for d in 1..auxiliar.v.count loop
      if auxiliar.v(d).dep=:new.department_id then
        auxiliar.v(d).nr:=auxiliar.v(d).nr+1;
        if auxiliar.v(d).nr>50 then
          raise_application_error(-20789, 'prea multi angajati - insert');
        end if;
      end if;
    end loop;
  else
    for d in 1..auxiliar.v.count loop
      if auxiliar.v(d).dep=:new.department_id then
        auxiliar.v(d).nr:=auxiliar.v(d).nr+1;
      end if;
      if auxiliar.v(d).dep=:old.department_id then
        auxiliar.v(d).nr:=auxiliar.v(d).nr-1;
      end if;
    end loop;
  end if;
end;

--trigger semnalizeaza depasirile DOAR pt update
create or replace trigger pb10_after
after update of department_id on emp
begin
  for d in 1..auxiliar.v.count loop
        if auxiliar.v(d).nr>50 then
          raise_application_error(-20789, 'prea multi angajati - insert');
        end if;
      end if;
    end loop;
end;