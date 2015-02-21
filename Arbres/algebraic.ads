with ada.text_io; use ada.text_io;
with dexpressions; use dexpressions;
package algebraic is
	syntax_error: exception;
	
	procedure read    (f: in file_type; e: out expression);
	procedure write   (f: in file_type; e: in expression);
	function derive   (e: in expression; x: in character) return expression;
	function simplify (e: in expression) return expression;
end algebraic;
