package body darraybooleans is
	procedure empty (s: out set) is
	begin
		for x in elem loop s(x):= false; end loop;
	end empty;
	
	procedure remove (s: in out set; x: in elem) is
	begin
		s(x):= false;
	end remove;
	
	procedure put (s: in out set; x: in elem) is
	begin
		s(x):= true;
	end put;
	
	function is_in (s: in set; x: in elem) return boolean is
	begin
		return s(x);
	end is_in;
	
	function is_empty (s: in set) return boolean is
		x: elem;
	begin
		x:= elem'first;
		while not s(x) and x<elem'last loop x:= elem'succ(x); end loop;
		return not s(x);
	end is_empty;
end darraybooleans;
