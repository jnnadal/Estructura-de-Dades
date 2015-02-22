package body dllistaenllasada_mapping is
	procedure empty (s: out set) is
		first: pcell renames s.first;
	begin
		first:= null;
	end empty;
	
	procedure put (s: in out set; k: in key; x: in item) is
		first: pcell renames s.first;
		pp, p, q: pcell;
	begin
		pp:= null; p:= first;
		while p/=null and then p.k<k loop pp:= p; p:= p.next; end loop;
		if p/=null and then p.k=k then raise already_exists; end if;
		
		q:= new cell; q.all:=(k,x,p);
		
		if pp=null then first:= q; else pp.next:= q; end if;
	exception
		when storage_error => raise space_overflow;
	end put; 
	
	procedure get (s: in set; k: in key; x: out item) is
		first: pcell renames s.first;
		p: pcell;
	begin
		p:= first;
		while p/=null and then p.k<k loop p:= p.next; end loop;
		if p=null or else p.k/=k then raise does_not_exist; end if;
		x:= p.x;
	end get;
	
	procedure update (s: in out set; k: in key; x: in item) is
		first: pcell renames s.first;
		p: pcell;
	begin
		p:= first;
		while p/=null and then p.k<k loop p:= p.next; end loop;
		if p=null or else p.k/=k then raise does_not_exist; end if;
		p.x:= x;
	end update;
	
	procedure remove (s: in out set; k: in key) is
		first: pcell renames s.first;
		p, pp: pcell;
	begin
		pp:= null; p:= first;
		while p/=null and then p.k<k loop pp:= p; p:= p.next; end loop;
		if p=null or else p.k/=k then raise does_not_exist; end if;
		if pp=null then first:= first.next; else pp.next:= p.next; end if;
	end remove;
end dllistaenllasada_mapping;
