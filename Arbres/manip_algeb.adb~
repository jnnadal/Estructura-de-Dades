with ada.text_io, ada.command_line, algebraic, dexpressions;
use ada.text_io, ada.command_line, algebraic, dexpressions;

procedure manip_algeb is
	f: file_type;
	e, de, sde: expression;
	x: character;
begin
	open (f, in_file, argument(1)&".txt");
	read(f,e);
	close(f);
	x:= argument(2)(1);
	
	de:= derive(e,x);
	sde:= simply(de);
	
	create (f, out_file, "d_"&argument(1)&".txt");
	write(f,sde);
	close(f);
end manip_algeb;
