with dpila_compacta;
with ada.text_io; use ada.text_io;

procedure prova_dpila_compacta is
	package dpila is new dpila_compacta (item => character, max => 100);
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
end prova_dpila_compacta;
