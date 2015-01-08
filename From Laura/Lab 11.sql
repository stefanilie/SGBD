-- lab 11

-- lab5 - trigger-i

--ex 8

create table emp8 as
select * from employees;

create table dept8 as 
select * from departments;

alter table dept8
add total_sal number;

create or replace trigger pb8 
after update or delete or insert of salary, department_id on emp8  
for each row
begin
if inserting then
  update dept8
  set total_sal=total_sal+:new.salary
  where department_id=:new.department_id;
elsif deleting then
  update dept8
  set total_sal=total_sal-:old.salary
  where department_id=:old.department_id;
elsif updating then
  update dept8
  set total_sal=total_sal+:new.salary
  where department_id=:new.department_id;
  update dept8
  set total_sal=total_sal-:old.salary
  where department_id=:old.department_id;
end if;
end;

update dept8 x
set total_sal = (select nvl(sum(salary),0)
                 from emp8
                 where department_id=x.department_id);

update emp8
set department_id=30
where department_id=20;

rollback;

--ex 11

update departments
set department_id=500 
where department_id=130; -- nu avem niciun ang

alter table dept8 add primary key(department_id);
alter table emp8 add primary key(employee_id);

alter table emp8 add foreign key(department_id) references dept8(department_id);

create or replace trigger pb11 
after update or delete of department_id on dept8
for each row
begin
if deleting then
  delete from emp8 
  where department_id=:old.department_id;
elsif updating then
  update emp8
  set department_id=:new.department_id
  where department_id=:old.department_id;
end if;
end;

delete dept8
where department_id=20;

rollback;

update dept8
set department_id=280
where department_id=20;

---------------------------------
--2pct pb11-modif
/*
--daca este eliminat un sef vor fi stersi toti ang sub el
--dc se schimba codul unui sef va modifica val resp pt toti subalternii
*/

alter table emp8 
add foreign key (manager_id) references emp8(employee_id);

create or replace trigger pb11b
after update or delete of employee_id on emp8
for each row
begin
if deleting then
  delete from emp8 
  where manager_id=:old.employee_id;
elsif updating then
  update emp8
  set manager_id=:new.employee_id
  where manager_id=:old.employee_id;
end if;
end;

delete from emp8
where employee_id=100;

-- pb 10 pt 11b
create or replace trigger pb10
after insert or update of department_id on emp11
declare
nr_max number;
begin
select count(employee_id) into nr_max
from emp11
group by employee_id
if nr_max>50 then
  raise_application_error(-20894,'prea multi angajati');
end if;
end;

--insert -> da before row
--delete -> after table

--package aux is
--type vector in array(20) of cell
--
--type cell ( perechi )