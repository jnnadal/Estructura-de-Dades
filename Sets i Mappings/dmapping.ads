generic
	type key is private;
	type item is private;
package dmapping is
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
end dmapping;
