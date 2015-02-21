package body dexpressions is
	function b_null return expression is
		p: pnode;
	begin
		p:= new node(e_null);
		return p;
	end b_null;
	
	function b_constant (n: in integer) return expression is
		p: pnode;
	begin
		p:= new node'(e_const, n);
		return p;
	end b_constant;
	
	function b_var (x: in character) return expression is
		p: pnode;
	begin
		p:= new node'(e_var, x);
		return p;
	end b_var;
	
	function b_un_op (op: in un_op; esb: in expression) return expression is
		p: pnode;
	begin
		p:= new node'(e_un,op,esb);
		return p;
	end b_un_op;
	
	function b_bin_op (op: in bin_op; esb1, esb2: in expression) return expression is
		p: pnode;
	begin
		p:= new node'(e_bin, op, esb1, esb2);
		return p;
	end b_bin_op;
	
	function e_type (e: in expression) return expression_type is
	begin
		return e.et;
	end e_type;
	
	function g_const (e: in expression) return integer is
	begin
		return e.val;
	end g_const;
	
	function g_var (e: in expression) return character is
	begin
		return e.var;
	end g_var;
	
	procedure g_un (e: in expression; op: out un_op; esb: out expression) is
	begin
		op:= e.opun;
		esb:= e.esb;
	end g_un;
	
	procedure g_bin (e: in expression; op: out bin_op; esb1, esb2: out expression) is
	begin
		op:= e.opbin;
		esb1:= e.esb1;
		esb2:= e.esb2;
	end g_bin;
end dexpressions;
