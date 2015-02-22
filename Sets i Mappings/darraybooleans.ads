generic
	type elem is (<>);
package darraybooleans is
	type set is limited private;
	
	space_overflow: exception;
	
	procedure empty    (s: out set);
	procedure put      (s: in out set; x: in elem);
	function  is_in    (s: in set; x: in elem) return boolean;
	procedure remove   (s: in out set; x: in elem);
	function  is_empty (s: in set) return boolean;
private
	type set is array(elem) of boolean;
	pragma pack(set);	--Obliga a que cada posició ocupi només un bit
end darraybooleans;
