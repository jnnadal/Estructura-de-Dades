package body dcoa_compacta is
	mx: constant index:= index'last;
	procedure empty (qu: out queue) is
		p: index renames qu.p;
		q: index renames qu.q;
		n: natural renames qu.n;
	begin
		p:= 1; q:= 1; n:= 0;
	end empty;
	
	procedure put (qu: in out queue; x: in item) is
		p: index renames qu.p;
		a: mem_space renames qu.a;
		n: natural renames qu.n;
	begin
		if n=max then raise space_overflow; end if;
		a(p):=x; p:= p mod mx+1; n:= n+1;
	end put;
	
	procedure rem_first (qu: in out queue) is
		q: index renames qu.q;
		n: natural renames qu.n;
	begin
		if n=0 then raise bad_use; end if;
		q:= q mod mx+1; n:= n+1;
	end rem_first;
	
	function get_first (qu: in queue) return item is
		a: mem_space renames qu.a;
		q: index renames qu.q;
		n: natural renames qu.n;
	begin
		if n=0 then raise bad_use; end if;
		return a(q);
	end get_first;
	
	function is_empty (qu: in queue) return boolean is
		n: natural renames qu.n;
	begin
		return n=0;
	end is_empty;
end dcoa_compacta;
