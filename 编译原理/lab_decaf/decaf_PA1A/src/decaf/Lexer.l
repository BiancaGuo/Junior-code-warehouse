/*
 * 本文件是构造Decaf编译器所需要的JFlex输入脚本。
 */

/*引入需要的头文件,这个段中的所有内容将被拷贝到生成的词法类的类声明之前*/
//用户代码段
package decaf.frontend;
import decaf.Location;
import decaf.error.*;
import decaf.utils.MiscUtils;
 
%%

//参数设置和声明段
//这个段含有参数，词法状态，和宏定义。
%public
%class Lexer//告诉 JFlex 把生成的类命名为Lexer并把代码写到名为Lexer.java的文件
%extends BaseLexer //继承一个已有的类
%byaccj
%line//参数 Line打开行计数，使你可以用变量yyline存取输入的当前行号
%column//通过变量yycolumn存取当前列号
%switch
%unicode//支持字符集中0-65535#字符，使用该字符集不会出现运行时的溢出现象。
	
//声明扫描器用到的成员变量和函数。可以加入的代码是Java代码，并放在 %{ 和 }%之间。它们将被拷贝到生成的词法类源代码中。
%{
	private Location sloc = null;
	private StringBuilder buffer = new StringBuilder();
	public Location getLocation() {
		return new decaf.Location(yyline + 1, yycolumn + 1);
	}
%}

//宏定义。宏用作正则表达式的缩写
NEWLINE				= (\r|\n|\r\n)//\r是回车符,\n是换行符
DIGIT 				= ([0-9])
HEX_DIGIT 			= ([0-9A-Fa-f])
HEX_INTEGER			= (0[Xx]{HEX_DIGIT}+)
DEC_INTEGER			= ({DIGIT}+)
INTEGER				= ({HEX_INTEGER}|{DEC_INTEGER})
IDENTIFIER			= ([A-Za-z][_0-9A-Za-z]*)//字母数字下划线
SIMPLE_OPERATOR		= ("+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"."|","|";"|"!"|"("|")"|"["|"]"|"{"|"}")
S_COMMENT			= ("//"[^\r\n]*{NEWLINE})//空字符串
WHITESPACE			= ([ \t]+)

// 开始条件S,可以在规则的活动部分使用BEGIN来激活，直到下一个BEGIN执行时，拥有给定开始条件的规则被激活，不拥有开始条件的规则不被激活
%x S

%%//词法规则段

	// 识别注释和空白字符的规则
{WHITESPACE}		{ /* Just ignore */    }
{NEWLINE}			{ /* Just ignore */    }
{S_COMMENT}			{ /* Just ignore */    }


	// 识别关键字的规则 
"void"				{ System.out.print("void"); return keyword(Parser.VOID);			}
"bool"				{ System.out.print("bool"); return keyword(Parser.BOOL);			}
"break"				{ System.out.print("break"); return keyword(Parser.BREAK);			}
"class"				{ return keyword(Parser.CLASS);			}
"else"				{ return keyword(Parser.ELSE);			}
"extends"			{ return keyword(Parser.EXTENDS);		}
"for"				{ return keyword(Parser.FOR);			}
"if"				{ return keyword(Parser.IF);			}
"int"				{ return keyword(Parser.INT);			}
"instanceof"		{ return keyword(Parser.INSTANCEOF);    }
"new"				{ return keyword(Parser.NEW);			}
"null"				{ return keyword(Parser.NULL);			}
"Print"				{ return keyword(Parser.PRINT);			}
"ReadInteger"		{ return keyword(Parser.READ_INTEGER);	}
"ReadLine"			{ return keyword(Parser.READ_LINE);		}
"return"			{ return keyword(Parser.RETURN);		}
"string"			{ return keyword(Parser.STRING);		}
"this"				{ return keyword(Parser.THIS);			}
"while"				{ return keyword(Parser.WHILE);			}
"static"			{ return keyword(Parser.STATIC);		}

	// 识别操作符的规则
"<="				{ System.out.print("<="); return operator(Parser.LESS_EQUAL);	       }
">="                { return operator(Parser.GREATER_EQUAL);       }
"&&"                { return operator(Parser.AND);                 }
"=="                { return operator(Parser.EQUAL);               }
"!="                { return operator(Parser.NOT_EQUAL);           }
"||"                { return operator(Parser.OR);                  }
{SIMPLE_OPERATOR}	{ return operator(yytext().charAt(0));	       }//匹配模式的文本
	// 识别常数的规则
"true"				{ return boolConst(true);										}
"false"				{ return boolConst(false);										}
{INTEGER}           { System.out.print(yytext()); return intConst(yytext());                                    }
{HEX_INTEGER}		{ return intConst(yytext().substring(2), 16);                   }
{DEC_INTEGER}		{ return intConst(yytext(), 10);		                        }

//YYINITIAL 是一个预定义的词法状态，是词法分析器初始扫描输入的状态。它是我们将用的唯一状态。所以，我们所有的正则表达式都将从这个词法状态开始识别。
//扫描器将从状态 YYINITIAL 开始。当它匹配了正则表达式\"，也就是找到了一个双引号，它将把状态转换到 S 状态。直到匹配到另一个”
<YYINITIAL>\"       { buffer = new StringBuilder();	 sloc = getLocation(); yybegin(S); }

/* 匹配字符串：matches all characters in the input up to the next backslash */
<S> {
\"                  { yybegin(YYINITIAL); return StringConst(buffer.toString(), getLocation());     }
[^\n\r\"\\]+        { buffer.append( yytext() );                                                    }
\\t                 { buffer.append('\t');                                                          }
\\n                 { buffer.append('\n');                                                          }
\\r                 { buffer.append('\r');                                                          }
\\\"                { buffer.append('\"');                                                          }
\\\\                { buffer.append('\\');                                                            }
<<EOF>>			    { issueError(new UntermStrError(sloc,MiscUtils.quote(buffer.toString()))); yybegin(YYINITIAL);}
{NEWLINE}		    { issueError(new NewlineInStrError(sloc,MiscUtils.quote(buffer.toString())));       }
}

// 识别标识符的规则
/*yytext变量：指向当前正被某规则匹配的字符串，yyleng：yytext字符串长度*/
{IDENTIFIER}        { return identifier(yytext());}
	// 上面规则不能识别的字符怎么处理
.					{ issueError(new UnrecogCharError(getLocation(),yytext().charAt(0)));	}

