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
	
	function simplify (e: in expression) return expression is
		s: expression;
	
		function simplify_un (e: in expression) return expression is
			uop, uops: un_op;
			s, esb, esb2: expression;
		begin
			g_un(e, uop, esb);
			esb:= simplify(esb);
			case uop is
				when neg =>
					if e_type(esb) = e_un then
						g_un(esb, uops, esb2);
						if uops=neg then
							s:= esb2; -- -(-E) => E
						else
							s:= e;
						end if;
					elsif e_type(esb)=e_const and then g_const(esb)=0 then
						s:= esb; -- -0 => 0
					else
						s:= b_un_op(uop, esb);
					end if;
				when sin =>
					if e_type(esb)=e_const and then g_const(esb)=0 then
						s:= esb; --sin(0) => 1
					else
						s:= b_un_op(uop, esb);
					end if;
				when cos =>
					if e_type(esb)=e_const and then g_const(esb)=0 then
						s:= b_constant(1); --cos(0) => 1
					else
						s:= b_un_op(uop, esb);
					end if;
				when exp =>
					if e_type(esb)=e_const and then g_const(esb)=0 then
						s:= b_constant(1);
					else
						s:= b_constant(uop, esb);
					end if;
				when ln =>
					if e_type(esb)=e_const and then g_const(esb)=1 then
						s:= b_constant(0);
					else
						s:= b_un_op(uop, esb);
					end if;
			end case;
			return s;
		end simplify_un;
		
		function simplify_bin(e: in expression) return expression is
			bop: bin_op;
			s, esb1, esb2: expression;
		
			function simplify_add(esb1, esb2: in expression) return expression is
				s: expression; n1, n2: integer;
			begin
				if e_type(esb1)=e_const and then g_const(esb1)=0 then
					s:= esb2;
				elsif e_type(esb2)=e_const and then g_const(esb2)=0 then
					s:= esb1;
				elsif e_type(esb1)=e_const and then e_type(esb2)=e_const then
					n1:= g_const(esb1); n2:= g_const(esb2);
					s:= b_constant(n1+n2);
				else
					s:= b_bin_op(add, esb1, esb2);
				end if;
				return s;
			end simplify_add;
			
			function simplify_sub(esb1, esb2: in expression) return expression is
				s: expression; n1, n2: integer;
			begin
				if e_type(esb2)=e_const and then g_const(esb2)=0 then
					s:= esb1;
				elsif e_type(esb1)=e_const and then g_const(esb1)=0 then
					s:= esb2;
				elsif e_type(esb1)=e_const and e_type(esb2)=e_const then
					n1:= g_const(esb1); n2:= g_const(esb2);
					n1:= n1-n2;
					if n1>0 then s:= b_constant(n1);
							else s:= b_constant(-n1); s:= b_un_op(neg, s);
					end if;
				else
					s:= b_bin_op(sub, esb1, esb2);
				end if;
				return s;
			end simplify_bin;
			
			function simplify_prod(esb1, esb2: in expression) return expression is
				s: expression; n1, n2: integer;
			begin
				if e_type(esb1)=e_const and then g_const(esb1)=0 then
					s:= esb1;
				elsif e_type(esb2)=e_const and then g_const(esb2)=0 then
					s:= esb2;
				elsif e_type(esb1)=e_const and then g_const(esb1)=1 then
					s:= esb2;
				elsif e_type(esb2)=e_const and then g_const(esb2)=1 then
					s:= esb1;
				elsif e_type(esb1)=e_const and then g_const(esb2)=e_const then
					n1:= g_const(esb1); n2:=g_const(esb2);
					s:=b_constant(n1*n2);
				else
					s:= b_bin_op(prod, esb1, esb2);
				end if;
				return s;
			end simplify_prod;
			
			function simplify_quot(esb1, esb2: in expression) return expression is
				s: expression;
			begin
				if e_type(esb1)=e_const and then g_const(esb1)=0 then
					s:= esb1;
				elsif e_type(esb2)=e_const and then g_const(esb2)=1 then
					s:= esb1;
				elsif esb1=esb2 then
					s:= b_constant(1);
				else
					s:= b_bin_op(quot, esb1, esb2);
				end if;
				return s;
			end simplify_quot;
			
			function simplify_power(esb1, esb2: in expression) return expression is
				s: expression;
			begin
				if e_type(esb1)=e_const and then g_const(esb1)=0 then
					s:= esb1;
				elsif e_type(esb2)=e_const and then g_const(esb2)=0 then
					s:= b_constant(1);
				elsif e_type(esb1)=e_const and then g_const(esb1)=1 then
					s:= esb1;
				elsif e_type(esb2)=e_const and then g_const(esb2)=1 then
					s:= esb1;
				else
					s:= b_bin_op(power, esb1, esb2);
				end if;
				return s;
			end simplify_power;
		
		begin
			g_bin(e, bop, esb1, esb2);
			esb1:= simplify(esb1);
			esb2:= simplify(esb2);
			case bop is
				when add => s:= simplify_add (esb1, esb2);
				when sub => s:= simplify_sub (esb1, esb2);
				when prod=> s:= simplify_prod(esb1, esb2);
				when quot=> s:= simplify_quot(esb1, esb2);
				when power=>s:= simplify_power(esb1,esb2);
			end case;
			return s;
		end simplify_bin;
	
	begin
		case e_type(e) is
			when e_null | e_const | e_var => s:= e;
			when e_un =>  s:= simplify_un (e);
			when e_bin => s:= simplify_bin (e);
		end case;
		return s;
	end simplify;
	
	procedure write (f: in file_type; e: in expression) is
		procedure write0(f: in file_type; e: in expression) is
			pr: boolean;
			uop: un_op;
			bop: bin_op;
			esb, esb1, esb2: expression;
		begin
			case e_type(e) is
				when e_null => null;
				when e_const => put_const(f, integer'image(g_const(e)));
				when e_var => put(f, g_var(e));
				when e_un =>
					g_un (e, uop, esb);
					put_uop(f, uop);
					pr:= parenth_req_un(e);
					
end algebraic;
