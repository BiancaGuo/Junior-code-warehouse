/*
 * 本文件提供实现Decaf编译器所需要的BYACC脚本。
 * 在第一阶段中你需要补充完整这个文件中的语法规则。
 * 请参考"YACC--Yet Another Compiler Compiler"中关于如何编写BYACC脚本的说明。
 * 
 * Keltin Leung
 * DCST, Tsinghua University
 */
 
%{
package decaf.frontend;

import decaf.tree.Tree;
import decaf.tree.Tree.*;
import decaf.error.*;
import java.util.*;
%}

%Jclass Parser
%Jextends BaseParser
%Jsemantic SemValue
%Jimplements ReduceListener
%Jnorun
%Jnodebug
%Jnoconstruct

%token VOID   BOOL  INT   STRING  CLASS 
%token NULL   EXTENDS     THIS     WHILE   FOR   
%token IF     ELSE        RETURN   BREAK   NEW
%token PRINT  READ_INTEGER         READ_LINE
%token LITERAL
%token IDENTIFIER	  AND    OR    STATIC  INSTANCEOF
%token LESS_EQUAL   GREATER_EQUAL  EQUAL   NOT_EQUAL
%token '+'  '-'  '*'  '/'  '%'  '='  '>'  '<'  '.'
%token ','  ';'  '!'  '('  ')'  '['  ']'  '{'  '}'

%left OR
%left AND 
%nonassoc EQUAL NOT_EQUAL
%nonassoc LESS_EQUAL GREATER_EQUAL '<' '>'
%left  '+' '-'
%left  '*' '/' '%'  
%nonassoc UMINUS '!' 
%nonassoc '[' '.' 
%nonassoc ')' EMPTY
%nonassoc ELSE

%start Program

%%
Program			:	ClassList
					{
						tree = new Tree.TopLevel($1.clist, $1.loc);
					}
				;

ClassList       :	ClassList ClassDef
					{
						$$.clist.add($2.cdef);
					}
                |	ClassDef
                	{
                		$$.clist = new ArrayList<Tree.ClassDef>();
                		$$.clist.add($1.cdef);
                	}
                ;

VariableDef     :	Variable ';'
				;

Variable        :	Type IDENTIFIER
					{
						$$.vdef = new Tree.VarDef($2.ident, $1.type, $2.loc);
					}
				;
				
Type            :	INT
					{
						$$.type = new Tree.TypeIdent(Tree.INT, $1.loc);
					}
				|	VOID
                	{
                		$$.type = new Tree.TypeIdent(Tree.VOID, $1.loc);
                	}
                |	BOOL
                	{
                		$$.type = new Tree.TypeIdent(Tree.BOOL, $1.loc);
                	}
                |	STRING
                	{
                		$$.type = new Tree.TypeIdent(Tree.STRING, $1.loc);
                	}
                |	CLASS IDENTIFIER
                	{
                		$$.type = new Tree.TypeClass($2.ident, $1.loc);
                	}
                |	Type '[' ']'
                	{
                		$$.type = new Tree.TypeArray($1.type, $1.loc);
                	}
                ;

ClassDef        :	CLASS IDENTIFIER ExtendsClause '{' FieldList '}'
					{
						$$.cdef = new Tree.ClassDef($2.ident, $3.ident, $5.flist, $1.loc);
					}
                ;

ExtendsClause	:	EXTENDS IDENTIFIER
					{
						$$.ident = $2.ident;
					}
                |	/* empty */
                	{
                		$$ = new SemValue();
                	}
                ;

FieldList       :	FieldList VariableDef
					{
						$$.flist.add($2.vdef);
					}
				|	FieldList FunctionDef
					{
						$$.flist.add($2.fdef);
					}
                |	/* empty */
                	{
                		$$ = new SemValue();
                		$$.flist = new ArrayList<Tree>();
                	}
                ;
 
Formals         :	VariableList
                |	/* empty */
                	{
                		$$ = new SemValue();
                		$$.vlist = new ArrayList<Tree.VarDef>(); 
                	}
                ;

VariableList    :	VariableList ',' Variable
					{
						$$.vlist.add($3.vdef);
					}
                |	Variable
                	{
                		$$.vlist = new ArrayList<Tree.VarDef>();
						$$.vlist.add($1.vdef);
                	}
                ;

FunctionDef    :	STATIC Type IDENTIFIER '(' Formals ')' StmtBlock
					{
						$$.fdef = new MethodDef(true, $3.ident, $2.type, $5.vlist, (Block) $7.stmt, $3.loc);
					}
				|	Type IDENTIFIER '(' Formals ')' StmtBlock
					{
						$$.fdef = new MethodDef(false, $2.ident, $1.type, $4.vlist, (Block) $6.stmt, $2.loc);
					}
                ;

StmtBlock       :	'{' StmtList '}'
					{
						$$.stmt = new Block($2.slist, $1.loc);
					}
                ;
	
StmtList        :	StmtList Stmt
					{
						$$.slist.add($2.stmt);
					}
                |	/* empty */
                	{
                		$$ = new SemValue();
                		$$.slist = new ArrayList<Tree>();
                	}
                ;

Stmt		    :	VariableDef
					{
						$$.stmt = $1.vdef;
					}
				|	SimpleStmt ';'
                |	IfStmt
                |	WhileStmt
                |	ForStmt
                |	ReturnStmt ';'
                |	PrintStmt ';'
                |	BreakStmt ';'
                |	StmtBlock
                ;


SimpleStmt      :	LValue '=' Expr
					{
						$$.stmt = new Tree.Assign($1.lvalue, $3.expr, $1.loc);
					}
                |	Call
                	{
                		$$.stmt = $1.expr;
                	}
                |	/* empty */
                	{
                		$$ = new SemValue();
                	}
                ;

LValue          :	Expr '.' IDENTIFIER
					{
						$$.lvalue = new Ident($1.expr, $3.ident, $1.loc);
					}
				|   IDENTIFIER
					{
						$$.lvalue = new Ident(null, $1.ident, $1.loc);
					}
                |	Expr '[' Expr ']'
                	{
                		$$.lvalue = new Indexed($1.expr, $3.expr, $1.loc);
                	}
                ;

Call            :	Expr '.' IDENTIFIER '(' Actuals ')'
					{
						$$.expr = new CallExpr($1.expr, $3.ident, $5.elist, $1.loc);
					}
				|   IDENTIFIER '(' Actuals ')'
					{
						$$.expr = new CallExpr(null, $1.ident, $3.elist, $1.loc);
					}
                ;

Expr            :	LValue
					{
						$$.expr = $1.lvalue;
					}
                |	Call
                |	Expr '+' Expr
                	{
                		$$.expr = new Binary(Tree.PLUS,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '-' Expr
                	{
                		$$.expr = new Binary(Tree.MINUS,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '*' Expr
                	{
                		$$.expr = new Binary(Tree.MUL,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '/' Expr
                	{
                		$$.expr =new Binary(Tree.DIV,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '%' Expr
                	{
                		$$.expr = new Binary(Tree.MOD,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr EQUAL Expr
                	{
                		$$.expr = new Binary(Tree.EQ,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr NOT_EQUAL Expr
                	{
                		$$.expr = new Binary(Tree.NE,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr AND Expr
                	{
                		$$.expr = new Binary(Tree.AND,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr OR Expr
                	{
                		$$.expr = new Binary(Tree.OR,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '<' Expr
                	{
                		$$.expr = new Binary(Tree.LT,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr LESS_EQUAL Expr
                	{
                		$$.expr = new Binary(Tree.LE,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr '>' Expr
                	{
                		$$.expr = new Binary(Tree.GT,$1.expr, $3.expr, $1.loc);
                	}
                |	Expr GREATER_EQUAL Expr
                	{
                		$$.expr = new Binary(Tree.GE,$1.expr, $3.expr, $1.loc);
                	}
                
                |	'(' Expr ')'
                	{
                		$$ = $2;
                	}
                |	'-' Expr  %prec '*'
                	{
                		$$.expr = new Unary(Tree.NEG,$2.expr, $1.loc);
                	}
                |	'!' Expr
                	{
                		$$.expr = new Unary(Tree.NOT,$2.expr, $1.loc);
                	}
                |	READ_INTEGER '(' ')'
                	{
                		$$.expr = new ReadIntExpr($1.loc);
                	}
                |	READ_LINE '(' ')'
                	{
                		$$.expr = new ReadLineExpr($1.loc);
                	}
                |	NULL
               		{
               			$$.expr = new Null($1.loc);
               		} 
                |	LITERAL		
                	{
                      	$$.expr = new Literal($1.typeTag, $1.literal, $1.loc); 
               		}	
                |	THIS
                	{
                		$$.expr = new ThisExpr($1.loc);
                	}
                |	INSTANCEOF '(' Expr ',' IDENTIFIER ')'
               		{
               			$$.expr = new TypeTest($3.expr, $5.ident, $1.loc);
               		} 
                |	'(' CLASS IDENTIFIER ')' Expr
               		{
               			$$.expr = new TypeCast($3.ident, $5.expr,$1.loc);
               		}
                |	NEW IDENTIFIER '(' ')'
                	{
                		$$.expr = new NewClass($2.ident, $1.loc);
                	}
                |	NEW Type '[' Expr ']'
                	{
                		$$.expr = new NewArray($2.type, $4.expr, $1.loc);
                	}
                ;
Actuals         :	ExprList
                |	/* empty */
                	{
                		$$ = new SemValue();
                		$$.elist = new ArrayList<Tree.Expr>();
                	}
                ;

ExprList        :	ExprList ',' Expr
					{
						$$.elist.add($3.expr);
					}
                |	Expr
                	{
                		$$.elist = new ArrayList<Tree.Expr>();
						$$.elist.add($1.expr);
                	}
                ;
    
WhileStmt       :	WHILE '(' Expr ')' Stmt
					{
						$$.stmt = new Tree.WhileLoop($3.expr, $5.stmt, $1.loc);
					}
                ;

ForStmt         :	FOR '(' SimpleStmt ';' Expr ';'	SimpleStmt ')' Stmt
					{
						$$.stmt = new Tree.ForLoop($3.stmt, $5.expr, $7.stmt, $9.stmt, $1.loc);
					}
                ;

BreakStmt       :	BREAK
					{
						$$.stmt = new Tree.Break($1.loc);
					}
                ;

IfStmt          :	IF '(' Expr ')' Stmt ElseClause
					{
						$$.stmt = new Tree.If($3.expr, $5.stmt, $6.stmt, $1.loc);
					}
                ;

ElseClause      :	ELSE Stmt
					{
						$$.stmt = $2.stmt;
					}
				|	/* empty */	 %prec EMPTY
					{
						$$ = new SemValue();
					}
                ;

ReturnStmt      :	RETURN Expr
					{
						$$.stmt = new Tree.Return($2.expr, $1.loc);
					}
                |	RETURN
                	{
                		$$.stmt = new Tree.Return(null, $1.loc);
                	}
                ;

PrintStmt       :	PRINT '(' ExprList ')'
					{
						$$.stmt = new Tree.Print($3.elist, $1.loc);
					}
                ;
%%
    
	/**
	 * 打印当前归约所用的语法规则<br>
	 * 请勿修改。
	 */
    public boolean onReduce(String rule) {
		if (rule.startsWith("$$"))
			return false;
		else
			rule = rule.replaceAll(" \\$\\$\\d+", "");

   	    if (rule.endsWith(":"))
    	    System.out.println(rule + " <empty>");
   	    else
			System.out.println(rule);
		return false;
    }
    
    public void diagnose() {
		addReduceListener(this);
		yyparse();
	}