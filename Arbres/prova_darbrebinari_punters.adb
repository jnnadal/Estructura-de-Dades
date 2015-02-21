with ada.text_io; use ada.text_io;
with darbrebinari_punters;

procedure prova_darbrebinari_punters is
	package darbre is new darbrebinari_punters (item=> character);
	use darbre;
	t, rt, lt: tree;
	c: character:= 'a';
	c1: character;
begin
	empty(t);
	empty(rt);
	empty(lt);
	if is_empty(t) then
		put ("Si");
	else
		put ("No");
	end if;
	graft(t,lt,rt,c);
	if is_empty(t) then
		put ("Si");
	else
		put ("No");
	end if;
	root(t,c1);
	put(c1);
end prova_darbrebinari_punters;
