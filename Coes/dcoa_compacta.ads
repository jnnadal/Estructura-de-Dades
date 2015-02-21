generic
	type item is private;
	max: natural;
package dcoa_compacta is
	pragma pure;
	type queue is limited private;
	
	bad_use: 		exception;
	space_overflow: exception;
	
	procedure empty     (qu: out queue);
	procedure put       (qu: in out queue; x: in item);
	procedure rem_first (qu: in out queue);
	function  get_first (qu: in queue) return item;
	function  is_empty  (qu: in queue) return boolean;
private
	type index is new integer range 1..max;
	type mem_space is array (index) of item;
	type queue is record
		a:   mem_space;
		p,q: index;
		n:   natural;
	end record;
end dcoa_compacta;
