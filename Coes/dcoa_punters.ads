generic
	type item is private;
package dcoa_punters is
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
	type cell;
	type pcell is access cell;
	type cell is record
		x: item;
		next: pcell;
	end record;
	type queue is record
		p,q: pcell;
	end record;
end dcoa_punters;
