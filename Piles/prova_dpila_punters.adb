with dpila_cursors;
with ada.text_io; use ada.text_io;

procedure prova_dpila_cursors is
	package dpila is new dpila_cursors (item => character, 100);
	use dpila;
	pila: stack;
	c: character;
begin
	empty(pila);
	push (pila, 'a');
	push (pila, 'b');
	c:= top (pila);
	put (c);
	pop (pila);
	c:= top(pila);
	put(c);
end prova_dpila_punters;
