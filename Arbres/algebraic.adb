package body algebraic is
	procedure read (f: file_type; e: out expression) is
		c: character;
		procedure read_expr (e: out expression);
		procedure read_term (e: out expression);
		procedure read_factor(e: out expression);
		procedure read_factor1(e: out expression);
		function scan_id return un_op;
		function scan_num return integer;
		
		procedure read_expr(e: out expression) is
			neg_term: boolean;
			op:       character;
			e1:       expression;
		begin
			neg_term:= c= '-'; if neg_term then get(f,c); end if;
			read_term(e);
			if neg_term then e:= b_un_op(neg, e); end if;
			while c='+' or c='-' loop
				op:= c; get(f,c); read_term(e1);
				if op='+' then 
					e:= b_bin_op(add, e, e1);
				else
					e:= b_bin_op(sub, e, e1);
				end if;
			end loop;
		end read_expr;
		
		procedure read_term (e: out expression) is
			op: character;
			e1: expression;
		begin
			read_factor(e);
			while c='*' or c='/' loop
				op:= c; get(f,c); read_factor(e1);
				if op='*' then
					e:= b_bin_op(prod, e, e1);
				else
					e:= b_bin_op(quot, e, e1);
				end if;
			end loop;
		end read_term;
		
		procedure read_factor (e: out expression) is
			e1: expression;
		begin
			read_factor1(e1);
			if c='^' then
				get(f,c); read_factor1(e1);
				e:= b_bin_op(power, e, e1);
			end if;
		end read_factor;
		
		procedure read_factor1 (e: out expression) is
			t: un_op;
			x: character;
			n: integer;
		begin
			if c='(' then
				get(f,c); read_expr(e);
				if c/=')' then raise syntax_error; end if;
				get(f,c);
			elsif 'a'<=c and c<='z' then
				x:= c;
				t:= scan_id;
				if t=neg then
					e:= b_var(x);
				else
					if c/='(' then raise syntax_error; end if;
					get(f,c);
					read_expr(e);
					if c/=')' then raise syntax_error; end if;
					get(f,c);
					e:= b_un_op(t,e);
				end if;
			elsif '0'<=c and c<'9' then
				n:= scan_num;
				e:= b_constant(n);
			else
				raise syntax_error;
			end if;
		end read_factor1;
		
		function scan_id return un_op is
		begin
			if c='n' then
				get(f,c);
				if c='e' then
					get(f,c);
					if c='g' then
						return neg;
					else raise syntax_error; end if;
				else raise syntax_error; end if;	
			elsif c='s' then
				get(f,c);
				if c='i' then
					get(f,c);
					if c='n' then
						return sin;
					else raise syntax_error; end if;
				else raise syntax_error; end if;
			elsif c='c' then
				get(f,c);
				if c='o' then
					get(f,c);
					if c='s' then
						return cos;
					else raise syntax_error; end if;
				else raise syntax_error; end if;
			elsif c='e' then
				get(f,c);
				if c='x' then
					get(f,c);
					if c='p' then
						return exp;
					else raise syntax_error; end if;
				else raise syntax_error; end if;
			elsif c='l' then
				get(f,c);
				if c='n' then
					return ln;
				else raise syntax_error; end if;
			else raise syntax_error; end if;
		end scan_id;
		
		function scan_num return integer is
		begin
			return character'pos(c);
		end scan_num;
	begin
		get(f,c); read_expr(e);
		if c/=';' then raise syntax_error; end if;
	exception
		when syntax_error => e:= b_null; raise;
	end read;
	
	function derive (e: in expression; x: in character) return expression is
		de: expression;
		
		function derive_var (e: in expression; x: in character) return expression is
			de: expression;
		begin
			if g_var(e)=x then de:= b_constant(1);
						  else de:= b_constant(0);
			end if;
			return de;
		end derive_var;
		
		function derive_un (e: in expression; x: in character) return expression is
			uop: un_op;
			esb, de, desb: expression;
		begin
			g_un (e, uop, esb);
			desb:= derive (esb, x);
			case uop is
				when neg =>
					de:= b_un_op(neg, desb);
				when sin =>
					de:= b_un_op(cos, esb);
					de:= b_bin_op(prod, de, desb);
				when cos =>
					de:= b_un_op(sin, esb);
					de:= b_un_op(neg, de);
					de:= b_bin_op(prod, de, desb);
				when exp =>
					de:= b_bin_op(prod, e, desb);
				when ln =>
					de:= b_constant(1);
					de:= b_bin_op(quot, de, esb);
					de:= b_bin_op(prod, de, desb);
			end case;
			return de;
		end derive_un;
		
		function derive_bin (e: in expression; x: in character) return expression is
			bop:              bin_op;
			esb1, esb2:       expression;
			de, desb1, desb2: expression;
			a, b, c, d:       expression;	
			
			function contains(e: in expression; x: in character) return boolean is
				cont:            boolean;
				uop:             un_op;
				bop:             bin_op;
				esb, esb1, esb2: expression;
			begin
				case e_type(e) is
					when e_null | e_const =>
						cont:= false;
					when e_var =>
						cont:= g_var(e) = x;
					when e_un =>
						g_un (e, uop, esb);
						cont:= contains(esb, x);
					when e_bin =>
						g_bin(e, bop, esb1, esb2);
						cont:= contains(esb1, x) and then contains(esb2, x);
				end case;
				return cont;
			end contains;
		begin
			g_bin(e, bop, esb1, esb2);
			desb1:= derive(esb1, x);
			desb2:= derive(esb2, x);
			case bop is
				when add =>
					de:= b_bin_op(add, desb1, desb2);
				when sub =>
					de:= b_bin_op(sub, desb1, desb2);
				when prod =>
					a:= b_bin_op(prod, desb1, esb2);
					b:= b_bin_op(prod, desb2, esb1);
					de:= b_bin_op(add, a, b);
				when quot =>
					a:= b_bin_op(prod, desb1, esb2);
					b:= b_bin_op(prod, desb2, esb1);
					c:= b_bin_op(sub, a, b);
					d:= b_constant(2);
					d:= b_bin_op(power, esb2, d);
					de:= b_bin_op(quot, c, d);
				when power =>
					if not contains(esb2, x) then
						a:= b_constant(1);
						a:= b_bin_op(sub, esb2, a);
						a:= b_bin_op(power, esb1, a);
						a:= b_bin_op(prod, esb2, a);
						de:= b_bin_op(prod, a, desb1);
					else --f(x)^g(x) = exp(ln(f(x)^g(x)) = exp(g(x)*ln(f(x)))
						a:= b_un_op(ln, esb1);
						a:= b_bin_op(prod, esb2, a);
						a:= b_un_op(exp, a);
						de:= derive(a,x);
					end if;
			end case;
			return de;
		end derive_bin;
	begin
		case e_type(e) is
			when e_null => de:= b_null;
			when e_const => de:= b_constant(0);
			when e_var => de:= derive_var(e, x);
			when e_un => de:= derive_un (e, x);
			when e_bin => de:= derive_bin(e,x);
		end case;
		return de;
	end derive;
end algebraic;
