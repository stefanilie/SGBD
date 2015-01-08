/* 1.Pentru fiecare oraº, sã se afiºeze þara în care se aflã ºi numãrul de angajaþi din cadrul sãu. */
--cata the cold nosed student, has a really icy nose

select l.COUNTRY_ID, count(e.employee_id) from locations l join departments d on l.LOCATION_ID=d.LOCATION_ID 
                                                    join employees e on d.DEPARTMENT_ID = e.DEPARTMENT_ID 
                                                    group by l.COUNTRY_ID;
                                                    
--2 Care sunt primii 5 cel mai bine plãtiþi angajaþi? 
select first_name, salary from employees where rownum <=5 order by salary DESC;

--3 Sã se obþinã numãrul de angajaþi care au mai avut cel puþin trei job-uri, luându-se în considerare ºi job-ul curent. 
select e.employee_id from JOB_HISTORY j join employees e on j.EMPLOYEE_ID = e.EMPLOYEE_ID group by e.employee_id; --not done