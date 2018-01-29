//### This file created by BYACC 1.8(/Java extension  1.13)
//### Java capabilities added 7 Jan 97, Bob Jamison
//### Updated : 27 Nov 97  -- Bob Jamison, Joe Nieten
//###           01 Jan 98  -- Bob Jamison -- fixed generic semantic constructor
//###           01 Jun 99  -- Bob Jamison -- added Runnable support
//###           06 Aug 00  -- Bob Jamison -- made state variables class-global
//###           03 Jan 01  -- Bob Jamison -- improved flags, tracing
//###           16 May 01  -- Bob Jamison -- added custom stack sizing
//###           04 Mar 02  -- Yuval Oren  -- improved java performance, added options
//###           14 Mar 02  -- Tomas Hurka -- -d support, static initializer workaround
//###           14 Sep 06  -- Keltin Leung-- ReduceListener support, eliminate underflow report in error recovery
//### Please send bug reports to tom@hukatronic.cz
//### static char yysccsid[] = "@(#)yaccpar	1.8 (Berkeley) 01/20/90";






//#line 11 "Parser.y"
package decaf.frontend;

import decaf.tree.Tree;
import decaf.tree.Tree.*;
import decaf.error.*;
import java.util.*;
//#line 25 "Parser.java"
interface ReduceListener {
  public boolean onReduce(String rule);
}




public class Parser
             extends BaseParser
             implements ReduceListener
{

boolean yydebug;        //do I want debug output?
int yynerrs;            //number of errors so far
int yyerrflag;          //was there an error?
int yychar;             //the current working character

ReduceListener reduceListener = null;
void yyclearin ()       {yychar = (-1);}
void yyerrok ()         {yyerrflag=0;}
void addReduceListener(ReduceListener l) {
  reduceListener = l;}


//########## MESSAGES ##########
//###############################################################
// method: debug
//###############################################################
void debug(String msg)
{
  if (yydebug)
    System.out.println(msg);
}

//########## STATE STACK ##########
final static int YYSTACKSIZE = 500;  //maximum stack size
int statestk[] = new int[YYSTACKSIZE]; //state stack
int stateptr;
int stateptrmax;                     //highest index of stackptr
int statemax;                        //state when highest index reached
//###############################################################
// methods: state stack push,pop,drop,peek
//###############################################################
final void state_push(int state)
{
  try {
		stateptr++;
		statestk[stateptr]=state;
	 }
	 catch (ArrayIndexOutOfBoundsException e) {
     int oldsize = statestk.length;
     int newsize = oldsize * 2;
     int[] newstack = new int[newsize];
     System.arraycopy(statestk,0,newstack,0,oldsize);
     statestk = newstack;
     statestk[stateptr]=state;
  }
}
final int state_pop()
{
  return statestk[stateptr--];
}
final void state_drop(int cnt)
{
  stateptr -= cnt; 
}
final int state_peek(int relative)
{
  return statestk[stateptr-relative];
}
//###############################################################
// method: init_stacks : allocate and prepare stacks
//###############################################################
final boolean init_stacks()
{
  stateptr = -1;
  val_init();
  return true;
}
//###############################################################
// method: dump_stacks : show n levels of the stacks
//###############################################################
void dump_stacks(int count)
{
int i;
  System.out.println("=index==state====value=     s:"+stateptr+"  v:"+valptr);
  for (i=0;i<count;i++)
    System.out.println(" "+i+"    "+statestk[i]+"      "+valstk[i]);
  System.out.println("======================");
}


//########## SEMANTIC VALUES ##########
//## **user defined:SemValue
String   yytext;//user variable to return contextual strings
SemValue yyval; //used to return semantic vals from action routines
SemValue yylval;//the 'lval' (result) I got from yylex()
SemValue valstk[] = new SemValue[YYSTACKSIZE];
int valptr;
//###############################################################
// methods: value stack push,pop,drop,peek.
//###############################################################
final void val_init()
{
  yyval=new SemValue();
  yylval=new SemValue();
  valptr=-1;
}
final void val_push(SemValue val)
{
  try {
    valptr++;
    valstk[valptr]=val;
  }
  catch (ArrayIndexOutOfBoundsException e) {
    int oldsize = valstk.length;
    int newsize = oldsize*2;
    SemValue[] newstack = new SemValue[newsize];
    System.arraycopy(valstk,0,newstack,0,oldsize);
    valstk = newstack;
    valstk[valptr]=val;
  }
}
final SemValue val_pop()
{
  return valstk[valptr--];
}
final void val_drop(int cnt)
{
  valptr -= cnt;
}
final SemValue val_peek(int relative)
{
  return valstk[valptr-relative];
}
//#### end semantic value section ####
public final static short VOID=257;
public final static short BOOL=258;
public final static short INT=259;
public final static short STRING=260;
public final static short CLASS=261;
public final static short NULL=262;
public final static short EXTENDS=263;
public final static short THIS=264;
public final static short WHILE=265;
public final static short FOR=266;
public final static short IF=267;
public final static short ELSE=268;
public final static short RETURN=269;
public final static short BREAK=270;
public final static short NEW=271;
public final static short PRINT=272;
public final static short READ_INTEGER=273;
public final static short READ_LINE=274;
public final static short LITERAL=275;
public final static short IDENTIFIER=276;
public final static short AND=277;
public final static short OR=278;
public final static short STATIC=279;
public final static short INSTANCEOF=280;
public final static short LESS_EQUAL=281;
public final static short GREATER_EQUAL=282;
public final static short EQUAL=283;
public final static short NOT_EQUAL=284;
public final static short UMINUS=285;
public final static short EMPTY=286;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    0,    1,    1,    3,    4,    5,    5,    5,    5,    5,
    5,    2,    6,    6,    7,    7,    7,    9,    9,   10,
   10,    8,    8,   11,   12,   12,   13,   13,   13,   13,
   13,   13,   13,   13,   13,   14,   14,   14,   21,   21,
   21,   23,   23,   22,   22,   22,   22,   22,   22,   22,
   22,   22,   22,   22,   22,   22,   22,   22,   22,   22,
   22,   22,   22,   22,   22,   22,   22,   22,   22,   22,
   24,   24,   25,   25,   16,   17,   20,   15,   26,   26,
   18,   18,   19,
};
final static short yylen[] = {                            2,
    1,    2,    1,    2,    2,    1,    1,    1,    1,    2,
    3,    6,    2,    0,    2,    2,    0,    1,    0,    3,
    1,    7,    6,    3,    2,    0,    1,    2,    1,    1,
    1,    2,    2,    2,    1,    3,    1,    0,    3,    1,
    4,    6,    4,    1,    1,    3,    3,    3,    3,    3,
    3,    3,    3,    3,    3,    3,    3,    3,    3,    2,
    2,    3,    3,    1,    1,    1,    6,    5,    4,    5,
    1,    0,    3,    1,    5,    9,    1,    6,    2,    0,
    2,    1,    4,
};
final static short yydefred[] = {                         0,
    0,    0,    0,    3,    0,    2,    0,    0,   13,   17,
    0,    7,    8,    6,    9,    0,    0,   12,   15,    0,
    0,   16,   10,    0,    4,    0,    0,    0,    0,   11,
    0,   21,    0,    0,    0,    0,    5,    0,    0,    0,
   26,   23,   20,   22,    0,   64,   66,    0,    0,    0,
    0,   77,    0,    0,    0,    0,   65,    0,    0,    0,
    0,    0,   24,   27,   35,   25,    0,   29,   30,   31,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   44,
    0,   45,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   28,   32,   33,   34,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   62,   63,    0,    0,    0,    0,   59,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   69,    0,    0,   83,
   43,    0,    0,    0,   41,   75,    0,    0,   70,    0,
    0,   68,    0,    0,    0,   78,   67,   42,    0,   79,
    0,   76,
};
final static short yydgoto[] = {                          2,
    3,    4,   64,   20,   33,    8,   11,   22,   34,   35,
   65,   45,   66,   67,   68,   69,   70,   71,   72,   73,
   80,   75,   82,  123,  124,  166,
};
final static short yysindex[] = {                      -240,
 -251,    0, -240,    0, -234,    0, -237,  -69,    0,    0,
  572,    0,    0,    0,    0, -220, -214,    0,    0,    9,
  -90,    0,    0,  -89,    0,   30,  -18,   34, -214,    0,
 -214,    0,  -88,   35,   39,   37,    0,  -39, -214,  -39,
    0,    0,    0,    0,   -9,    0,    0,   45,   46,   49,
  617,    0,  -41,   53,   56,   57,    0,   67,   68,  617,
  617,  367,    0,    0,    0,    0,   28,    0,    0,    0,
   50,   51,   63,   54,  476,    0,  617,  617,  617,    0,
  476,    0,   72,    7,  617,   82,   83,  617,  617,  -42,
  -42, -148,  377,    0,    0,    0,    0,  617,  617,  617,
  617,  617,  617,  617,  617,  617,  617,  617,  617,  617,
  617, -144,  617,  401,   74,  412,   93,  594,  476,  -35,
    0,    0,   94,   92,  433,   96,    0,  476,  560,  539,
  -32,  -32,  724,  724,  -19,  -19,  -42,  -42,  -42,  -32,
  -32,  102,  444,   15,  617,   15,    0,  465,  617,    0,
    0, -131,  617,  617,    0,    0,  518, -121,    0,  476,
  109,    0,  127,  617,   15,    0,    0,    0,  128,    0,
   15,    0,
};
final static short yyrindex[] = {                         0,
    0,    0,  172,    0,   55,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  115,    0,    0,  135,    0,
  135,    0,    0,    0,  136,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  122,    0,    0,    0,    0,    0,
  124,    0,    0,    0,    0,    0,    0,   20,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  497,    0,   84,    0,  122,    0,    0,
  125,    0,    0,    0,    0,    0,    0,  144,    0,  111,
  120,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  -11,    0,
    0,    0,    0,  149,    0,    0,    0,  -22,   47,  -24,
  423,  456,  293,  473,  744,  766,  152,  270,  312,  577,
  627,   58,    0,  122,    0,  122,    0,    0,    0,    0,
    0,    0,    0,  144,    0,    0,    0,  -33,    0,   -3,
    0,    0,    0,   35,  122,    0,    0,    0,    0,    0,
  122,    0,
};
final static short yygindex[] = {                         0,
    0,  188,  181,    3,    5,    0,    0,    0,  167,    0,
   13,    0,  -94,  -70,    0,    0,    0,    0,    0,    0,
   -5,  824,  214,   48,  116,    0,
};
final static int YYTABLESIZE=1050;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         80,
   27,   27,   27,  112,  109,  150,   80,  115,  149,  107,
  105,   80,  106,  112,  108,   21,   54,  109,   36,   54,
    1,   24,  107,   61,    5,   80,  112,  108,    7,   74,
   62,   32,   74,   32,   54,   60,   36,   73,    9,   74,
   73,   43,   12,   13,   14,   15,   16,   61,  113,  156,
   42,  158,   44,   10,   62,   23,   40,   84,  113,   60,
   40,   40,   40,   40,   40,   40,   40,   25,   54,   29,
  170,  113,   74,   31,   30,   38,  172,   40,   40,   40,
   40,   40,   39,   41,   77,   78,   94,   53,   79,   80,
   53,   80,   85,  169,   39,   86,   87,  118,   39,   39,
   39,   39,   39,   39,   39,   53,   88,   89,   95,   96,
   40,  117,   40,   41,   98,   63,   39,   39,   39,   39,
   45,   97,  121,  122,   37,   45,   45,  126,   45,   45,
   45,  142,  145,  147,  151,  149,  153,   41,   74,   53,
   74,  154,   37,   45,  161,   45,  165,   60,   39,  167,
   39,   60,   60,   60,   60,   60,   61,   60,   74,   74,
   61,   61,   61,   61,   61,   74,   61,  168,  171,   60,
   60,    1,   60,    5,   45,   19,   18,   14,   61,   61,
   38,   61,   82,   81,   72,   26,   28,   37,   48,   71,
    6,   19,   48,   48,   48,   48,   48,   36,   48,    0,
  120,  163,    0,   60,    0,    0,    0,    0,    0,    0,
   48,   48,   61,   48,    0,   12,   13,   14,   15,   16,
    0,    0,    0,   80,   80,   80,   80,   80,   80,    0,
   80,   80,   80,   80,   83,   80,   80,   80,   80,   80,
   80,   80,   80,    0,   48,    0,   80,   12,   13,   14,
   15,   16,   46,   54,   47,   48,   49,   50,   76,   51,
   52,   53,   54,   55,   56,   57,   58,    0,    0,    0,
   59,   12,   13,   14,   15,   16,   46,    0,   47,   48,
   49,   50,    0,   51,   52,   53,   54,   55,   56,   57,
   58,   76,    0,    0,   59,    0,   40,   40,    0,    0,
   40,   40,   40,   40,    0,    0,   49,    0,    0,    0,
   49,   49,   49,   49,   49,    0,   49,    0,    0,    0,
    0,    0,    0,   53,   53,    0,    0,    0,   49,   49,
    0,   49,    0,   51,   39,   39,   51,    0,   39,   39,
   39,   39,    0,    0,    0,    0,    0,    0,   50,    0,
    0,   51,   50,   50,   50,   50,   50,   76,   50,   76,
   45,   45,   49,    0,   45,   45,   45,   45,    0,    0,
   50,   50,    0,   50,    0,    0,    0,   76,   76,    0,
    0,    0,    0,    0,   76,   51,    0,   60,   60,    0,
    0,   60,   60,   60,   60,    0,   61,   61,    0,   61,
   61,   61,   61,   61,   50,    0,   62,    0,    0,    0,
    0,   60,    0,  109,    0,    0,    0,  127,  107,  105,
    0,  106,  112,  108,    0,    0,    0,    0,   48,   48,
    0,    0,   48,   48,   48,   48,  111,  109,  110,    0,
    0,  144,  107,  105,    0,  106,  112,  108,  109,    0,
    0,    0,  146,  107,  105,    0,  106,  112,  108,    0,
  111,    0,  110,   56,    0,    0,   56,  113,    0,  109,
    0,  111,    0,  110,  107,  105,  152,  106,  112,  108,
  109,   56,    0,    0,    0,  107,  105,    0,  106,  112,
  108,  113,  111,    0,  110,    0,   58,    0,    0,   58,
    0,  109,  113,  111,    0,  110,  107,  105,    0,  106,
  112,  108,  109,   52,   58,   56,   52,  107,  105,    0,
  106,  112,  108,  113,  111,    0,  110,    0,    0,    0,
    0,   52,    0,   44,  113,  111,  155,  110,   44,   44,
    0,   44,   44,   44,    0,    0,   49,   49,   58,    0,
   49,   49,   49,   49,  109,  113,   44,  159,   44,  107,
  105,    0,  106,  112,  108,   52,  113,    0,    0,   51,
   51,    0,    0,    0,    0,  109,  164,  111,    0,  110,
  107,  105,    0,  106,  112,  108,    0,   44,   50,   50,
    0,    0,   50,   50,   50,   50,  109,    0,  111,    0,
  110,  107,  105,    0,  106,  112,  108,    0,  113,    0,
    0,    0,    0,    0,    0,    0,    0,   57,    0,  111,
   57,  110,    0,    0,    0,    0,   61,   92,   46,  113,
   47,    0,    0,   62,    0,   57,    0,   53,   60,   55,
   56,   57,   58,    0,    0,    0,   59,    0,    0,   61,
  113,    0,    0,   99,  100,    0,   62,  101,  102,  103,
  104,   60,    0,    0,    0,    0,    0,   55,    0,   57,
   55,    0,    0,    0,    0,    0,    0,   99,  100,    0,
    0,  101,  102,  103,  104,   55,   30,    0,   99,  100,
    0,    0,  101,  102,  103,  104,   18,    0,    0,   56,
   56,    0,    0,    0,    0,   56,   56,    0,    0,   99,
  100,    0,    0,  101,  102,  103,  104,    0,    0,   55,
   99,  100,    0,    0,  101,  102,  103,  104,    0,    0,
    0,    0,   58,   58,    0,    0,    0,    0,   58,   58,
    0,   99,  100,    0,    0,  101,  102,  103,  104,   52,
   52,    0,   99,  100,    0,    0,  101,  102,  103,  104,
  109,    0,    0,    0,    0,  107,  105,    0,  106,  112,
  108,    0,    0,   44,   44,    0,    0,   44,   44,   44,
   44,    0,    0,  111,   46,  110,   46,   46,   46,    0,
    0,    0,    0,    0,   99,  100,    0,    0,  101,  102,
  103,  104,   46,   46,    0,   46,   47,    0,   47,   47,
   47,    0,    0,    0,  113,   99,    0,    0,    0,  101,
  102,  103,  104,    0,   47,   47,    0,   47,   12,   13,
   14,   15,   16,    0,    0,    0,   46,    0,    0,    0,
  101,  102,  103,  104,    0,    0,    0,    0,    0,    0,
   17,    0,    0,   57,   57,   46,    0,   47,   47,   57,
   57,    0,    0,    0,   53,    0,   55,   56,   57,   58,
    0,    0,    0,   59,   81,    0,    0,    0,   46,    0,
   47,    0,    0,   90,   91,   93,    0,   53,    0,   55,
   56,   57,   58,    0,    0,    0,   59,    0,    0,    0,
  114,    0,  116,   55,   55,    0,    0,    0,  119,   55,
   55,  119,  125,    0,    0,    0,    0,    0,    0,    0,
    0,  128,  129,  130,  131,  132,  133,  134,  135,  136,
  137,  138,  139,  140,  141,    0,  143,    0,    0,    0,
    0,  148,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  157,    0,
    0,    0,  160,    0,    0,    0,  162,  119,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  101,  102,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   46,   46,    0,    0,   46,   46,   46,   46,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   47,   47,    0,    0,   47,   47,   47,   47,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         33,
   91,   91,   91,   46,   37,   41,   40,   78,   44,   42,
   43,   45,   45,   46,   47,   11,   41,   37,   41,   44,
  261,   17,   42,   33,  276,   59,   46,   47,  263,   41,
   40,   29,   44,   31,   59,   45,   59,   41,  276,   45,
   44,   39,  257,  258,  259,  260,  261,   33,   91,  144,
   38,  146,   40,  123,   40,  276,   37,   53,   91,   45,
   41,   42,   43,   44,   45,   46,   47,   59,   93,   40,
  165,   91,   78,   40,   93,   41,  171,   41,   59,   60,
   61,   62,   44,  123,   40,   40,   59,   41,   40,  123,
   44,  125,   40,  164,   37,   40,   40,   91,   41,   42,
   43,   44,   45,   46,   47,   59,   40,   40,   59,   59,
   91,   40,   93,  123,   61,  125,   59,   60,   61,   62,
   37,   59,   41,   41,   41,   42,   43,  276,   45,   46,
   47,  276,   59,   41,   41,   44,   41,  123,  144,   93,
  146,   40,   59,   60,  276,   62,  268,   37,   91,   41,
   93,   41,   42,   43,   44,   45,   37,   47,  164,  165,
   41,   42,   43,   44,   45,  171,   47,   41,   41,   59,
   60,    0,   62,   59,   91,   41,   41,  123,   59,   60,
   59,   62,   59,   59,   41,  276,  276,  276,   37,   41,
    3,   11,   41,   42,   43,   44,   45,   31,   47,   -1,
   85,  154,   -1,   93,   -1,   -1,   -1,   -1,   -1,   -1,
   59,   60,   93,   62,   -1,  257,  258,  259,  260,  261,
   -1,   -1,   -1,  257,  258,  259,  260,  261,  262,   -1,
  264,  265,  266,  267,  276,  269,  270,  271,  272,  273,
  274,  275,  276,   -1,   93,   -1,  280,  257,  258,  259,
  260,  261,  262,  278,  264,  265,  266,  267,   45,  269,
  270,  271,  272,  273,  274,  275,  276,   -1,   -1,   -1,
  280,  257,  258,  259,  260,  261,  262,   -1,  264,  265,
  266,  267,   -1,  269,  270,  271,  272,  273,  274,  275,
  276,   78,   -1,   -1,  280,   -1,  277,  278,   -1,   -1,
  281,  282,  283,  284,   -1,   -1,   37,   -1,   -1,   -1,
   41,   42,   43,   44,   45,   -1,   47,   -1,   -1,   -1,
   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,   59,   60,
   -1,   62,   -1,   41,  277,  278,   44,   -1,  281,  282,
  283,  284,   -1,   -1,   -1,   -1,   -1,   -1,   37,   -1,
   -1,   59,   41,   42,   43,   44,   45,  144,   47,  146,
  277,  278,   93,   -1,  281,  282,  283,  284,   -1,   -1,
   59,   60,   -1,   62,   -1,   -1,   -1,  164,  165,   -1,
   -1,   -1,   -1,   -1,  171,   93,   -1,  277,  278,   -1,
   -1,  281,  282,  283,  284,   -1,  277,  278,   -1,   33,
  281,  282,  283,  284,   93,   -1,   40,   -1,   -1,   -1,
   -1,   45,   -1,   37,   -1,   -1,   -1,   41,   42,   43,
   -1,   45,   46,   47,   -1,   -1,   -1,   -1,  277,  278,
   -1,   -1,  281,  282,  283,  284,   60,   37,   62,   -1,
   -1,   41,   42,   43,   -1,   45,   46,   47,   37,   -1,
   -1,   -1,   41,   42,   43,   -1,   45,   46,   47,   -1,
   60,   -1,   62,   41,   -1,   -1,   44,   91,   -1,   37,
   -1,   60,   -1,   62,   42,   43,   44,   45,   46,   47,
   37,   59,   -1,   -1,   -1,   42,   43,   -1,   45,   46,
   47,   91,   60,   -1,   62,   -1,   41,   -1,   -1,   44,
   -1,   37,   91,   60,   -1,   62,   42,   43,   -1,   45,
   46,   47,   37,   41,   59,   93,   44,   42,   43,   -1,
   45,   46,   47,   91,   60,   -1,   62,   -1,   -1,   -1,
   -1,   59,   -1,   37,   91,   60,   93,   62,   42,   43,
   -1,   45,   46,   47,   -1,   -1,  277,  278,   93,   -1,
  281,  282,  283,  284,   37,   91,   60,   93,   62,   42,
   43,   -1,   45,   46,   47,   93,   91,   -1,   -1,  277,
  278,   -1,   -1,   -1,   -1,   37,   59,   60,   -1,   62,
   42,   43,   -1,   45,   46,   47,   -1,   91,  277,  278,
   -1,   -1,  281,  282,  283,  284,   37,   -1,   60,   -1,
   62,   42,   43,   -1,   45,   46,   47,   -1,   91,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   41,   -1,   60,
   44,   62,   -1,   -1,   -1,   -1,   33,  261,  262,   91,
  264,   -1,   -1,   40,   -1,   59,   -1,  271,   45,  273,
  274,  275,  276,   -1,   -1,   -1,  280,   -1,   -1,   33,
   91,   -1,   -1,  277,  278,   -1,   40,  281,  282,  283,
  284,   45,   -1,   -1,   -1,   -1,   -1,   41,   -1,   93,
   44,   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,   -1,
   -1,  281,  282,  283,  284,   59,   93,   -1,  277,  278,
   -1,   -1,  281,  282,  283,  284,  125,   -1,   -1,  277,
  278,   -1,   -1,   -1,   -1,  283,  284,   -1,   -1,  277,
  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,   93,
  277,  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,
   -1,   -1,  277,  278,   -1,   -1,   -1,   -1,  283,  284,
   -1,  277,  278,   -1,   -1,  281,  282,  283,  284,  277,
  278,   -1,  277,  278,   -1,   -1,  281,  282,  283,  284,
   37,   -1,   -1,   -1,   -1,   42,   43,   -1,   45,   46,
   47,   -1,   -1,  277,  278,   -1,   -1,  281,  282,  283,
  284,   -1,   -1,   60,   41,   62,   43,   44,   45,   -1,
   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,  281,  282,
  283,  284,   59,   60,   -1,   62,   41,   -1,   43,   44,
   45,   -1,   -1,   -1,   91,  277,   -1,   -1,   -1,  281,
  282,  283,  284,   -1,   59,   60,   -1,   62,  257,  258,
  259,  260,  261,   -1,   -1,   -1,   93,   -1,   -1,   -1,
  281,  282,  283,  284,   -1,   -1,   -1,   -1,   -1,   -1,
  279,   -1,   -1,  277,  278,  262,   -1,  264,   93,  283,
  284,   -1,   -1,   -1,  271,   -1,  273,  274,  275,  276,
   -1,   -1,   -1,  280,   51,   -1,   -1,   -1,  262,   -1,
  264,   -1,   -1,   60,   61,   62,   -1,  271,   -1,  273,
  274,  275,  276,   -1,   -1,   -1,  280,   -1,   -1,   -1,
   77,   -1,   79,  277,  278,   -1,   -1,   -1,   85,  283,
  284,   88,   89,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   98,   99,  100,  101,  102,  103,  104,  105,  106,
  107,  108,  109,  110,  111,   -1,  113,   -1,   -1,   -1,
   -1,  118,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  145,   -1,
   -1,   -1,  149,   -1,   -1,   -1,  153,  154,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  281,  282,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  277,  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  277,  278,   -1,   -1,  281,  282,  283,  284,
};
}
final static short YYFINAL=2;
final static short YYMAXTOKEN=286;
final static String yyname[] = {
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,"'!'",null,null,null,"'%'",null,null,"'('","')'","'*'","'+'",
"','","'-'","'.'","'/'",null,null,null,null,null,null,null,null,null,null,null,
"';'","'<'","'='","'>'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,"'['",null,"']'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,"'{'",null,"'}'",null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,"VOID","BOOL","INT","STRING",
"CLASS","NULL","EXTENDS","THIS","WHILE","FOR","IF","ELSE","RETURN","BREAK",
"NEW","PRINT","READ_INTEGER","READ_LINE","LITERAL","IDENTIFIER","AND","OR",
"STATIC","INSTANCEOF","LESS_EQUAL","GREATER_EQUAL","EQUAL","NOT_EQUAL","UMINUS",
"EMPTY",
};
final static String yyrule[] = {
"$accept : Program",
"Program : ClassList",
"ClassList : ClassList ClassDef",
"ClassList : ClassDef",
"VariableDef : Variable ';'",
"Variable : Type IDENTIFIER",
"Type : INT",
"Type : VOID",
"Type : BOOL",
"Type : STRING",
"Type : CLASS IDENTIFIER",
"Type : Type '[' ']'",
"ClassDef : CLASS IDENTIFIER ExtendsClause '{' FieldList '}'",
"ExtendsClause : EXTENDS IDENTIFIER",
"ExtendsClause :",
"FieldList : FieldList VariableDef",
"FieldList : FieldList FunctionDef",
"FieldList :",
"Formals : VariableList",
"Formals :",
"VariableList : VariableList ',' Variable",
"VariableList : Variable",
"FunctionDef : STATIC Type IDENTIFIER '(' Formals ')' StmtBlock",
"FunctionDef : Type IDENTIFIER '(' Formals ')' StmtBlock",
"StmtBlock : '{' StmtList '}'",
"StmtList : StmtList Stmt",
"StmtList :",
"Stmt : VariableDef",
"Stmt : SimpleStmt ';'",
"Stmt : IfStmt",
"Stmt : WhileStmt",
"Stmt : ForStmt",
"Stmt : ReturnStmt ';'",
"Stmt : PrintStmt ';'",
"Stmt : BreakStmt ';'",
"Stmt : StmtBlock",
"SimpleStmt : LValue '=' Expr",
"SimpleStmt : Call",
"SimpleStmt :",
"LValue : Expr '.' IDENTIFIER",
"LValue : IDENTIFIER",
"LValue : Expr '[' Expr ']'",
"Call : Expr '.' IDENTIFIER '(' Actuals ')'",
"Call : IDENTIFIER '(' Actuals ')'",
"Expr : LValue",
"Expr : Call",
"Expr : Expr '+' Expr",
"Expr : Expr '-' Expr",
"Expr : Expr '*' Expr",
"Expr : Expr '/' Expr",
"Expr : Expr '%' Expr",
"Expr : Expr EQUAL Expr",
"Expr : Expr NOT_EQUAL Expr",
"Expr : Expr AND Expr",
"Expr : Expr OR Expr",
"Expr : Expr '<' Expr",
"Expr : Expr LESS_EQUAL Expr",
"Expr : Expr '>' Expr",
"Expr : Expr GREATER_EQUAL Expr",
"Expr : '(' Expr ')'",
"Expr : '-' Expr",
"Expr : '!' Expr",
"Expr : READ_INTEGER '(' ')'",
"Expr : READ_LINE '(' ')'",
"Expr : NULL",
"Expr : LITERAL",
"Expr : THIS",
"Expr : INSTANCEOF '(' Expr ',' IDENTIFIER ')'",
"Expr : '(' CLASS IDENTIFIER ')' Expr",
"Expr : NEW IDENTIFIER '(' ')'",
"Expr : NEW Type '[' Expr ']'",
"Actuals : ExprList",
"Actuals :",
"ExprList : ExprList ',' Expr",
"ExprList : Expr",
"WhileStmt : WHILE '(' Expr ')' Stmt",
"ForStmt : FOR '(' SimpleStmt ';' Expr ';' SimpleStmt ')' Stmt",
"BreakStmt : BREAK",
"IfStmt : IF '(' Expr ')' Stmt ElseClause",
"ElseClause : ELSE Stmt",
"ElseClause :",
"ReturnStmt : RETURN Expr",
"ReturnStmt : RETURN",
"PrintStmt : PRINT '(' ExprList ')'",
};

//#line 409 "Parser.y"
    
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
//#line 585 "Parser.java"
//###############################################################
// method: yylexdebug : check lexer state
//###############################################################
void yylexdebug(int state,int ch)
{
String s=null;
  if (ch < 0) ch=0;
  if (ch <= YYMAXTOKEN) //check index bounds
     s = yyname[ch];    //now get it
  if (s==null)
    s = "illegal-symbol";
  debug("state "+state+", reading "+ch+" ("+s+")");
}





//The following are now global, to aid in error reporting
int yyn;       //next next thing to do
int yym;       //
int yystate;   //current parsing state from state table
String yys;    //current token string


//###############################################################
// method: yyparse : parse input and execute indicated items
//###############################################################
int yyparse()
{
boolean doaction;
  init_stacks();
  yynerrs = 0;
  yyerrflag = 0;
  yychar = -1;          //impossible char forces a read
  yystate=0;            //initial state
  state_push(yystate);  //save it
  while (true) //until parsing is done, either correctly, or w/error
    {
    doaction=true;
    //if (yydebug) debug("loop"); 
    //#### NEXT ACTION (from reduction table)
    for (yyn=yydefred[yystate];yyn==0;yyn=yydefred[yystate])
      {
      //if (yydebug) debug("yyn:"+yyn+"  state:"+yystate+"  yychar:"+yychar);
      if (yychar < 0)      //we want a char?
        {
        yychar = yylex();  //get next token
        //if (yydebug) debug(" next yychar:"+yychar);
        //#### ERROR CHECK ####
        //if (yychar < 0)    //it it didn't work/error
        //  {
        //  yychar = 0;      //change it to default string (no -1!)
          //if (yydebug)
          //  yylexdebug(yystate,yychar);
        //  }
        }//yychar<0
      yyn = yysindex[yystate];  //get amount to shift by (shift index)
      if ((yyn != 0) && (yyn += yychar) >= 0 &&
          yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
        {
        //if (yydebug)
          //debug("state "+yystate+", shifting to state "+yytable[yyn]);
        //#### NEXT STATE ####
        yystate = yytable[yyn];//we are in a new state
        state_push(yystate);   //save it
        val_push(yylval);      //push our lval as the input for next rule
        yychar = -1;           //since we have 'eaten' a token, say we need another
        if (yyerrflag > 0)     //have we recovered an error?
           --yyerrflag;        //give ourselves credit
        doaction=false;        //but don't process yet
        break;   //quit the yyn=0 loop
        }

    yyn = yyrindex[yystate];  //reduce
    if ((yyn !=0 ) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
      {   //we reduced!
      //if (yydebug) debug("reduce");
      yyn = yytable[yyn];
      doaction=true; //get ready to execute
      break;         //drop down to actions
      }
    else //ERROR RECOVERY
      {
      if (yyerrflag==0)
        {
        yyerror("syntax error");
        yynerrs++;
        }
      if (yyerrflag < 3) //low error count?
        {
        yyerrflag = 3;
        while (true)   //do until break
          {
          if (stateptr<0 || valptr<0)   //check for under & overflow here
            {
            return 1;
            }
          yyn = yysindex[state_peek(0)];
          if ((yyn != 0) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
            //if (yydebug)
              //debug("state "+state_peek(0)+", error recovery shifting to state "+yytable[yyn]+" ");
            yystate = yytable[yyn];
            state_push(yystate);
            val_push(yylval);
            doaction=false;
            break;
            }
          else
            {
            //if (yydebug)
              //debug("error recovery discarding state "+state_peek(0)+" ");
            if (stateptr<0 || valptr<0)   //check for under & overflow here
              {
              return 1;
              }
            state_pop();
            val_pop();
            }
          }
        }
      else            //discard this token
        {
        if (yychar == 0)
          return 1; //yyabort
        //if (yydebug)
          //{
          //yys = null;
          //if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
          //if (yys == null) yys = "illegal-symbol";
          //debug("state "+yystate+", error recovery discards token "+yychar+" ("+yys+")");
          //}
        yychar = -1;  //read another
        }
      }//end error recovery
    }//yyn=0 loop
    if (!doaction)   //any reason not to proceed?
      continue;      //skip action
    yym = yylen[yyn];          //get count of terminals on rhs
    //if (yydebug)
      //debug("state "+yystate+", reducing "+yym+" by rule "+yyn+" ("+yyrule[yyn]+")");
    if (yym>0)                 //if count of rhs not 'nil'
      yyval = val_peek(yym-1); //get current semantic value
    if (reduceListener == null || reduceListener.onReduce(yyrule[yyn])) // if intercepted!
      switch(yyn)
      {
//########## USER-SUPPLIED ACTIONS ##########
case 1:
//#line 52 "Parser.y"
{
						tree = new Tree.TopLevel(val_peek(0).clist, val_peek(0).loc);
					}
break;
case 2:
//#line 58 "Parser.y"
{
						yyval.clist.add(val_peek(0).cdef);
					}
break;
case 3:
//#line 62 "Parser.y"
{
                		yyval.clist = new ArrayList<Tree.ClassDef>();
                		yyval.clist.add(val_peek(0).cdef);
                	}
break;
case 5:
//#line 72 "Parser.y"
{
						yyval.vdef = new Tree.VarDef(val_peek(0).ident, val_peek(1).type, val_peek(0).loc);
					}
break;
case 6:
//#line 78 "Parser.y"
{
						yyval.type = new Tree.TypeIdent(Tree.INT, val_peek(0).loc);
					}
break;
case 7:
//#line 82 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.VOID, val_peek(0).loc);
                	}
break;
case 8:
//#line 86 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.BOOL, val_peek(0).loc);
                	}
break;
case 9:
//#line 90 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.STRING, val_peek(0).loc);
                	}
break;
case 10:
//#line 94 "Parser.y"
{
                		yyval.type = new Tree.TypeClass(val_peek(0).ident, val_peek(1).loc);
                	}
break;
case 11:
//#line 98 "Parser.y"
{
                		yyval.type = new Tree.TypeArray(val_peek(2).type, val_peek(2).loc);
                	}
break;
case 12:
//#line 104 "Parser.y"
{
						yyval.cdef = new Tree.ClassDef(val_peek(4).ident, val_peek(3).ident, val_peek(1).flist, val_peek(5).loc);
					}
break;
case 13:
//#line 110 "Parser.y"
{
						yyval.ident = val_peek(0).ident;
					}
break;
case 14:
//#line 114 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 15:
//#line 120 "Parser.y"
{
						yyval.flist.add(val_peek(0).vdef);
					}
break;
case 16:
//#line 124 "Parser.y"
{
						yyval.flist.add(val_peek(0).fdef);
					}
break;
case 17:
//#line 128 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.flist = new ArrayList<Tree>();
                	}
break;
case 19:
//#line 136 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.vlist = new ArrayList<Tree.VarDef>(); 
                	}
break;
case 20:
//#line 143 "Parser.y"
{
						yyval.vlist.add(val_peek(0).vdef);
					}
break;
case 21:
//#line 147 "Parser.y"
{
                		yyval.vlist = new ArrayList<Tree.VarDef>();
						yyval.vlist.add(val_peek(0).vdef);
                	}
break;
case 22:
//#line 154 "Parser.y"
{
						yyval.fdef = new MethodDef(true, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 23:
//#line 158 "Parser.y"
{
						yyval.fdef = new MethodDef(false, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 24:
//#line 164 "Parser.y"
{
						yyval.stmt = new Block(val_peek(1).slist, val_peek(2).loc);
					}
break;
case 25:
//#line 170 "Parser.y"
{
						yyval.slist.add(val_peek(0).stmt);
					}
break;
case 26:
//#line 174 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.slist = new ArrayList<Tree>();
                	}
break;
case 27:
//#line 181 "Parser.y"
{
						yyval.stmt = val_peek(0).vdef;
					}
break;
case 36:
//#line 196 "Parser.y"
{
						yyval.stmt = new Tree.Assign(val_peek(2).lvalue, val_peek(0).expr, val_peek(2).loc);
					}
break;
case 37:
//#line 200 "Parser.y"
{
                		yyval.stmt = val_peek(0).expr;
                	}
break;
case 38:
//#line 204 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 39:
//#line 210 "Parser.y"
{
						yyval.lvalue = new Ident(val_peek(2).expr, val_peek(0).ident, val_peek(2).loc);
					}
break;
case 40:
//#line 214 "Parser.y"
{
						yyval.lvalue = new Ident(null, val_peek(0).ident, val_peek(0).loc);
					}
break;
case 41:
//#line 218 "Parser.y"
{
                		yyval.lvalue = new Indexed(val_peek(3).expr, val_peek(1).expr, val_peek(3).loc);
                	}
break;
case 42:
//#line 224 "Parser.y"
{
						yyval.expr = new CallExpr(val_peek(5).expr, val_peek(3).ident, val_peek(1).elist, val_peek(5).loc);
					}
break;
case 43:
//#line 228 "Parser.y"
{
						yyval.expr = new CallExpr(null, val_peek(3).ident, val_peek(1).elist, val_peek(3).loc);
					}
break;
case 44:
//#line 234 "Parser.y"
{
						yyval.expr = val_peek(0).lvalue;
					}
break;
case 46:
//#line 239 "Parser.y"
{
                		yyval.expr = new Binary(Tree.PLUS,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 47:
//#line 243 "Parser.y"
{
                		yyval.expr = new Binary(Tree.MINUS,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 48:
//#line 247 "Parser.y"
{
                		yyval.expr = new Binary(Tree.MUL,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 49:
//#line 251 "Parser.y"
{
                		yyval.expr =new Binary(Tree.DIV,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 50:
//#line 255 "Parser.y"
{
                		yyval.expr = new Binary(Tree.MOD,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 51:
//#line 259 "Parser.y"
{
                		yyval.expr = new Binary(Tree.EQ,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 52:
//#line 263 "Parser.y"
{
                		yyval.expr = new Binary(Tree.NE,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 53:
//#line 267 "Parser.y"
{
                		yyval.expr = new Binary(Tree.AND,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 54:
//#line 271 "Parser.y"
{
                		yyval.expr = new Binary(Tree.OR,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 55:
//#line 275 "Parser.y"
{
                		yyval.expr = new Binary(Tree.LT,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 56:
//#line 279 "Parser.y"
{
                		yyval.expr = new Binary(Tree.LE,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 57:
//#line 283 "Parser.y"
{
                		yyval.expr = new Binary(Tree.GT,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 58:
//#line 287 "Parser.y"
{
                		yyval.expr = new Binary(Tree.GE,val_peek(2).expr, val_peek(0).expr, val_peek(2).loc);
                	}
break;
case 59:
//#line 292 "Parser.y"
{
                		yyval = val_peek(1);
                	}
break;
case 60:
//#line 296 "Parser.y"
{
                		yyval.expr = new Unary(Tree.NEG,val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 61:
//#line 300 "Parser.y"
{
                		yyval.expr = new Unary(Tree.NOT,val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 62:
//#line 304 "Parser.y"
{
                		yyval.expr = new ReadIntExpr(val_peek(2).loc);
                	}
break;
case 63:
//#line 308 "Parser.y"
{
                		yyval.expr = new ReadLineExpr(val_peek(2).loc);
                	}
break;
case 64:
//#line 312 "Parser.y"
{
               			yyval.expr = new Null(val_peek(0).loc);
               		}
break;
case 65:
//#line 316 "Parser.y"
{
                      	yyval.expr = new Literal(val_peek(0).typeTag, val_peek(0).literal, val_peek(0).loc); 
               		}
break;
case 66:
//#line 320 "Parser.y"
{
                		yyval.expr = new ThisExpr(val_peek(0).loc);
                	}
break;
case 67:
//#line 324 "Parser.y"
{
               			yyval.expr = new TypeTest(val_peek(3).expr, val_peek(1).ident, val_peek(5).loc);
               		}
break;
case 68:
//#line 328 "Parser.y"
{
               			yyval.expr = new TypeCast(val_peek(2).ident, val_peek(0).expr,val_peek(4).loc);
               		}
break;
case 69:
//#line 332 "Parser.y"
{
                		yyval.expr = new NewClass(val_peek(2).ident, val_peek(3).loc);
                	}
break;
case 70:
//#line 336 "Parser.y"
{
                		yyval.expr = new NewArray(val_peek(3).type, val_peek(1).expr, val_peek(4).loc);
                	}
break;
case 72:
//#line 342 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.elist = new ArrayList<Tree.Expr>();
                	}
break;
case 73:
//#line 349 "Parser.y"
{
						yyval.elist.add(val_peek(0).expr);
					}
break;
case 74:
//#line 353 "Parser.y"
{
                		yyval.elist = new ArrayList<Tree.Expr>();
						yyval.elist.add(val_peek(0).expr);
                	}
break;
case 75:
//#line 360 "Parser.y"
{
						yyval.stmt = new Tree.WhileLoop(val_peek(2).expr, val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 76:
//#line 366 "Parser.y"
{
						yyval.stmt = new Tree.ForLoop(val_peek(6).stmt, val_peek(4).expr, val_peek(2).stmt, val_peek(0).stmt, val_peek(8).loc);
					}
break;
case 77:
//#line 372 "Parser.y"
{
						yyval.stmt = new Tree.Break(val_peek(0).loc);
					}
break;
case 78:
//#line 378 "Parser.y"
{
						yyval.stmt = new Tree.If(val_peek(3).expr, val_peek(1).stmt, val_peek(0).stmt, val_peek(5).loc);
					}
break;
case 79:
//#line 384 "Parser.y"
{
						yyval.stmt = val_peek(0).stmt;
					}
break;
case 80:
//#line 388 "Parser.y"
{
						yyval = new SemValue();
					}
break;
case 81:
//#line 394 "Parser.y"
{
						yyval.stmt = new Tree.Return(val_peek(0).expr, val_peek(1).loc);
					}
break;
case 82:
//#line 398 "Parser.y"
{
                		yyval.stmt = new Tree.Return(null, val_peek(0).loc);
                	}
break;
case 83:
//#line 404 "Parser.y"
{
						yyval.stmt = new Tree.Print(val_peek(1).elist, val_peek(3).loc);
					}
break;
//#line 1164 "Parser.java"
//########## END OF USER-SUPPLIED ACTIONS ##########
    }//switch
    //#### Now let's reduce... ####
    //if (yydebug) debug("reduce");
    state_drop(yym);             //we just reduced yylen states
    yystate = state_peek(0);     //get new state
    val_drop(yym);               //corresponding value drop
    yym = yylhs[yyn];            //select next TERMINAL(on lhs)
    if (yystate == 0 && yym == 0)//done? 'rest' state and at first TERMINAL
      {
      //if (yydebug) debug("After reduction, shifting from state 0 to state "+YYFINAL+"");
      yystate = YYFINAL;         //explicitly say we're done
      state_push(YYFINAL);       //and save it
      val_push(yyval);           //also save the semantic value of parsing
      if (yychar < 0)            //we want another character?
        {
        yychar = yylex();        //get next character
        //if (yychar<0) yychar=0;  //clean, if necessary
        //if (yydebug)
          //yylexdebug(yystate,yychar);
        }
      if (yychar == 0)          //Good exit (if lex returns 0 ;-)
         break;                 //quit the loop--all DONE
      }//if yystate
    else                        //else not done yet
      {                         //get next state and push, for next yydefred[]
      yyn = yygindex[yym];      //find out where to go
      if ((yyn != 0) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn]; //get new state
      else
        yystate = yydgoto[yym]; //else go to new defred
      //if (yydebug) debug("after reduction, shifting from state "+state_peek(0)+" to state "+yystate+"");
      state_push(yystate);     //going again, so push state & val...
      val_push(yyval);         //for next action
      }
    }//main loop
  return 0;//yyaccept!!
}
//## end of method parse() ######################################



//## run() --- for Thread #######################################
//## The -Jnorun option was used ##
//## end of method run() ########################################



//## Constructors ###############################################
//## The -Jnoconstruct option was used ##
//###############################################################



}
//################### END OF CLASS ##############################
