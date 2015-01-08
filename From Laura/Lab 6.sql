--colectii pe mai multe niveluri

--vectori
set serveroutput on;

declare 
start1 number := &nr;
nr_el number := 100;

type celula is record
(nr number,
 info boolean);

type vector is array(100) of celula;
v vector := vector();

begin

for i in start1..start1+nr_el-1 loop -- vrem ca start sa fie primul elem
  v.extend;
  v(v.count).nr := i;
  v(v.count).info := true; -- pp ca toate nr sunt prime
end loop;
/*
for i in 2..floor(sqrt(v(nr_el).nr)) loop
  --dbms_output.put_line(i||': ');
  for j in round(v(1).nr/i)..floor(v(nr_el).nr/i) loop
    --dbms_output.put_line(i||' '||round((nr_el)/j));
    -- v(round((start1+1)/i)).info := false;
    v(abs(i*j-start1)+1).info := false;
   -- dbms_output.put(start1+i*j-1||' ');
  end loop;
 -- dbms_output.put_line(' ');
end loop;*/

 -- se mai poate si asa (in loc de for-ul de mai sus):
for i in 2..sqrt(start1+nr_el-1) loop
  for j in i+1..v.count loop
    if mod(v(j).nr,i) = 0 then
      v(j).info := false;
    end if;
  end loop;
end loop;


for i in 1..nr_el loop
  if v(i).info = true then
    dbms_output.put_line(v(i).nr);
  end if;
end loop;

end;
