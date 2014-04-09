/* description: Parses end executes mathematical expressions. */

%{
var symbol_table = {};

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
    : statement '.' EOF
        { 
          $$ = { type: 'program', block: $1 };
          return $$;
        }
    ;

expressions
    : s  
        { $$ = (typeof $1 === 'undefined')? [] : [ $1 ]; }
    | expressions ';' s
        { $$ = $1;
          if ($3) $$.push($3); 
          console.log($$);
        }
    ;

s
    : /* empty */
    | e
    ;


statement
    : ID '=' e
        { $$ = { type: '=', left: $1, right: $3 }; }
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
    : /* vacío */
    | '(' ID args_r ')'
        {
          $$ = [$2];
          if ($3) $$ = $$.concat($3);
        }
    ;
    
args_r
    : /* vacío */
    | ',' ID args_r
        {
          $$ = [$2]
          if ($3) $$ = $$.concat($3);
        }
    ;
    
condition
    : ODD e
        { $$ = { type: 'ODD', e: $2 }; }
    | e '==' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    | e '#' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    | e '<' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    | e '<=' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    | e '>' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    | e '>=' e
        { $$ = { type: $2, left: $1, right: $3 }; }
    ;

e
    : ID '=' e
        { symbol_table[$1] = $$ = $3; }
    | PI '=' e 
        { throw new Error("Can't assign to constant 'Ï€'"); }
    | E '=' e 
        { throw new Error("Can't assign to math constant 'e'"); }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {
          if ($3 == 0) throw new Error("Division by zero, error!");
          $$ = $1/$3;
        }
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {
          if ($1 % 1 !== 0) 
             throw "Error! Attempt to compute the factorial of "+
                   "a floating point number "+$1;
          $$ = fact($1);
        }
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID 
        { $$ = symbol_table[yytext] || 0; }
    ;
    