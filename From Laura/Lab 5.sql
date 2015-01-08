-- laborator 5
/*
declare 
cod number;
begin 
select employee_id into cod
from employees
where employee_id>=123
end;*/
-- nu functioneaza 

--- colectii -- vectori
/*
set serveroutput on;
declare 
type vector is array(120) of number;
cod vector:=vector(2,3,4);-- tb initializat altfel da eroare
begin 

cod.extend;
cod(4):=-3;

select employee_id bulk collect into cod
from employees;
--dbms_output.put_line(cod.count);
--dbms_output.put_line(cod.first);
/*if cod.exists(7) then
dbms_output.put_line('exista');
end if;*
cod.delete;
cod.trim(3); -- sterge de la sfarsit
--dbms_output.put_line(cod.next(7));
dbms_output.put_line(cod.count);
end;-- nu pune in continuare
*/

-- tabele indexate
/*
set serveroutput on;
declare
type vector is array(120) of number;
type tab_indexat is table of number index by binary_integer;
cod tab_indexat;
j number;

begin 
cod(-4):=-3;
cod(2000):=2;
cod(100):=1;

select employee_id bulk collect into cod
from employees;

--cod.delete(3);
/*
j=cod.first;

loop 
dbms_output.put_line(cod(j));
j:=cod.next(j); -- nu e corect j=j+1
exit when j=cod.last;
end loop;
cod.delete(cod.first);
j:=cod.first;
for i in 1..cod.count loop
--dbms_output.put_line(cod.first);
dbms_output.put_line(cod(j));
j:=cod.next(j);
end loop;
-- acceseaza in functie de indexul asociat in ordine crescatoare
end;*/
/*
-- tablouri imbricate
set serveroutput on;
declare
type vector is array(120) of number;
type tab_imb is table of number;
cod tab_imb:=tab_imb();
j number;
begin
select employee_id bulk collect into cod
from employees;
--cod.delete(cod.first);
cod.delete(102);
/*if cod.exists(102) then
 dbms_output.put_line(cod.count);
 end if;*
 cod(102):=55;
cod.trim(7);
j:=cod.first;
for i in 1..cod.count loop
--dbms_output.put_line(cod.first);
dbms_output.put_line(cod(j));
j:=cod.next(j);
end loop;

end;
*/

------ RECORD

--1
set serveroutput on;
declare
type colectie is record(
cod employees.employee_id%type,
nume varchar2(20),
sal number,
dep number);
v_colectie colectie;
begin

delete from emp
where employee_id=200
returning employee_id,last_name, salary, department_id into v_colectie;
dbms_output.put_line(v_colectie.sal||' '||v_colectie.nume);

end;

rollback;

-2
declare
type colectie is record(
cod departments.department_id%type,
nume varchar2(20),
loc number, 
sef number);
--v_colectie colectie:=colectie(500,'nuume',null,null);-- nu e corect
v_colectie colectie;
begin
v_colectie.cod:=359;
v_colectie.nume:='dep nou';

--insert into dept(department_id,department_name)
--values(v.colectie);-- nu avem destule valori

--insert into dept(department_id,department_name)
--values v.colectie;
insert into dept
values v_colectie;
end;

/

rollback;

--2b

declare
type colectie is record(
cod departments.department_id%type,
nume varchar2(20),
loc number, 
sef number);

v_colectie colectie;
begin
v_colectie.cod:=359;
v_colectie.nume:='dep nou nou';

insert into dept
values v_colectie;

update dept
set row=v_colectie
where department_id=v_colectie.cod;

end;

/

rollback;


--- creare tipuri globale
declare
v_colectie colectie;
begin
v_colectie:=colectie(350,'dep nou',null,null);
end;

/*
create or replace type colectie is object(
cod departments.department_id%type,
nume varchar2(20),
loc number, 
sef number);*/