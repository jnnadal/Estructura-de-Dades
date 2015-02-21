with ada.text_io; use ada.text_io;
with dcoa_cursors;

procedure prova_dcoa_cursors is
	package dcoa is new dcoa_cursors (item=> character, max=> 100);
	use dcoa;
	q: queue;
	c: character;
begin
	empty (q);
	put(q,'z');
	for i in 1..99 loop
		put(q,'a');
	end loop;
	c:= get_first(q);
	put(c);
end prova_dcoa_cursors;
