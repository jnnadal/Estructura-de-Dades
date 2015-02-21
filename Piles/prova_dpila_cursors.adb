with dpila_cursors;
with ada.text_io; use ada.text_io;

procedure prova_dpila_cursors is
	package dpila is new dpila_cursors (item => character, max=> 100);
	use dpila;
	pila: stack;
	c: character;
begin
	for i in 1..99 loop
		push(pila,'a');
	end loop;
	push(pila,'b');
	c:= top(pila);
	put(c);
	empty(pila);
	push(pila,'c');
	c:= top(pila);
	put(c);
end prova_dpila_cursors;
