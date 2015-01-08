-- lab 8

-- ex lab 3 - cursoare
--
--4
set serveroutput on;
declare
cursor prob4 is
select *
from emp 
where salary <7000
--linie prob4%rowtype;  <- la for nu avem nevoie de linie

begin

--if not prob4%isopen 
--  then open prob4;
--end if;

/*cu loop*/
--loop
--  fetch prob4 into linie;
--  exit when prob4%notfound;
--  dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
--end loop;

/*cu while*/
--fetch prob4 into linie;
--while prob4%found loop
--  dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
--  fetch prob4 into linie;
--end loop;

/*cu for*/
for i in prob4 loop
  dbms_output.put_line('salariatul '||i.last_name||' '||'castiga '||i.salary);
end loop; -- nu avem nevoie de open si close

--close prob4;
end;

-- fara cursor in declare
set serveroutput on;
begin
for i in 
(select *
 from emp 
 where salary <7000) loop
  dbms_output.put_line('salariatul '||i.last_name||' '||'castiga '||i.salary);
end loop;

end;

-- cursoare cu parametri
set serveroutput on;
declare
cursor prob4(sal number,dep number) is
select *
from emp 
where salary <sal and department_id=dep;

begin
/*cu for*/
for i in prob4(&sal, 30) loop
  dbms_output.put_line('salariatul '||i.last_name||' '||'castiga '||i.salary);
end loop; -- nu avem nevoie de open si close

end;

-------- cursoare dinamice
set serveroutput on;
declare
prob4 sys_refcursor;
linie emplmo%rowtype;
linied deptlmo%rowtype;
begin
open prob4 for  select *
                from emplmo 
                where salary <7000 and department_id=30;
loop
  fetch prob4 into linie;
  exit when prob4%notfound;
  dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
end loop;
close prob4;
open prob4 for select *
                from deptlmo d
                where 10<(select count(employee_id)
                          from emplmo
                          where department_id=d.department_id);
loop
  fetch prob4 into linied;
  exit when prob4%notfound;
  dbms_output.put_line('Departamentul '||linied.department_name||' '||'se afla in '||linied.location_id);
end loop;
close prob4;          
end;

-- cursor dinamic cu tip declarat de noi
set serveroutput on;
declare
type cursor_dinamic is ref cursor;
prob4 cursor_dinamic;
linie emplmo%rowtype;
linied deptlmo%rowtype;
begin
open prob4 for  select *
                from emplmo 
                where salary <7000 and department_id=30;
loop
  fetch prob4 into linie;
  exit when prob4%notfound;
  dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
end loop;
close prob4;
open prob4 for select *
                from deptlmo d
                where 10<(select count(employee_id)
                          from emplmo
                          where department_id=d.department_id);
loop
  fetch prob4 into linied;
  exit when prob4%notfound;
  dbms_output.put_line('Departamentul '||linied.department_name||' '||'se afla in '||linied.location_id);
end loop;
close prob4;          
end;

--dinamic cu cerere param
set serveroutput on;
declare
type cursor_dinamic is ref cursor;
prob4 cursor_dinamic;
linie emplmo%rowtype;
linied deptlmo%rowtype;
x number:=&sal;
y number:=&dep;
begin
open prob4 for 'select *
                from emplmo 
                where salary <:sal and department_id=:dep'
                using x,y;
loop
  fetch prob4 into linie;
  exit when prob4%notfound;
  dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
end loop;
close prob4;
open prob4 for select *
                from deptlmo d
                where 10<(select count(employee_id)
                          from emplmo
                          where department_id=d.department_id);
loop
  fetch prob4 into linied;
  exit when prob4%notfound;
  dbms_output.put_line('Departamentul '||linied.department_name||' '||'se afla in '||linied.location_id);
end loop;
close prob4;          
end;

-- for update
set serveroutput on;
declare
cursor prob4 is
          select *
          from emp
          where salary <7000 and department_id=30;
          --for update of salary nowait; 
          for update of salary wait 10; 

begin
/*cu for*/
for linie in prob4 loop
  update emp
  set salary=salary+333
  where employee_id=linie.employee_id;
  --dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
end loop; 
end;

rollback;

------ for all!!!!!!!!!!!!! - pb la teorie la exam - o sg cerere care editeaza toate liniile
--------
set serveroutput on;
declare
cursor prob4 is
          select *
          from emp
          where salary <7000 and department_id=30;
          --for update of salary nowait; 
          for update of salary wait 10; 

begin
/*cu for*/
for linie in prob4 loop
  update emp
  set last_name= last_name || '333'
  --where employee_id=linie.employee_id;
  --dbms_output.put_line('salariatul '||linie.last_name||' '||'castiga '||linie.salary);
  where current of prob4;
end loop; 
end;

-- tema: ex lab 3
-- vineri : ora 00:00 mail cu 2 prob
-- ex 5 - lab 3
-- ex 9 - lab 4
-- oracle apx - instalat local -- dc nu merge sql developer