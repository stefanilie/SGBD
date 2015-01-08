-- 28
/*CREATE table Emp  AS SELECT * FROM Employees;
CREATE table Dept  AS SELECT * FROM Departments;*/

create or replace view viz28 as
select employee_id cod , last_name nume, email email, 
job_id job, hire_date data, department_name numed, 
department_id codd
from emp_pnu join dept_lmo using (department_id)
where department_id = 30;

insert into viz28 (cod, nume, email, data, job)
values(254, 'nume254', 'email254', to_date('01-12.2014','DD-MM-YYYY'),'SA_REP');

insert into viz28 (cod, nume, email, data, job)
values(255, 'nume255', 'email255', to_date('01-12.2014','DD-MM-YYYY'),'SA_REP');

/* -nu mergea insert -- tb adaugata cheia primara
alter table emp_pnu
add constraint pk_emp primary key(employee_id);

alter table dept_lmo
add constraint pk_dept primary key(department_id);
*/

/*delete from viz28
where salary>10000; -- nu avem salary in vizualizare */

select  * from viz28;

insert into viz28 (cod, nume, email, data, job, codd)
values(295, 'nume295', 'email295', to_date('01-12.2014','DD-MM-YYYY'),'SA_REP',30);
-- putem insera si in dept_lmo daca folosim on in loc de using la join

create or replace view viz28 as
select employee_id cod , last_name nume, email email, 
job_id job, hire_date data, d.department_name numed, 
d.department_id codd
from emp_pnu e join dept_lmo d on e.department_id=d.department_id
where d.department_id = 30;
-- nu merge -- putem face insert doar in employees

create or replace view viz28 as
select employee_id cod , last_name nume, email email, 
job_id job, hire_date data, d.department_name numed, 
e.department_id codd
from emp_pnu e join dept_lmo d on e.department_id=d.department_id
where e.department_id = 30; -- corect -- introduce numai in emp_pnu
-- insert-ul functioneaza deoarece introduce doar in emp_pnu 
insert into viz28 (cod, nume, email, data, job, codd)
values(295, 'nume295', 'email295', to_date('01-12.2014','DD-MM-YYYY'),'SA_REP',30);

alter table emp_pnu
add constraint verif_cod check (employee_id<1000);
-- insert nu o sa functioneze din cauza constrangerii
insert into viz28 (cod, nume, email, data, job, codd)
values(1295, 'nume1295', 'email1295', to_date('01-12.2014','DD-MM-YYYY'),'SA_REP',30);

-- 2 
select *
from (select *
      from employees
      order by salary desc)
where rownum<=5;

-- toate arg care se gasesc in select si nu sunt arg ale unor func grup tb sa apara in group by
select last_name, salary 
from employees
having salary>5000
group by last_name, salary;

