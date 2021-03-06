----lab 7

--lab2
--15
create table deptlmo as select * from DEPARTMENTS;

CREATE OR REPLACE TYPE COD_JOBl IS OBJECT
(COD NUMBER,
 JOB VARCHAR2(10));

CREATE OR REPLACE TYPE TAB_COD_JOBL IS TABLE OF COD_JOBL;

ALTER TABLE DEPTLMO ADD INFO TAB_COD_JOBL
NESTED TABLE INFO STORE AS LMO; --daca nu scriem nested at da eroare
/

SET SERVEROUTPUT ON;

DECLARE
lista tab_cod_jobl; -- nu mai tb initializat pt ca avem bulk collect

BEGIN
FOR D IN (SELECT * FROM DEPTLMO) LOOP
  -- d este o linie // este un obiect sau record
  SELECT COD_JOBL(EMPLOYEE_ID, JOB_ID) BULK COLLECT INTO LISTA
  -- am creat un obiect ca sa il punem in lista 
  FROM EMPLOYEES
  where department_id=d.department_id;
  
  UPDATE DEPTLMO
  SET INFO = LISTA
  where department_id=d.department_id;
END LOOP;

FOR D IN (SELECT * FROM DEPTLMO) LOOP
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(D.DEPARTMENT_NAME||': ');
    FOR ANG IN 1..D.INFO.COUNT LOOP
      DBMS_OUTPUT.PUT('('||D.INFO(ANG).COD||','||D.INFO(ANG).JOB||' )');
    end loop;
end loop;

END;
/
commit;

--17
SELECT ROWID, JOB_ID
from jobs;

CREATE TABLE EMPLMO AS SELECT * FROM EMPLOYEES;
/
set serveroutput on;
DECLARE
R_ID VARCHAR(20);
SIR VARCHAR2(40);
LINIE EMPLMO%ROWTYPE;

BEGIN
INSERT INTO EMPLMO(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES(789,'nume789','email789',SYSDATE,'SA_REP')
RETURNING ROWID INTO R_ID;
DBMS_OUTPUT.PUT_LINE(R_ID);

UPDATE EMPLMO
SET SALARY=1.3*SALARY
WHERE ROWID=R_ID
RETURNING LAST_NAME||FIRST_NAME INTO SIR;
DBMS_OUTPUT.PUT_LINE(SIR);

DELETE FROM EMPLMO
WHERE ROWID=R_ID
RETURNING EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID,
DEPARTMENT_ID INTO LINIE;
--toate coloanele din emplmo
dbms_output.put_line(linie.email||' '||linie.hire_date);
END;
/
commit;

--20
/*
+ a[i][j] 
i sa repr toti sefii (codurile)
a[i][j] -  j este subalternul lui i
*/
SET SERVEROUTPUT ON;

DECLARE
TYPE TAB_IMB IS TABLE OF EMPLOYEES%ROWTYPE;
TYPE TAB_IND IS TABLE OF TAB_IMB INDEX BY BINARY_INTEGER;
SEFI TAB_IND; 
cod_max number;
BEGIN
FOR SEF IN ( SELECT DISTINCT MANAGER_ID
              FROM EMPLOYEES
              WHERE MANAGER_ID IS NOT NULL) LOOP
--  sefi(sef.manager_id) --lista subalterni            
--sefi(sef.manager_id tabel imb deci extend
  SELECT MAX(EMPLOYEE_ID) INTO COD_MAX
  FROM EMPLOYEES 
  START WITH MANAGER_ID=SEF.MANAGER_ID
  CONNECT BY PRIOR EMPLOYEE_ID =MANAGER_ID;
  SEFI(SEF.MANAGER_ID):=TAB_IMB();
  SEFI(SEF.MANAGER_ID).EXTEND(COD_MAX);
  FOR SUB IN (SELECT * 
              FROM EMPLOYEES
              START WITH MANAGER_ID=SEF.MANAGER_ID
              connect by prior employee_id =manager_id) LOOP
    SEFI(SEF.MANAGER_ID)(SUB.EMPLOYEE_ID):=SUB;
  end loop;
 
END LOOP;

DBMS_OUTPUT.PUT_LINE(SEFI(100).COUNT);
DBMS_OUTPUT.PUT_LINE(SEFI(100)(203).salary);
end;