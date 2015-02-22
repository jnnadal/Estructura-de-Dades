generic
	type key is private;
	type item is private;
	with function "<" (k1, k2: in key) return boolean;
	with function ">" (k1, k2: in key) return boolean;
package darbredecercabinaria is
	type set is limited private;
	
	alread_exists:  exception;
	does_not_exist: exception;
	space_overflow: exception;
	
	procedure empty  (s: out set);
	procedure put    (s: in out set; k: in key; x: in item);
	procedure get    (s: in set; k: in key; x: out item);
	procedure remove (s: in out set; k: in key);
	procedure update (s: in out set; k: in key; x: in item);
private
	type node;
	type pnode is access node;
	type node is record
		k: key;
		x: item;
		lc, rc: pnode;
	end record;
	type set is record
		root: pnode;
	end record;
end darbredecercabinaria;
