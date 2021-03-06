package body darbrebinari_punters is
	procedure empty (t: out tree) is
		p: pnode renames t.root;
	begin
		p:= null;
	end empty;
	
	function is_empty (t: in tree) return boolean is
		p: pnode renames t.root;
	begin
		return p=null;
	end is_empty;
	
	procedure graft (t: out tree; lt,rt: in tree; x: in item) is
		p:  pnode renames t.root;
		pl: pnode renames lt.root;
		pr: pnode renames rt.root;
	begin
		p:= new node;
		p.all:= (x,pl,pr);
	exception
		when storage_error => raise space_overflow;
	end graft;
	
	procedure root (t: in tree; x: out item) is
		p: pnode renames t.root;
	begin
		x:= p.x;
	exception
		when constraint_error => raise bad_use;
	end root;
	
	procedure left (t: in tree; lt: out tree) is
		p:  pnode renames t.root;
		pl: pnode renames lt.root;
	begin
		pl:= p.l;
	exception
		when constraint_error => raise bad_use;
	end left;
	
	procedure right (t: in tree; rt: out tree) is
		p:  pnode renames t.root;
		pr: pnode renames rt.root;
	begin
		pr:= p.r;
	exception
		when constraint_error => raise bad_use;
	end right;
end darbrebinari_punters;
