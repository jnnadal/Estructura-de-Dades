package body darraybooleans_mapping is
	procedure empty (s: out set) is
		e: existence renames s.e;
	begin
		for k in key loop e(k):=false; end loop;
	end empty;
	
	procedure put (s: in out set; k: in key; x: in item) is
		e: existence renames s.e;
		c: contents renames s.c;
	begin
		if e(k) then raise already_exists; end if;
		e(k):= true; c(k):= x;
	end put;
	
	procedure update (s: in out set; k: in key; x: in item) is
		e: existence renames s.e;
		c: contents renames s.c;
	begin
		if not e(k) then raise does_not_exist; end if;
		c(k):= x;
	end update;
	
	procedure get (s: in set; k: in key; x: out item) is
		e: existence renames s.e;
		c: contents renames s.c;
	begin
		if not e(k) then raise does_not_exist; end if;
		x:= c(k);
	end get;
	
	procedure remove (s: in out set; k: in key) is
		e: existence renames s.e;
	begin
		if not e(k) then raise does_not_exist; end if;
		e(k):= false;
	end remove;
end darraybooleans_mapping;
