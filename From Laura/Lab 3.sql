/*DECLARE
TYPE emp_record
IS
  RECORD
  (
    cod employees.employee_id%TYPE,
    salariu employees.salary%TYPE,
    job employees.job_id%TYPE);
  v_ang emp_record;
BEGIN
  DELETE
  FROM emp_bc
  WHERE employee_id=100 RETURNING employee_id,
    salary,
    job_id
  INTO v_ang;
  DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/ 
ROLLBACK;
*/
DECLARE 
v_ang1 employees%ROWTYPE; 
v_ang2 employees%ROWTYPE; 
BEGIN 
-- sterg angajat 100 si mentin in variabila linia stearsa 
DELETE FROM emp_bc 
WHERE employee_id = 100 
RETURNING employee_id, first_name, last_name, email, phone_number, 
hire_date, job_id, salary, commission_pct, manager_id, 
department_id 
INTO v_ang1; 
-- inserez in tabel linia stearsa 
INSERT INTO emp_bc 
VALUES v_ang1; 
-- sterg angajat 101 
DELETE FROM emp_bc 
WHERE employee_id = 101;
-- obtin datele din tabelul employees 
SELECT * 
INTO v_ang2 
FROM employees 
WHERE employee_id = 101; 
-- inserez o linie oarecare in emp_*** 
INSERT INTO emp_bc 
VALUES(1000,'FN','LN','E',null,sysdate, 'AD_VP',1000, null,100,90); 
-- modific linia adaugata anterior cu valorile variabilei v_ang2 
UPDATE emp_bc 
SET ROW = v_ang2 
WHERE employee_id = 1000; 
END; 
/




DECLARE 
TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY BINARY_INTEGER; 
t tablou_indexat; 
BEGIN 
-- punctul a 
FOR i IN 1..10 LOOP 
t(i):=i; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(t(i) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul b 
FOR i IN 1..10 LOOP 
IF i mod 2 = 1 THEN t(i):=null; 
END IF; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul c 
t.DELETE(t.first); 
t.DELETE(5,7); 
t.DELETE(t.last); 
DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || 
' si valoarea ' || nvl(t(t.first),0)); 
DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || 
' si valoarea ' || nvl(t(t.last),0)); 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
IF t.EXISTS(i) THEN 
DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' '); 
END IF; 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul d 
t.delete; 
DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.'); 
END; 
/


DECLARE 
TYPE tablou_indexat IS TABLE OF emp_bc%ROWTYPE 
INDEX BY BINARY_INTEGER; 
t tablou_indexat; 
BEGIN 
-- stergere din tabel si salvare in tablou 
DELETE FROM emp_bc 
WHERE ROWNUM<= 2 
RETURNING employee_id, first_name, last_name, email, phone_number, 
hire_date, job_id, salary, commission_pct, manager_id, 
department_id 
BULK COLLECT INTO t; 
--afisare elemente tablou 
DBMS_OUTPUT.PUT_LINE (t(1).employee_id ||' ' || t(1).first_name); 
DBMS_OUTPUT.PUT_LINE (t(2).employee_id ||' ' || t(2).last_name); 
--inserare cele 2 linii in tabel 
INSERT INTO emp_bc VALUES t(1); 
INSERT INTO emp_bc VALUES t(2); 
END; 
/


DECLARE 
TYPE tablou_imbricat IS TABLE OF NUMBER; 
t tablou_imbricat := tablou_imbricat(); 
BEGIN 
-- punctul a 
FOR i IN 1..10 LOOP 
t.extend; t(i):=i; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(t(i) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE;
-- punctul b 
FOR i IN 1..10 LOOP 
IF i mod 2 = 1 THEN t(i):=null; 
END IF; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul c 
t.DELETE(t.first); 
t.DELETE(5,7); 
t.DELETE(t.last); 
DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || 
' si valoarea ' || nvl(t(t.first),0)); 
DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || 
' si valoarea ' || nvl(t(t.last),0)); 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
IF t.EXISTS(i) THEN 
DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' '); 
END IF; 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul d 
t.delete; 
DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.'); 
END; 
/

DECLARE 
TYPE tablou_imbricat IS TABLE OF CHAR(1); 
t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm'); 
i INTEGER; 
BEGIN 
i := t.FIRST; 
WHILE i <= t.LAST LOOP 
DBMS_OUTPUT.PUT(t(i)); 
i := t.NEXT(i); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
i := t.LAST; 
WHILE i >= t.FIRST LOOP 
DBMS_OUTPUT.PUT(t(i)); 
i := t.PRIOR(i);
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
t.delete(2); 
t.delete(4); 
i := t.FIRST; 
WHILE i <= t.LAST LOOP 
DBMS_OUTPUT.PUT(t(i)); 
i := t.NEXT(i); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
i := t.LAST; 
WHILE i >= t.FIRST LOOP 
DBMS_OUTPUT.PUT(t(i)); 
i := t.PRIOR(i); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
END; 
/

DECLARE 
TYPE vector IS VARRAY(2) OF NUMBER; 
t vector:= vector(); 
BEGIN 
-- punctul a 
FOR i IN 1..10 LOOP 
t.extend; t(i):=i; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(t(i) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul b 
FOR i IN 1..10 LOOP 
IF i mod 2 = 1 THEN t(i):=null;
END IF; 
END LOOP; 
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
FOR i IN t.FIRST..t.LAST LOOP 
DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
END LOOP; 
DBMS_OUTPUT.NEW_LINE; 
-- punctul c 
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!! 
-- din vectori nu se pot sterge elemente individuale!!! 
-- punctul d 
t.delete; 
DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.'); 
END; 
/



CREATE OR REPLACE TYPE subordonati_bcf AS VARRAY(10) OF NUMBER(4); 
/ 
CREATE TABLE manageri_bcf (cod_mgr NUMBER(10), 
nume VARCHAR2(20), 
lista subordonati_bcf); 
DECLARE 
v_sub subordonati_bcf:= subordonati_bcf(100,200,300); 
v_lista manageri_bcf.lista%TYPE; 
BEGIN 
INSERT INTO manageri_bcf 
VALUES (1, 'Mgr 1', v_sub); 
INSERT INTO manageri_bcf 
VALUES (2, 'Mgr 2', null); 
INSERT INTO manageri_bcf
VALUES (3, 'Mgr 3', subordonati_bcf(400,500)); 
SELECT lista 
INTO v_lista 
FROM manageri_bcf 
WHERE cod_mgr=1; 
FOR j IN v_lista.FIRST..v_lista.LAST loop 
DBMS_OUTPUT.PUT_LINE (v_lista(j)); 
END LOOP; 
END; 
/
SELECT * FROM manageri_bcf;
DROP TABLE manageri_bcf;
DROP TYPE subordonati_bcf;







CREATE TABLE emp_test_bcf AS 
SELECT employee_id, last_name FROM employees 
WHERE ROWNUM <= 2; 
CREATE OR REPLACE TYPE tip_telefon_bcf IS TABLE OF VARCHAR(12); 
/ 
ALTER TABLE emp_test_bcf 
ADD (telefon tip_telefon_bcf) 
NESTED TABLE telefon STORE AS tabel_telefon_bcf; 
INSERT INTO emp_test_bcf 
VALUES (500, 'XYZ',tip_telefon_bcf('074XXX', '0213XXX', '037XXX')); 
update emp_test_bcf 
SET telefon = tip_telefon_bcf('073XXX', '0214XXX') 
WHERE employee_id=100; 
SELECT a.employee_id, b.* 
FROM emp_test_bcf a, TABLE (a.telefon) b; 
DROP TABLE emp_test_bcf; 
DROP TYPE tip_telefon_bcf;
rollback;


DECLARE 
TYPE tip_cod IS VARRAY(5) OF NUMBER(3); 
coduri tip_cod := tip_cod(205,206); 
BEGIN 
FOR i IN coduri.FIRST..coduri.LAST LOOP 
DELETE FROM emp_bc 
WHERE employee_id = coduri (i); 
END LOOP; 
END; 
/ 
SELECT employee_id FROM emp_bc; 
ROLLBACK;

--exercitii de laborator
--exercitiul 1
declare 
--type coduri is table of employees.employee_id%TYPE;
type angajati is record (
cod_employees.employee_id%TYPE,
salariu employees.salary%TYPE);
type tablou_ang is table of angajati;
v_ang tablou_ang:=tablou_ang();
v_coduri coduri:=coduri();

begin

--for i in 1..5 loop
v_coduri.extend;
select *
bulk collect into v_ang.cod,v_ang.salariu
from
(select employee_id,salary
from employees
order by salary asc)
where rownum<=5;
--end loop;
for i in v_ang.first..v_ang.last loop
dbms_output.put_line(v_ang.cod(i));
update emp_bc
set salary = salary+salary*5/100
returning salary into v_ang.salariu(i)
where employee_id=v_ang.cod(i);
end loop;
end;
/