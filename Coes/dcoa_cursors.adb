package body dcoa_cursors is
	type block is record
		x: 	  item;
		next: index;
	end record;
	
	type mem_space is array (index range 1..index'last) of block;
	
	ms: mem_space;
	free: index;
	
	--Procediments de gestió de memòria
	procedure prep_mem_space is
	begin
		for i in index range 1..index'last-1 loop
			ms(i).next:= i+1;
		end loop;
		ms(index'last).next:= 0;
		free:= 1;
	end prep_mem_space;
	
	function get_block return index is
		r: index;
	begin
		if free=0 then raise space_overflow; end if;
		r:= free; free:= ms(free).next; ms(r).next:= 0;
		return r;
	exception
		when constraint_error => raise space_overflow;
	end get_block;
	
	procedure release_block (r: in out index) is
	begin
		ms(r).next:= free;
		free:= r; r:= 0;
	end release_block;
	
	procedure release_queue (p,q: in out index) is
	begin
		ms(p).next:= free;
		free:= q;
		q:= 0; p:= 0;
	end release_queue;
	--Fi de procediments de gestió de memòria
	
	procedure empty (qu: out queue) is
		p: index renames qu.p;
		q: index renames qu.q;
	begin
		if q/=0 then release_queue (p,q); end if;
	end empty;
	
	function is_empty (qu: in queue) return boolean is
		q: index renames qu.q;
	begin
		return q=0;
	end is_empty;
	
	function get_first (qu: in queue) return item is
		q: index renames qu.q;
	begin
		return ms(q).x;
	exception
		when constraint_error => raise bad_use;
	end get_first;
	
	procedure put (qu: in out queue; x: in item) is
		r: index;
		p: index renames qu.p;
		q: index renames qu.q;
	begin
		r:= get_block;
		ms(r):= (x,0);
		if q=0 then
			q:= r; p:= r;
		else
			ms(p).next:= r; p:= r;
		end if;
	end put;
	
	procedure rem_first (qu: in out queue) is
		p: index renames qu.p;
		q: index renames qu.q;
		r: index;
	begin
		r:= q;
		q:= ms(q).next;
		if q=0 then p:=0; end if;
		release_block(r);
	exception
		when constraint_error => raise bad_use;
	end rem_first;
begin
	prep_mem_space;
end dcoa_cursors;
