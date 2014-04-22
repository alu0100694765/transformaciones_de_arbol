/* description: Parses end executes mathematical expressions. */

%{
  var aux_use = {};
  
  var ambitos = [[{}]];
  
  function fact (n) { 
    return n==0 ? 1 : fact(n-1) * n 
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
          $$ = { type: 'program', block: $1, symbol_table: ambitos[0][0], usados: aux_use };
          return $$;
        }
    ;

block
    : cyv procs statement
        {
          $$ = { type: 'block', procs: $2, st: $3 };
        }
    ;
    
cyv
    : consts vars
        {
          ambitos.push([{}]);
        }
    ;
    
consts
    : /* vacío */
    | CONST ID '=' NUMBER r_consts ';'
        {
          ambitos[ambitos.length - 1][ambitos[ambitos.length - 1].length - 1][$2] = { type: 'const', value: $4 };

          //$$ = [ { type: 'const', id: $2, value: $4 } ];
          //if ($5) $$ = $$.concat($5);
        }
    ;
    
r_consts
    : /* vacío */
    | ',' ID '=' NUMBER r_consts
        {
          ambitos[ambitos.length - 1][ambitos[ambitos.length - 1].length - 1][$2] = { type: 'const', value: $4 };
          
          //$$ = [ { type: 'const', id: $2, value: $4 } ];
          //if ($5) $$ = $$.concat($5);
        }
    ;
    
vars
    : /* vacío */
    | VAR ID r_vars ';'
        {
          ambitos[ambitos.length - 1][ambitos[ambitos.length - 1].length - 1][$2] = { type: 'var' };
          
          //$$ = [ { type: 'var', id: $2 } ];
          //if ($3) $$ = $$.concat($3);
        }
    ;
    
r_vars
    : /* vacío */
    | ',' ID r_vars
        {
          ambitos[ambitos.length - 1][ambitos[ambitos.length - 1].length - 1][$2] = { type: 'var' };
          
          //$$ = [ { type: 'var', id: $2 } ];
          //if ($3) $$ = $$.concat($3);
        }
    ;
    
procs
    : /* empty */ 
        {     
          ambitos.pop(); 
        }
    | proc procs
        {

          $$ = [$1];
          if ($2) $$ = $$.concat($2);
          
          if (ambitos[ambitos.length - 1].length == 0)
            ambitos.pop();
        }
    ;
    
proc
    : PROCEDURE ID args ';' block ';'
        {

          $$ = { type: 'procedure', id: $2, arguments: $3, block: $5, symbol_table: ambitos[ambitos.length - 1][0], usados: aux_use };

          ambitos[ambitos.length - 2][ambitos[ambitos.length - 1].length - 1][$2] = { type: 'procedure', arguments: $3? $3.length : 0 };
        
          ambitos[ambitos.length - 1] = [{}];
        }
    ;

statement
    : ID '=' e
        { 
          aux_use[$1] = { type: 'var' };
          $$ = { type: '=', left: { type: 'ID', value: $1 }, right: $3 }; 
        }
    | CALL ID args
        { $$ = { type: 'CALL', id: $2, arguments: $3 }; }
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
    
args
    : /* vacío */ { $$ = []; }
    | '(' e args_r ')'
        {
          $$ = [{ type: 'ARG', value: $2 }];
          if ($3) $$ = $$.concat($3);
        }
    ;
    
args_r
    : /* vacío */
    | ',' e args_r
        {
          $$ = [{ type: 'ARG', value: $2 }]
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
          aux_use[$1] = { type: 'var' }
          $$ = { type: '=', left: { type: 'ID', value: $1 }, right: $3 }; 
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
          aux_use[$1] = { type: 'var' }
          $$ = { type: 'ID', value: $1 };
        }
    ;
    