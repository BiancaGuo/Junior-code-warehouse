// 注: 代码中的 TODO 等注释只是一个提示。只在这些地方添加/修改代码就可以完成本次作业，
// 你也可以根据自己的需要在其他位置修改/添加代码。我们鼓励不同的实现方式。

package decaf.translate;

import java.util.Stack;

import decaf.tree.Tree;
import decaf.backend.OffsetCounter;
import decaf.machdesc.Intrinsic;
import decaf.symbol.Variable;
import decaf.tac.Label;
import decaf.tac.Temp;
import decaf.type.BaseType;

public class TransPass2 extends Tree.Visitor {

	private Translater tr;

	private Temp currentThis;

	private Stack<Label> loopExits;

	public TransPass2(Translater tr) {
		this.tr = tr;
		loopExits = new Stack<Label>();
	}

	@Override
	public void visitClassDef(Tree.ClassDef classDef) {
		for (Tree f : classDef.fields) {
			f.accept(this);
		}
	}

	@Override
	public void visitMethodDef(Tree.MethodDef funcDefn) {
		if (!funcDefn.statik) {
			currentThis = ((Variable) funcDefn.symbol.getAssociatedScope()
					.lookup("this")).getTemp();
		}
		tr.beginFunc(funcDefn.symbol);
		funcDefn.body.accept(this);
		tr.endFunc();
		currentThis = null;
	}

	@Override
	public void visitTopLevel(Tree.TopLevel program) {
		for (Tree.ClassDef cd : program.classes) {
			cd.accept(this);
		}
	}

	@Override
	public void visitVarDef(Tree.VarDef varDef) {
		if (varDef.symbol.isLocalVar()) {
			Temp t = Temp.createTempI4();
			t.sym = varDef.symbol;
			varDef.symbol.setTemp(t);
		}
	}

	@Override
	public void visitBinary(Tree.Binary expr) {
		expr.left.accept(this);
		expr.right.accept(this);
		switch (expr.tag) {
		case Tree.PLUS:
			expr.val = tr.genAdd(expr.left.val, expr.right.val);
			break;
		case Tree.MINUS:
			expr.val = tr.genSub(expr.left.val, expr.right.val);
			break;
		case Tree.MUL:
			expr.val = tr.genMul(expr.left.val, expr.right.val);
			break;
		case Tree.DIV:
			expr.val = tr.genDiv(expr.left.val, expr.right.val);
			break;
		case Tree.MOD:
			expr.val = tr.genMod(expr.left.val, expr.right.val);
			break;
		// NOTE: Decaf中的逻辑运算符&&和||不短路。如果要短路，对Tree.AND和Tree.OR的处理会复杂一些。
		case Tree.AND:
			expr.val = tr.genLAnd(expr.left.val, expr.right.val);
			break;
		case Tree.OR:
			expr.val = tr.genLOr(expr.left.val, expr.right.val);
			break;
		// NOTE-END
		case Tree.LT:
			expr.val = tr.genLes(expr.left.val, expr.right.val);
			break;
		case Tree.LE:
			expr.val = tr.genLeq(expr.left.val, expr.right.val);
			break;
		case Tree.GT:
			expr.val = tr.genGtr(expr.left.val, expr.right.val);
			break;
		case Tree.GE:
			expr.val = tr.genGeq(expr.left.val, expr.right.val);
			break;
		case Tree.EQ:
			if(!expr.left.type.equal(BaseType.STRING)&&!expr.right.type.equal(BaseType.STRING)) expr.val=tr.genEqu(expr.left.val, expr.right.val);
			else {
				tr.genParm(expr.left.val);tr.genParm(expr.right.val);
				expr.val=tr.genDirectCall(Intrinsic.STRING_EQUAL.label, BaseType.BOOL);
			}
			break;
		case Tree.NE:
			// TODO
			// 注意 == 和 != 的操作数可以是字符串
			if(!expr.left.type.equal(BaseType.STRING)&&!expr.right.type.equal(BaseType.STRING)) expr.val=tr.genNeq(expr.left.val, expr.right.val);
			else {
				tr.genParm(expr.left.val);tr.genParm(expr.right.val);
				expr.val=tr.genLNot(tr.genDirectCall(Intrinsic.STRING_EQUAL.label, BaseType.BOOL));
			}

			break;
		}
	}

	@Override
	public void visitAssign(Tree.Assign assign) {
		assign.left.accept(this);
		assign.expr.accept(this);
		switch (assign.left.lvKind) {
		case ARRAY_ELEMENT:
			Tree.Indexed ind=(Tree.Indexed) assign.left;
			Temp word_sizeTemp=tr.genLoadImm4(OffsetCounter.WORD_SIZE);
			Temp temp=tr.genMul(ind.index.val, word_sizeTemp);
			Temp temp2=tr.genAdd(ind.array.val, temp);
			tr.genStore(assign.expr.val, temp2, 0);
			break;
		case MEMBER_VAR:
			Tree.Ident ident=(Tree.Ident) assign.left;
			tr.genStore(assign.expr.val, ident.owner.val, ident.symbol.getOffset());
			break;
		case PARAM_VAR:
			
		case LOCAL_VAR:
			Tree.Ident ident1=(Tree.Ident) assign.left;
			tr.genAssign(ident1.symbol.getTemp(), assign.expr.val);
			break;
		// TODO: 为上面每个case添加代码
			
		}
	}

	@Override
	public void visitLiteral(Tree.Literal literal) {
		switch (literal.typeTag) {
		case Tree.INT:
			literal.val = tr.genLoadImm4(((Integer)literal.value).intValue());
			break;
		case Tree.BOOL:
			literal.val = tr.genLoadImm4((Boolean)(literal.value) ? 1 : 0);
			break;
		default:
			literal.val = tr.genLoadStrConst((String)literal.value);
		}
	}

	@Override
	public void visitExec(Tree.Exec exec) {
		exec.expr.accept(this);
	}

	@Override
	public void visitUnary(Tree.Unary expr) {
		expr.expr.accept(this);
		switch (expr.tag){
		case Tree.NEG:
			expr.val = tr.genNeg(expr.expr.val);
			break;
		default:
			expr.val = tr.genLNot(expr.expr.val);
		}
	}

	@Override
	public void visitNull(Tree.Null nullExpr) {
		nullExpr.val = tr.genLoadImm4(0);
	}

	@Override
	public void visitBlock(Tree.Block block) {
		for (Tree s : block.block) {
			s.accept(this);
		}
	}

	@Override
	public void visitThisExpr(Tree.ThisExpr thisExpr) {
		thisExpr.val = currentThis;
	}

	@Override
	public void visitReadIntExpr(Tree.ReadIntExpr readIntExpr) {
		readIntExpr.val = tr.genIntrinsicCall(Intrinsic.READ_INT);
	}

	@Override
	public void visitReadLineExpr(Tree.ReadLineExpr readStringExpr) {
		readStringExpr.val = tr.genIntrinsicCall(Intrinsic.READ_LINE);
	}

	@Override
	public void visitReturn(Tree.Return returnStmt) {
		if (returnStmt.expr != null) {
			returnStmt.expr.accept(this);
			tr.genReturn(returnStmt.expr.val);
		} else {
			tr.genReturn(null);
		}

	}

	@Override
	public void visitPrint(Tree.Print printStmt) {
		for (Tree.Expr r : printStmt.exprs) {
			// TODO
			// Print支持三种类型的参数: bool/int/string，分别处理
			r.accept(this);
			tr.genParm(r.val);
			if(r.type.equal(BaseType.BOOL)) tr.genIntrinsicCall(Intrinsic.PRINT_BOOL) ;
			else if(r.type.equal(BaseType.INT)) tr.genIntrinsicCall(Intrinsic.PRINT_INT) ;
			else if(r.type.equal(BaseType.STRING)) tr.genIntrinsicCall(Intrinsic.PRINT_STRING) ;
		}
	}

	@Override
	public void visitIndexed(Tree.Indexed indexed) {
		indexed.array.accept(this);
		indexed.index.accept(this);
		tr.genCheckArrayIndex(indexed.array.val, indexed.index.val);
		
		Temp esz = tr.genLoadImm4(OffsetCounter.WORD_SIZE);
		Temp t = tr.genMul(indexed.index.val, esz);
		Temp base = tr.genAdd(indexed.array.val, t);
		indexed.val = tr.genLoad(base, 0);
	}

	@Override
	public void visitIdent(Tree.Ident ident) {
		if(ident.lvKind == Tree.LValue.Kind.MEMBER_VAR){
			ident.owner.accept(this);
		}
		
		switch (ident.lvKind) {
		case MEMBER_VAR:
			ident.val = tr.genLoad(ident.owner.val, ident.symbol.getOffset());
			break;
		default:
			ident.val = ident.symbol.getTemp();
			break;
		}
	}
	
	@Override
	public void visitBreak(Tree.Break breakStmt) {
		tr.genBranch(loopExits.peek());
	}

	@Override
	public void visitCallExpr(Tree.CallExpr callExpr) {
		if (callExpr.isArrayLength) {
			callExpr.receiver.accept(this);
			// TODO
			// 看README中对数组存储方式的说明
			callExpr.val=tr.genLoad(callExpr.receiver.val, -OffsetCounter.WORD_SIZE);
		} else {
			if (callExpr.receiver != null) {
				callExpr.receiver.accept(this);
			}
			for (Tree.Expr expr : callExpr.actuals) {
				expr.accept(this);
			}
			// TODO: 生成压栈和调用
			// 注意static与非static函数的区别
			if(callExpr.receiver!=null) tr.genParm(callExpr.receiver.val);
			for(Tree.Expr expr:callExpr.actuals) tr.genParm(expr.val);
			if(callExpr.receiver==null) callExpr.val = tr.genDirectCall(callExpr.symbol.getFuncty().label, callExpr.symbol.getReturnType());
			else{
				Temp temp=tr.genLoad(tr.genLoad(callExpr.receiver.val,0),callExpr.symbol.getOffset());
				callExpr.val = tr.genIndirectCall(temp, callExpr.symbol.getReturnType());
			}
		}
	}

	@Override
	public void visitForLoop(Tree.ForLoop forLoop) {
		// TODO: 参考visitWhileLoop
		if(forLoop.init!=null) forLoop.init.accept(this);
		
		Label cond = Label.createLabel();
		Label loop = Label.createLabel();
		tr.genBranch(cond);
		tr.genMark(loop);
		if (forLoop.update != null) forLoop.update.accept(this);
		tr.genMark(cond);
		forLoop.condition.accept(this);
		Label exit = Label.createLabel();
		tr.genBeqz(forLoop.condition.val, exit);
		loopExits.push(exit);
		if (forLoop.loopBody != null) {
			forLoop.loopBody.accept(this);
		}
		tr.genBranch(loop);
		loopExits.pop();
		tr.genMark(exit);
	}

	@Override
	public void visitIf(Tree.If ifStmt) {
		ifStmt.condition.accept(this);
		// TODO
		if (ifStmt.falseBranch == null&&ifStmt.trueBranch != null){
			Label exit = Label.createLabel();
			tr.genBeqz(ifStmt.condition.val, exit);
			if (ifStmt.trueBranch != null) ifStmt.trueBranch.accept(this);
			tr.genMark(exit);
		}else{
			Label exit = Label.createLabel();
			Label falseLabel = Label.createLabel();
			tr.genBeqz(ifStmt.condition.val, falseLabel);
			ifStmt.trueBranch.accept(this);
			tr.genBranch(exit);
			tr.genMark(falseLabel);
			ifStmt.falseBranch.accept(this);
			tr.genMark(exit);
		}
	}

	@Override
	public void visitNewArray(Tree.NewArray newArray) {
		// TODO
		newArray.length.accept(this);
		newArray.val = tr.genNewArray(newArray.length.val);
	}

	@Override
	public void visitNewClass(Tree.NewClass newClass) {
		newClass.val = tr.genDirectCall(newClass.symbol.getNewFuncLabel(),
				BaseType.INT);
	}

	@Override
	public void visitWhileLoop(Tree.WhileLoop whileLoop) {
		Label loop = Label.createLabel();
		tr.genMark(loop);
		whileLoop.condition.accept(this);
		Label exit = Label.createLabel();
		tr.genBeqz(whileLoop.condition.val, exit);
		loopExits.push(exit);
		if (whileLoop.loopBody != null) {
			whileLoop.loopBody.accept(this);
		}
		tr.genBranch(loop);
		loopExits.pop();
		tr.genMark(exit);
	}

	@Override
	public void visitTypeTest(Tree.TypeTest typeTest) {
		typeTest.instance.accept(this);
		typeTest.val = tr.genInstanceof(typeTest.instance.val,
				typeTest.symbol);
	}

	@Override
	public void visitTypeCast(Tree.TypeCast typeCast) {
		typeCast.expr.accept(this);
		// TODO
		if (!typeCast.expr.type.compatible(typeCast.symbol.getType())) tr.genClassCast(typeCast.expr.val,typeCast.symbol);
		typeCast.val=typeCast.expr.val;
	}
}
