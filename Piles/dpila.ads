generic
	type item is private;
package dpila is
	pragma pure;

	type stack is limited private;

	bad_use 		: exception;
	space_overflow	: exception;

	procedure empty   (s: out stack);
	procedure push    (s: in out stack; x: in item;
	procedure pop     (s: in out stack);
	function top 	  (s: in stack) return item;
	function is_empty (s: in stack) return boolean;
private
end dpila;
