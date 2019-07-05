grammar myCompiler;

options {
   language = Java;
}

@header {
    // import packages here.
    import java.util.HashMap;
    import java.util.ArrayList;
}

@members {
    boolean TRACEON = false;

    // ============================================
    // Create a symbol table.
	// ArrayList is easy to extend to add more info. into symbol table.
	//
	// The structure of symbol table:
	// <variable ID, type, memory location>
	//    - type: the variable type   (please check "enum Type")
	//    - memory location: the location (locals in VM) the variable will be stored at.
    // ============================================
    HashMap<String, ArrayList> symtab = new HashMap<String, ArrayList>();

    int labelCount = 0;
	
	
	// storageIndex is used to represent/index the location (locals) in VM.
	// The first index is 0.
	int storageIndex = 0;

    // Record all assembly instructions.
    List<String> TextCode = new ArrayList<String>();

    // Type information.
    public enum Type{
       INT, FLOAT, CHAR;
    }


    /*
     * Output prologue.
     */
    void prologue()
    {
       TextCode.add(";.source myCompiler.j");
       TextCode.add(".class public static myResult");
       TextCode.add(".super java/lang/Object");
       TextCode.add(".method public static main([Ljava/lang/String;)V");
       /* The size of stack and locals should be properly set. */
       TextCode.add(".limit stack 100");
       TextCode.add(".limit locals 100");
    }
    
	
    /*
     * Output epilogue.
     */
    void epilogue()
    {
       /* handle epilogue */
       TextCode.add("return");
       TextCode.add(".end method");
    }
    
    
    /* Generate a new label */
    String newLabel()
    {
       labelCount ++;
       return (new String("L")) + Integer.toString(labelCount);
    } 
    
    
    public List<String> getTextCode()
    {
       return TextCode;
    }			
}

program: VOID MAIN '(' ')'
        {
           /* Output function prologue */
           prologue();
        }

        '{' 
           declarations
           statements
        '}'
        {
		   if (TRACEON)
		      System.out.println("VOID MAIN () {declarations statements}");

           /* output function epilogue */	  
           epilogue();
        }
        ;


declarations: type Identifier ';' declarations{
			    if (TRACEON)
	            System.out.println("declarations: type Identifier : declarations");

          if (symtab.containsKey($Identifier.text)) {
				    // variable re-declared.
              System.out.println("Type Error: " + 
                                  $Identifier.getLine() + 
                                  ": Redeclared identifier.");
              System.exit(0);
          }
                 
				 /* Add ID and its attr_type into the symbol table. */
				 ArrayList the_list = new ArrayList();
				 the_list.add($type.attr_type);
				 the_list.add(storageIndex);
				 storageIndex = storageIndex + 1;
         symtab.put($Identifier.text, the_list);
      }
            | 
		      {
			     if (TRACEON)
                    System.out.println("declarations: ");
			  }
            ;


type
returns [Type attr_type]
    : INT { if (TRACEON) System.out.println("type: INT"); attr_type=Type.INT; }
    | CHAR { if (TRACEON) System.out.println("type: CHAR"); attr_type=Type.CHAR; }
    | FLOAT {if (TRACEON) System.out.println("type: FLOAT"); attr_type=Type.FLOAT; }
	;

statements:statement statements
          |
          ;

statement: assign_stmt ';'
         | if_stmt
         | func_no_return_stmt ';'
         | for_stmt
         | printf_statements
         ;
printf_statements returns[List <String> c=new ArrayList()]: PRINTF'(' a=STRING_LITERAL (','b=Identifier{$c.add($b.text);})*')' ';'{
            TextCode.add("\t; print the value.");
            $a.text.toString();
            String result=new String($a.text);
            String[] pun={"\\n","\\b","\\t","\\f","\\r","\\\"","\\\'", "\\\\"};
            for(int i=0;i<pun.length;i++){
                int newline=result.indexOf(pun[i]);
                if(newline!=-1){
                    String newline2=result.substring(newline,newline+2);
                    result=result.replace(newline2,"");
                }
            }
            //Contain variable
            if(result.contains("\%d")||result.contains("\%f")&&c!=null){
                int index_var=0;
                for(int i=1;i<result.length()-1;i++){
                    if(result.charAt(i)=='\%'){
                        Type the_type;
                        int the_mem;
                        String id=c.get(index_var);
                        index_var++;
                        the_type = (Type) symtab.get(id).get(0);
                        the_mem = (int) symtab.get(id).get(1);
                        String str_type= String.valueOf(the_type);
                        //check type
                        if ( (str_type.equals("INT")&& result.charAt(i+1)=='f') 
                             || (str_type.equals("FLOAT")&& result.charAt(i+1)=='d')) {
                            System.out.println("Printf : Type error!\n");
                            System.exit(0);
                        }
                        if(str_type.equals("INT")){
                            TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
                            TextCode.add("\tiload "+the_mem);
                            TextCode.add("\tinvokevirtual java/io/PrintStream/print(I)V");
                            result=result.replaceFirst("\%d","");
                        }
                        else if(str_type.equals("FLOAT")){
                            TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
                            TextCode.add("\tfload "+the_mem);
                            TextCode.add("\tinvokevirtual java/io/PrintStream/print(F)V");
                            result=result.replaceFirst("\%f","");
                        }
                    }
                    //Other Literal
                    int index=result.indexOf("\%");
                    if(index!=-1){
                        String cut=result.substring(i,index);
                        TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
                        TextCode.add("\tldc \""+cut+"\"");
                        TextCode.add("\tinvokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");
                        i=index-1;
                    }
                    //Remain Literal without any variable
                    else{
                        String cut=result.substring(i,result.length()-1);
                        TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
                        TextCode.add("\tldc \""+cut+"\"");
                        TextCode.add("\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");
                        i=result.length()-2;
                    }

                }
            }
            //No variable
            else if(b==null){
                TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
                TextCode.add("\tldc "+result);
                TextCode.add("\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");
            }
            //Error 
            else{
                System.out.println("Printf : Type error!\n");
                System.exit(0);
            }        
};
for_stmt: FOR '(' assign_stmt ';'
                  cond_expression ';'
				          assign_stmt
			        ')'
			            block_stmt
        ;
		 
		 
if_stmt
            : if_then_stmt if_else_stmt[$if_then_stmt.lab]
            ;
	   
if_then_stmt
returns[String lab]: IF '(' a=cond_expression ')' block_stmt{
                  String label=newLabel();
                  $lab=label;
                  TextCode.add("\tgoto "+label);
                  TextCode.add($a.lab+":");
               }
            ;


if_else_stmt
[String lab]: ELSE block_stmt{
              TextCode.add($lab+":");
            }
            | {TextCode.add($lab+":");}
            ;

				  
block_stmt: '{' statements '}'
	  ;


assign_stmt: Identifier '=' (a=type)? arith_expression{
			      Type the_type;
			      int the_mem;
			      // get the ID's location and type from symtab.			   
			      the_type = (Type) symtab.get($Identifier.text).get(0);
			      the_mem = (int) symtab.get($Identifier.text).get(1);
			      if (the_type != $arith_expression.attr_type) {
			          System.out.println("Type error!\n");
				        System.exit(0);
			      }
			       // issue store insruction:
               // => store the top element of the operand stack into the locals.
			   switch (the_type) {
			   case INT:
			              TextCode.add("\tistore " + the_mem);
			              break;
			   case FLOAT:
                    TextCode.add("\tfstore " + the_mem);
			              break;
			   case CHAR:
			              break;
			   }
             }
           ;

		   
func_no_return_stmt: Identifier '(' argument ')'
                   ;


argument: arg (',' arg)*
        ;

arg: arith_expression
   | STRING_LITERAL
   ;
		   
cond_expression
returns [boolean truth,Type type,String lab]
               : a=arith_expression{
				    /*if ($a.attr_type.ordinal() != 0)
					      truth = true;
					  else
					      truth = false;*/
				    }
        (b=RelationOP c=arith_expression)*{
            if($a.attr_type!=$c.attr_type){
                System.out.println("Comparsion:Type Error");
                System.exit(0);
            }
            $type=$a.attr_type;
            String compare=new String($b.text);
            String[] operators={">",">=","<","<=","==","!="};
            //Check Identifier
            if(symtab.containsKey($a.text)){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tiload "+symtab.get($a.text).get(1)); 
                else if($a.attr_type == Type.FLOAT)
                    TextCode.add("\tfload "+symtab.get($a.text).get(1));  
            }
            else
                  TextCode.add("\tldc "+$a.text);
            if(symtab.containsKey($c.text)){
                if($c.attr_type == Type.INT)
                    TextCode.add("\tiload "+symtab.get($c.text).get(1));
                else if($c.attr_type == Type.FLOAT)
                    TextCode.add("\tfload "+symtab.get($c.text).get(1));
            }
            else
                  TextCode.add("\tldc "+$c.text);
            //Logical Operator
            String label=newLabel();
            $lab=label;
            if(compare.equals(operators[0])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmple "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tifle "+label);
                }
            }
            else if(compare.equals(operators[1])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmplt "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tiflt "+label);
                }
            }
            else if(compare.equals(operators[2])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmpge "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tifge "+label);
                }
            }
            else if(compare.equals(operators[3])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmpgt "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tifgt "+label);
                }
            }
            else if(compare.equals(operators[4])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmpne "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tifne "+label);
                }
            }
            else if(compare.equals(operators[5])){
                if($a.attr_type == Type.INT)
                    TextCode.add("\tif_icmpeq "+label);
                else if($a.attr_type == Type.FLOAT){
                    TextCode.add("\tfcmpl");
                    TextCode.add("\tifeq "+label);
                }
            }

        };

			   
arith_expression
returns [Type attr_type]
                : a=multExpr { $attr_type = $a.attr_type; }
                  ( '+' b=multExpr {
						              if (($attr_type == Type.INT) &&
						                ($b.attr_type == Type.INT))
						                  TextCode.add("\tiadd");
                          else if(($attr_type == Type.FLOAT) &&
                                  ($b.attr_type == Type.FLOAT))
                              TextCode.add("\tfadd");
                      }
                 |  '-' c=multExpr {
                          if (($attr_type == Type.INT) &&
                            ($c.attr_type == Type.INT))
                              TextCode.add("\tisub");
                          else if(($attr_type == Type.FLOAT) &&
                                  ($c.attr_type == Type.FLOAT))
                              TextCode.add("\tfsub");
                      }
                 )*
                 ;

multExpr
returns [Type attr_type]
          : a=signExpr { $attr_type=$a.attr_type; }
          ( '*' b=signExpr
      { 
            if (($attr_type == Type.INT) &&
                  ($b.attr_type == Type.INT))
                 TextCode.add("\timul");
            else if(($attr_type == Type.FLOAT) &&
                  ($b.attr_type == Type.FLOAT))
              TextCode.add("\tfmul");
                       }
          | '/' c=signExpr
      {
            if (($attr_type == Type.INT) &&
                  ($c.attr_type == Type.INT))
                 TextCode.add("\tidiv");
            else if(($attr_type == Type.FLOAT) &&
                  ($c.attr_type == Type.FLOAT))
              TextCode.add("\tfdiv");
                       }
    )*
	  ;

signExpr
returns [Type attr_type]
        : a=primaryExpr { $attr_type=$a.attr_type; } 
        | '-' b=primaryExpr{ 
          $attr_type=$b.attr_type;
          if($b.attr_type==Type.INT)
              TextCode.add("\tineg");
          else if($b.attr_type==Type.FLOAT)
              TextCode.add("\tfneg");
      };

primaryExpr
returns [Type attr_type] 
           : Integer_constant
		     {
			    $attr_type = Type.INT;
				
				// code generation.
				// push the integer into the operand stack.
				TextCode.add("\tldc " + $Integer_constant.text);
			 }
           | Floating_point_constant{
                 $attr_type = Type.FLOAT;
                 TextCode.add("\tldc " + $Floating_point_constant.text);
           }
           | Identifier{
			    // get type information from symtab.
			    $attr_type = (Type) symtab.get($Identifier.text).get(0);
				
				switch ($attr_type) {
				case INT: 
				          // load the variable into the operand stack.
				          TextCode.add("\tiload " + symtab.get($Identifier.text).get(1));
				          break;
				case FLOAT:
                  TextCode.add("\tfload " + symtab.get($Identifier.text).get(1));
				          break;
				case CHAR:
				          break;
				
				}
		}
	   | '&' Identifier{
          // get type information from symtab.
          $attr_type = (Type) symtab.get($Identifier.text).get(0);
        
        switch ($attr_type) {
        case INT: 
                  // load the variable into the operand stack.
                  TextCode.add("\tiload " + symtab.get($Identifier.text).get(1));
                  break;
        case FLOAT:
                  TextCode.add("\tfload " + symtab.get($Identifier.text).get(1));
                  break;
        case CHAR:
                  break;
        
        }
    }
	   | '(' a=arith_expression ')'{
        $attr_type=$a.attr_type;
     }
           ;

		   
/* description of the tokens */
FLOAT:'float';
INT:'int';
CHAR: 'char';

MAIN: 'main';
VOID: 'void';
IF: 'if';
ELSE: 'else';
FOR: 'for';
PRINTF:'printf';
RelationOP: '>' |'>=' | '<' | '<=' | '==' | '!=';

Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
Integer_constant:'0'..'9'+;
Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;

STRING_LITERAL
    :  '"' ( EscapeSequence | ~('\\'|'"') )* '"'
    ;

WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
COMMENT:'/*' .* '*/'  {$channel=HIDDEN;};


fragment
EscapeSequence
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    ;

