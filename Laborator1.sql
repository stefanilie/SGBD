--1Creaşi un bloc anonim care sã afiºeze propozişia "Invat PL/SQL" pe ecran. 
set SERVEROUTPUT ON;
begin
dbms_output.put_line('Hello Word');
end;

/*--2 Sã se creeze un bloc anonim în care se declarã o variabilã v_oras de tipul coloanei city
(locations.city%TYPE). Atribuişi acestei variabile numele oraºului în care se aflã departamentul având 
codul 30*/
declare
v_oras locations.city%TYPE;
begin
select l.CITY into v_oras from locations l join DEPARTMENTS d on l.LOCATION_ID = d.LOCATION_ID where d.DEPARTMENT_ID = 30;
dbms_output.put_line(v_oras);
end;

/*--3  Sã se creeze un bloc anonim în care sã se afle media salariilor pentru angajaşii al cãror departament 
este 50. Se vor folosi variabilele v_media_sal de tipul coloanei salary ºi v_dept (de tip NUMBER). */
declare
v_media_sal employees.salary%type;
v_dept number := 50;
begin
select avg(salary) into v_media_sal 
from employees e join DEPARTMENTS d 
on e.DEPARTMENT_ID=d.DEPARTMENT_ID 
where d.department_id = v_dept;
dbms_output.put_line('Salariul mediu al angajatilor departamentului '||v_dept||' este '||v_media_sal);
end;

/*--4  Sã se specifice dacã un departament este mare, mediu sau mic dupã cum numãrul angajaşilor sãi 
este mai mare ca 30, cuprins între 10 ºi 30 sau mai mic decât 10. Codul departamentului va fi cerut 
utilizatorului. */
declare 
&&a number;
nr number;
begin
select count(*) into nr from employees e join departments d on e.department_id = d.department_id where d.DEPARTMENT_ID = &&a;
IF nr > 30 then 
  dbms_output.put_line('Departamentul '||a||' este mare');
elsif nr between 10 and 30 then
  dbms_output.put_line('Departamentul '||a||' este mediu');
else
  dbms_output.put_line('Departamentul '||a||' este mic');
end;