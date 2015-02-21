generic
	type item is private;
package darbrebinari_punters is
	type tree is limited private;
	
	bad_use: exception;
	space_overflow: exception;
	
	procedure empty    (t: out tree);
	function  is_empty (t: in tree) return boolean;
	procedure graft    (t: out tree; lt, rt: in tree; x: in item);
	procedure root     (t: in tree; x: out item);
	procedure left     (t: in tree; lt: out tree);
	procedure right    (t: in tree; rt: out tree);
private
	type node;
	type pnode is access node;
	type node is record
		x:   item;
		l,r: pnode;
	end record;
	type tree is record
		root: pnode;
	end record;
end darbrebinari_punters;
