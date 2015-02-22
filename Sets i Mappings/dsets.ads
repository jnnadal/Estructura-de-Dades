generic
	type elem is private;
package dsets is
	type set is limited private;
	
	space_overflow: exception;
	
	procedure empty    (s: out set);
	procedure put      (s: in out set; x: in elem);
	function  is_in    (s: in set; x: in elem) return boolean;
	procedure remove   (s: in out set; x: in elem);
	function  is_empty (s: in set) return boolean;
private
end dsets;
