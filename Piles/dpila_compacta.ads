generic
	type item is private;
	max: natural;
package dpila_compacta is
	pragma pure;

	type stack is limited private;

	bad_use 		: exception;
	space_overflow	: exception;

	procedure empty   (s: out stack);
	procedure push    (s: in out stack; x: in item);
	procedure pop     (s: in out stack);
	function top 	  (s: in stack) return item;
	function is_empty (s: in stack) return boolean;
private
	type index is new integer range 0..max;
	type mem_space is array (index range 1..index'last) of item;
	
	type stack is record
		a: mem_space;
		n: index;
	end record;
end dpila_compacta;
