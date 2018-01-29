package decaf.dataflow;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import decaf.machdesc.Asm;
import decaf.machdesc.Register;
import decaf.tac.Label;
import decaf.tac.Tac;
import decaf.tac.Temp;

public class BasicBlock {
	public int bbNum;

	public enum EndKind {
		BY_BRANCH, BY_BEQZ, BY_BNEZ, BY_RETURN
	}

	public EndKind endKind;

	public int inDegree;

	public Tac tacList;

	public Label label;

	public Temp var;

	public Register varReg;

	public int[] next;

	public boolean cancelled;

	public boolean mark;

	public Set<Temp> def;

	public Set<Temp> liveUse;

	public Set<Temp> liveIn;

	public Set<Temp> liveOut;

	public Set<Temp> saves;

	private List<Asm> asms;

	public BasicBlock() {
		def = new TreeSet<Temp>(Temp.ID_COMPARATOR);
		liveUse = new TreeSet<Temp>(Temp.ID_COMPARATOR);
		liveIn = new TreeSet<Temp>(Temp.ID_COMPARATOR);
		liveOut = new TreeSet<Temp>(Temp.ID_COMPARATOR);
		next = new int[2];
		asms = new ArrayList<Asm>();
	}

	public void computeDefAndLiveUse() {
		// TODO
		if((var != null) && (!def.contains(var)))
			liveUse.add(var);
		Tac tac = tacList;
		for(;tac != null;tac=tac.next){
			switch(tac.opc){
			case ADD:
			case SUB:
			case MUL:
			case DIV:
			case MOD:
			case LAND:
			case LOR:
			case GTR:
			case GEQ:
			case EQU:
			case NEQ:
			case LEQ:
			case LES:
			case LOAD:
				if(!def.contains(tac.op1)) 
					liveUse.add(tac.op1);
				if(!def.contains(tac.op2)) 
					liveUse.add(tac.op2);
				if(tac.op0!=null)
					def.add(tac.op0);
				break;
			case NEG:
			case LNOT:
			case ASSIGN:			
				if(!def.contains(tac.op1)) 
					liveUse.add(tac.op1);
				def.add(tac.op0);
				break;
			case LOAD_VTBL:			
			case LOAD_STR_CONST:
			case LOAD_IMM4:	
				if(tac.op0!=null)
				def.add(tac.op0);
				break;
			case RETURN:
			case BEQZ:
				if (!def.contains(tac.op0)) 
					liveUse.add(tac.op0);
				break;
			case BNEZ:
			case PARM:
				if(!def.contains(tac.op0)) 
					liveUse.add(tac.op0);
				break;
			case STORE:
				if(!def.contains(tac.op0)) 
					liveUse.add(tac.op0);
				if(!def.contains(tac.op1)) 
					liveUse.add(tac.op1);
				break;	
			case INDIRECT_CALL:
				if(!def.contains(tac.op1)) 
					liveUse.add(tac.op1);
				if(tac.op0 != null)	
					def.add(tac.op0);
				break;
			case DIRECT_CALL:
				if(tac.op0 != null)	
					def.add(tac.op0);
				break;
			case BRANCH:
				break;
			default:
				break;
			}
		}
	}

	public void analyzeLiveness() {
		// TODO:
		if(tacList == null) 
			return;
		Tac tac = tacList;
		while(tac.next != null) 
			tac = tac.next;
		tac.liveOut = new TreeSet<Temp>(Temp.ID_COMPARATOR);
		tac.liveOut.addAll(liveOut);
		if (var != null) 
			tac.liveOut.add(var);	
		while(tac.prev != null){
			Set<Temp> tempSet = new TreeSet<Temp>(Temp.ID_COMPARATOR);
			tempSet.addAll(tac.liveOut);
			switch(tac.opc){
			case ADD:
			case SUB:
			case MUL:
			case DIV:
			case MOD:
			case LAND:
			case LOR:
			case GTR:
			case GEQ:
			case EQU:
			case NEQ:
			case LEQ:
			case LES:
			case LOAD:
				tempSet.remove(tac.op0);
				tempSet.add(tac.op1);
				tempSet.add(tac.op2);					
				break;
			case NEG:
				tempSet.remove(tac.op0);
				tempSet.add(tac.op1);
				break;
			case LNOT:
			case ASSIGN:	
				tempSet.remove(tac.op0);
				tempSet.add(tac.op1);					
				break;
			case LOAD_VTBL:			
			case LOAD_STR_CONST:
				tempSet.remove(tac.op0);
				break;
			case LOAD_IMM4:	
			case RETURN:
			case BEQZ:
				if(tac.op0!=null)
					tempSet.add(tac.op0);
				break;
			case BNEZ:
			case PARM:
				tempSet.add(tac.op0);
				break;
			case STORE:
				tempSet.add(tac.op0);
				tempSet.add(tac.op1);
				break;	
			case INDIRECT_CALL:
				if(tac.op0 != null)	
					tempSet.remove(tac.op0);
				tempSet.add(tac.op1);					
				break;
			case DIRECT_CALL:
				if(tac.op0 != null)	
					tempSet.remove(tac.op0);
				break;
			default:
				break;
			}
			tac = tac.prev;
			tac.liveOut = new TreeSet<Temp>(Temp.ID_COMPARATOR);
			tac.liveOut = tempSet;
		}
	}

	public void printTo(PrintWriter pw) {
		pw.println("BASIC BLOCK " + bbNum + " : ");
		for (Tac t = tacList; t != null; t = t.next) {
			pw.println("    " + t);
		}
		switch (endKind) {
		case BY_BRANCH:
			pw.println("END BY BRANCH, goto " + next[0]);
			break;
		case BY_BEQZ:
			pw.println("END BY BEQZ, if " + var.name + " = ");
			pw.println("    0 : goto " + next[0] + "; 1 : goto " + next[1]);
			break;
		case BY_BNEZ:
			pw.println("END BY BGTZ, if " + var.name + " = ");
			pw.println("    1 : goto " + next[0] + "; 0 : goto " + next[1]);
			break;
		case BY_RETURN:
			if (var != null) {
				pw.println("END BY RETURN, result = " + var.name);
			} else {
				pw.println("END BY RETURN, void result");
			}
			break;
		}
	}

	public void printLivenessTo(PrintWriter pw) {
		pw.println("BASIC BLOCK " + bbNum + " : ");
		pw.println("  Def     = " + toString(def));
		pw.println("  liveUse = " + toString(liveUse));
		pw.println("  liveIn  = " + toString(liveIn));
		pw.println("  liveOut = " + toString(liveOut));

		for (Tac t = tacList; t != null; t = t.next) {
			pw.println("    " + t + " " + toString(t.liveOut));
		}

		switch (endKind) {
		case BY_BRANCH:
			pw.println("END BY BRANCH, goto " + next[0]);
			break;
		case BY_BEQZ:
			pw.println("END BY BEQZ, if " + var.name + " = ");
			pw.println("    0 : goto " + next[0] + "; 1 : goto " + next[1]);
			break;
		case BY_BNEZ:
			pw.println("END BY BGTZ, if " + var.name + " = ");
			pw.println("    1 : goto " + next[0] + "; 0 : goto " + next[1]);
			break;
		case BY_RETURN:
			if (var != null) {
				pw.println("END BY RETURN, result = " + var.name);
			} else {
				pw.println("END BY RETURN, void result");
			}
			break;
		}
	}

	public String toString(Set<Temp> set) {
		StringBuilder sb = new StringBuilder("[ ");
		for (Temp t : set) {
			sb.append(t.name + " ");
		}
		sb.append(']');
		return sb.toString();
	}

	public void insertBefore(Tac insert, Tac base) {
		if (base == tacList) {
			tacList = insert;
		} else {
			base.prev.next = insert;
		}
		insert.prev = base.prev;
		base.prev = insert;
		insert.next = base;
	}

	public void insertAfter(Tac insert, Tac base) {
		if (tacList == null) {
			tacList = insert;
			insert.next = null;
			return;
		}
		if (base.next != null) {
			base.next.prev = insert;
		}
		insert.prev = base;
		insert.next = base.next;
		base.next = insert;
	}

	public void appendAsm(Asm asm) {
		asms.add(asm);
	}

	public List<Asm> getAsms() {
		return asms;
	}
}
