--2
SET SERVEROUTPUT ON 
DECLARE  
TYPE t_dep IS TABLE OF NUMBER;  
V_dep t_dep; 
BEGIN  
  SELECT department_id BULK COLLECT INTO v_dep 
  FROM emp_pnu;  FORALL j IN 1..v_dep.COUNT    
  INSERT INTO dep_emp_pnu      
    SELECT department_id,employee_id      
    FROM   emp_pnu      
    WHERE  department_id_id = v_dep(j);  
  FOR j IN 1..v_dep.COUNT LOOP    
  DBMS_OUTPUT.PUT_LINE ('Pentru departamentul avand codul ' ||V_dep(j) || ' au fost inserate ' || SQL%BULK_ROWCOUNT(j)||'inregistrari (angajati)');  
  END LOOP;  
  DBMS_OUTPUT.PUT_LINE ('Numarul total de inregistrari inserate este '||SQL%ROWCOUNT); 
END; 
