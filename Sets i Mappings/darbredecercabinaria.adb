package body darbredecercabinaria is
	procedure empty (s: out set) is
		root: pnode renames s.root;
	begin
		root:= null;
	end empty;
	
	procedure put (s: in out set; k: in item; x: in item) is
		root: pnode renames s.root;
		procedure put(p: in out pnode; k: in item; x: in item) is
		begin
			if p=null then
				p:= new node; p.all:= (x, k, null, null);
			else
				if    k<p.k then put(p.lc, k, x);
				elsif k>p.k then put(p.rc, k, x);
				else  raise already_exists;
				end if;
			end if;
		exception
			when storage_error => raise space_overflow;
		end put;
	begin
		put(root, k, x);
	end put;
	
	procedure get (s: in set; k: in item; x: out item) is
		root: pnode renames s.root;
		procedure get (p: in pnode; k: in item; x: out item) is
		begin
			if p=null then raise does_not_exist;
			else
				if    p.k<k then get (p.lc, k, x);
				elsif p.k>k then get (p.rc, k, x);
				else  x:= p.x;
				end if;
			end if;
		end get;
	begin
		get (root, k, x);
	end get;
	
	procedure update (s: in out set; k: in key; x: in item) is
		root: pnode renames s.root;
		procedure update (p: in out pnode; k: in key; x: in item) is
		begin
			if p=null then raise does_not_exist;
			else
				if    p.k<k then get (p.lc, k, x);
				elsif p.k>k then get (p.rc, k, x);
				else  p.x:= x;
				end if;
			end if;
		end update;
	begin
		update (root, k, x);
	end update;
	
	procedure remove (s: in out set; k: in key) is
		root: pnode renames s.root;
		procedure remove (p: in out pnode; k: in key) is
			procedure actual_remove (p: in out pnode) is
				plowest: pnode;
				procedure rem_lowest (p: in out pnode; plowest: out pnode) is
				begin
					if p.lc/=null then rem_lowest(p.lc, plowest);
								  else plowest:= p; p:= p.rc;
					end if;
				end rem_lowest;
			begin
				if p.lc=null and p.rc=null then
					p:= null;
				elsif p.lc=null and p.rc/=null then
					p:= p.rc;
				elsif p.lc/=null and p.rc=null then
					p:= p.lc;
					rem_lowest(p.rc, plowest);
					plowest.lc:= p.lc; plowest.rc:= p.rc; p:= plowest;
				end if;
			end actual_remove;
		begin
			if p=null then raise does_not_exist; end if;
			if    p.k<k then remove (p.rc, k);
			elsif p.k>k then remove (p.lc, k);
			else  actual_remove(p);
			end if;
		end remove;
	begin
		remove (root, k);
	end remove;
