package body dpila_cursors is
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
	
	procedure release_stack (p: in out index) is
		r: index;
	begin
		if p/=0 then
			r:= p;
			while ms(r).next /= 0 loop
				r:= ms(r).next;
			end loop;
			ms(r).next:= free; free:= p; p:= 0;
		end if;
	end release_stack;
	--Fi de procediments de gestió de memòria
	
	procedure empty (s: out stack) is
		p: index renames s.top;
	begin
		release_stack(p);
	end empty;
	
	function is_empty (s: in stack) return boolean is
		p: index renames s.top;
	begin
		return p=0;
	end is_empty;
	
	function top (s: in stack) return item is
		p: index renames s.top;
	begin
		return ms(p).x;
	exception
		when constraint_error => raise bad_use;
	end top;
	
	procedure push (s: in out stack; x: in item) is
		p: index renames s.top;
		r: index;
	begin
		r:= get_block;
		ms(r):= (x, p);
		p:= r;
	end push;
	
	procedure pop (s: in out stack) is
		p: index renames s.top;
		r: index;
	begin
		r:= p;
		p:= ms(p).next;
		release_block(r);
	exception
		when constraint_error => raise bad_use;
	end pop;
begin
	prep_mem_space;
end dpila_cursors;
