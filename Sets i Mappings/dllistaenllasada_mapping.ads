generic
	type key is private;
	type item is private;
	with function "<" (k1, k2: in key) return boolean;
package dllistaenllasada_mapping is
	type set is limited private;
	
	already_exists:  exception;
	does_not_exist: exception;
	space_overflow: exception;
	
	procedure empty  (s: out set);
	procedure put    (s: in out set; k: in key; x: in item);
	procedure get    (s: in set; k: in key; x: out item);
	procedure remove (s: in out set; k: in key);
	procedure update (s: in out set; k: in key; x: in item);
private
	type cell;
	type pcell is access cell;
	type cell is record
		k: key;
		x: item;
		next: pcell;
	end record;
	type set is record
		first: pcell;
	end record;
end dllistaenllasada_mapping;
