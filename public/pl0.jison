/* description: Parses end executes mathematical expressions. */

%{
  
  var ambitos = [{}];
  var nombres = ["global"];
  
  function buscarSimbolo (s) {
    
    for (i = (ambitos.length - 1); i >= 0; i--) {

      if (ambitos[i][s] != undefined && ambitos[i][s].type != "procedure")
        return nombres[i];
    }
    
    throw new Error(" Se precisa la declaraci&oacute;n previa de '" + s + "'" );
  }
  
  function buscarVariable (s) {
    
    for (i = (ambitos.length - 1); i >= 0; i--) {

      if (ambitos[i][s] != undefined)
        if (ambitos[i][s].type == "var" || ambitos[i][s].type == "argument")
          return nombres[i];
        else
          throw new Error(" '" + s + "' no es una variable" );
    }
    
    throw new Error(" Se precisa la declaraci&oacute;n previa de '" + s + "'" );
  }
  
  function buscarProcedimiento (s, n) {
    
    for (i = (ambitos.length - 1); i >= 0; i--) {

      if (ambitos[i][s] != undefined && ambitos[i][s].type == "procedure") {
       
        if (ambitos[i][s].arguments == n)
          return nombres[i];
        
        throw new Error(" Se pasa/n " + n + " parametros a '" + s + "'; se esperaba/n " + ambitos[i][s].arguments);
      }
        
    }
    
    throw new Error(" Se precisa la declaraci&oacute;n previa de '" + s + "'" );
  }

%}

%token NUMBER ID E PI ODD EOF IF THEN ELSE WHILE DO CALL BEGIN
/* operator associations and precedence */

%right THEN ELSE
%left '==' '>=' '<=' '<' '>' '#'
%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '%'
%left UMINUS
%left '!'

%start prog

%% /* language grammar */
prog
    : block '.' EOF
        { 
          $$ = { type: 'program', block: $1, symbol_table: ambitos[0] };
          return $$;
        }
    ;

block
    : consts vars procs statement
        {
          $$ = { type: 'block', procs: $3, st: $4 };
        }
    ;
   
consts
    : /* vacío */
    | CONST ID '=' NUMBER r_consts ';'
        {
          ambitos[ambitos.length - 1][$2] = { type: 'const', value: $4 };

          //$$ = [ { type: 'const', id: $2, value: $4 } ];
          //if ($5) $$ = $$.concat($5);
        }
    ;
    
r_consts
    : /* vacío */
    | ',' ID '=' NUMBER r_consts
        {
          ambitos[ambitos.length - 1][$2] = { type: 'const', value: $4 };
          
          //$$ = [ { type: 'const', id: $2, value: $4 } ];
          //if ($5) $$ = $$.concat($5);
        }
    ;
    
vars
    : /* vacío */
    | VAR ID r_vars ';'
        {
          ambitos[ambitos.length - 1][$2] = { type: 'var' };
          
          //$$ = [ { type: 'var', id: $2 } ];
          //if ($3) $$ = $$.concat($3);
        }
    ;
    
r_vars
    : /* vacío */
    | ',' ID r_vars
        {
          ambitos[ambitos.length - 1][$2] = { type: 'var' };
          
          //$$ = [ { type: 'var', id: $2 } ];
          //if ($3) $$ = $$.concat($3);
        }
    ;
    
procs
    : /* empty */ 
    | proc procs
        {
          $$ = [$1];
          if ($2) $$ = $$.concat($2);
        }
    ;
    
proc
    : PROCEDURE dec_proc ';' block ';'
        {
          
          $$ = { type: 'procedure', id: $2[0], arguments: $2[1], block: $4, symbol_table: ambitos.pop() };
          nombres.pop();
        }
    ;
    
dec_proc
    : name dec_args
        {
          $$ = [$1, $2];
          
          ambitos[ambitos.length - 2][$1] = { type: 'procedure', arguments: $2? $2.length : 0 };
        }
    ;
    
name
    : ID
        {
          $$ = $1;
          nombres.push($1);
          ambitos.push({});
          console.log(nombres);
        }
    ;
    
statement
    : ID '=' e
        { 

          //buscarVariable($1);
          $$ = { type: '=', left: { type: 'ID', value: $1, declared_in: buscarVariable($1) }, right: $3 }; 
        }
    | CALL ID args
        { 

          //buscarProcedimiento($2, $3.length);
          $$ = { type: 'CALL', id: $2, declared_in: buscarProcedimiento($2, $3.length), arguments: $3 }; 
        }
    | BEGIN statement statement_r END
        { 
          var v_sts = [$2];
          if ($3) v_sts = v_sts.concat($3);
          $$ = { type: 'BEGIN', statements: v_sts }; 
        }
    | IF condition THEN statement 
        { $$ = { type: 'IF', condition: $2, statement: $4 }; }
    | IF condition THEN statement ELSE statement
        { $$ = { type: 'IF', condition: $2, true_st: $4, false_st: $6 }; }
    | WHILE condition DO statement
        { $$ = { type: 'WHILE', condition: $2, statement: $4 }; }
    ;
    
statement_r
    : /* vacío */
    | ';' statement statement_r
        {
          $$ = [$2];
          if ($3) $$ = $$.concat($3);
        }
    ;
    
dec_args
    : /* vacío */ { $$ = []; }
    | '(' ID dec_args_r ')'
        {
          $$ = [{ type: 'argument', value: $2 }];
          if ($3) $$ = $$.concat($3);

          for (i = 0; i < $$.length; i++)
            ambitos[ambitos.length - 1][$$[i].value] = { type: 'argument' };
        }
    ;

dec_args_r
    : /* vacío */
    | ',' ID dec_args_r
        {
          $$ = [{ type: 'argument', value: $2 }]
          if ($3) $$ = $$.concat($3);
        }
    ;
    
args
    : /* vacío */ { $$ = []; }
    | '(' e args_r ')'
        {
          $$ = [{ type: 'argument', value: $2 }];
          if ($3) $$ = $$.concat($3);
        }
    ;
    
args_r
    : /* vacío */
    | ',' e args_r
        {
          $$ = [{ type: 'argument', value: $2 }]
          if ($3) $$ = $$.concat($3);
        }
    ;
    
condition
    : ODD e
        { $$ = { type: 'ODD', e: $2 }; }
    | e COMP e
        { $$ = { type: $2, left: $1, right: $3 }; }
    ;

e
    : ID '=' e
        {

          //buscarVariable($1);
          $$ = { type: '=', left: { type: 'ID', value: $1, declared_in: buscarVariable($1) }, right: $3 }; 
        }
    | PI '=' e 
        { throw new Error("Can't assign to constant 'Ï€'"); }
    | E '=' e 
        { throw new Error("Can't assign to math constant 'e'"); }
    | e '+' e
        {$$ = { type: '+', left: $1, right: $3 }; }
    | e '-' e
        {$$ = { type: '-', left: $1, right: $3 }; }
    | e '*' e
        {$$ = { type: '*', left: $1, right: $3 }; }
    | e '/' e
        {$$ = { type: '/', left: $1, right: $3 }; }
    | e '^' e
        {$$ = { type: '^', left: $1, right: $3 }; }
    | e '!'
        {$$ = { type: '!', left: $1 }; }
    | e '%'
        {$$ = { type: '%', left: $1 }; }
    | '-' e %prec UMINUS
        {$$ = { type: '-', right: $2 }; }
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = { type: 'NUM', value: Number(yytext) };}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID 
        { 

          //buscarSimbolo($1);
          $$ = { type: 'ID', value: $1, declared_in: buscarSimbolo($1) };
        }
    ;
    