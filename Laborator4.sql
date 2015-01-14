--exemplu procedure
/*--3. Sã se creeze o procedurã stocatã fãUã parametri care afiúeazã un mesaj 
“Programare PL/SQL”, ziua de astãzi în formatul DD-MONTH-YYYY úi ora curentã, 
precum úi ziua de ieri în formatul DDMON-YYYY. */

create procedure printdate is
  azi date := SYSDate;
begin
  dbms_output.put_line(to_char(azi, "dd-month-yyyy hh:mm"));
  azi:= azi-1;
  dbms_output.put_line(to_char(azi, "dd-mon-yyyy"));
end;


begin
  printdate();
end;
  