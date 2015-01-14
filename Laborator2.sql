--1
set serveroutput on;
declare 
type sters is Record
(
  cod employees.employee_id%type,
  nume employees.first_name%type,
  salariu employees.salary%type,
  department employees.department_id%type
);
 nr number;
 objReturning sters;
begin
  delete from emp where employee_id=&nr
    returning employee_id, first_name, salary, department_id 
    into objReturning;
    dbms_output.put_line('Am sters angajatul cu codul '||nr||' anume, '||objReturning.nume);
end;

rollback;

--2a
declare 
type sters is Record
(
  cod employees.employee_id%type,
  nume employees.first_name%type,
  salariu employees.salary%type,
  department employees.department_id%type
);
 nr number;
 objReturning emp%ROWTYPE;
begin
  delete from emp where employee_id = 111 
  RETURNING employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id,
            department_id into objReturning;
  objReturning.first_name := 'Catalina';
  objReturning.last_name := 'Ghiorghita';
  insert into emp values objReturning;
end;

rollback;

--2b
declare
 nr number;
 objReturning emp%ROWTYPE;
begin
  delete from emp where employee_id = 111 
  RETURNING employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id,
            department_id into objReturning;
  objReturning.first_name := 'Catalina';
  objReturning.last_name := 'Ghiorghita';
  insert into emp values objReturning;
  objReturning.email := 'cata@mail.com';
  update emp set row = objReturning where last_name = 'Ghiorghita';
end;

--3
declare
  type tab_index is table of number
          index by binary_integer;
  v_tab tab_index;
begin
  for ii in 1..10 loop
    v_tab(ii) := ii+1;
  end loop;
  for ii in 1..v_tab.count loop
    dbms_output.put_line(v_tab(ii));
  end loop;
--4
  for ii in 1..v_tab.count loop
    v_tab.delete(ii);
  end loop;
  dbms_output.put_line('Dupa stergere');
  for ii in 1..v_tab.count loop
    dbms_output.put_line(v_tab(ii));
  end loop;
end;

create table dept as (select * from departments);

--5 
declare
  type deptable is table of departments%rowtype index by BINARY_integer;
  v_table deptable;
  i integer:=1;
begin
  v_table(i).department_id := 69;
  v_table(i).department_name := 'ghiseu';
  v_table(i).manager_id := 4011;
  v_table(i).location_id := 1700;
  insert into dept values v_table(i);
  v_table.delete;
  dbms_output.put_line(v_table.count);
end;

--7
/**declare
  type proiect is varray(50) of varchar2(15);
  type test_ is table of 
  {cod_ang Number(4),
  proiecte_alocate proiect};
begin

en
d;
*/