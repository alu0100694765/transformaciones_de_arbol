var assert = chai.assert;

suite('Tests', function(){
  
  test('Asignacion: ', function(){
    object = pl0.parse("var x; x = 9. ")
    assert.equal(object.block.st.type, "=")
    assert.equal(object.block.st.left.type, "ID")
    assert.equal(object.block.st.left.value, "x")
    assert.equal(object.block.st.right.type, "NUM")
    assert.equal(object.block.st.right.value, "9") 
  });

  test('Suma: ', function(){
    object = pl0.parse("var x; x = 3 + 5 .")
    assert.equal(object.block.st.right.type, "+")
  });

  test('Multiplicacion: ', function(){
    object = pl0.parse("var x; x = 4 * 1 .")
    assert.equal(object.block.st.right.type, "*") 
  });

  test('Division: ', function(){
    object = pl0.parse("var x; x = 1 / 6 .")
    assert.equal(object.block.st.right.type, "/")
  });

  
  test('Asociatividad de izquierda: ', function(){
    object = pl0.parse("var x; x = 1-2-3 .")
    assert.equal(object.block.st.right.left.type, "-") 
  });
  
  test('Parentesis: ', function(){
    object = pl0.parse("var x; x = (2+4) * 9 .")
    assert.equal(object.block.st.right.left.type, "+")
  });
  
  test('Precedencia: ', function(){
    object = pl0.parse("var x; x = 2+3*3 .")
    assert.equal(object.block.st.right.left.type, "NUM")
  });

  test('Comparacion: ', function(){
    object = pl0.parse("const x = 1; var y; if x == 1 then y = 3 .")
    assert.equal(object.block.st.condition.type, "==")
  });

  
  test('Call: ', function(){
    object = pl0.parse("var a; procedure z; a = 2; call z.")
    assert.equal(object.block.st.type, "CALL")
  });

 
  test('While Do: ', function(){
    object = pl0.parse("const x = 1; var z; while x == 3 do z = z+3.")
    assert.equal(object.block.st.type, "WHILE")
  });

  test('Begin End: ', function(){
    object = pl0.parse("const b = 1; var x, z; begin x = 3; z = b+3 end.")
    assert.equal(object.type, "program")
  });
  
  test('Argumentos: ', function(){
    object = pl0.parse("const b = 40, c = 10; procedure square(x, y); call square(b, c); call square(c, b).")
    assert.equal(object.block.procs[0].arguments[1].value, "y")
    assert.equal(object.block.st.arguments[0].value.value, "c")
  });

  test('Error de Sintaxis: ', function(){
    assert.throws(function() { pl0.parse("x = 323"); }, /Parse error/);
  });
  
  test('Variable en tabla de simbolos: ', function(){
    object = pl0.parse("var a; procedure z; var b; a = 2; call z.")
    assert.equal(object.symbol_table.a.type, "var")
    assert.equal(object.block.procs[0].symbol_table.b.type, "var")
  });
  
  test('Constante en tabla de simbolos: ', function(){
    object = pl0.parse("const aa = 5; var a; procedure z; const bb = 40; a = aa ; call z.")
    assert.equal(object.symbol_table.aa.type, "const")
    assert.equal(object.block.procs[0].symbol_table.bb.value, "40")
  });
  
  test('Procedimiento en tabla de simbolos: ', function(){
    object = pl0.parse("const aa = 5; var a; procedure zz; const bb = 40; procedure zzz (arg1, arg2, arg3); arg1 = arg2; a = aa ; call z.")
    assert.equal(object.symbol_table.zz.type, "procedure")
    assert.equal(object.block.procs[0].symbol_table.zzz.arguments, 3)
  });
  
  test('Argumento en tabla de simbolos: ', function(){
    object = pl0.parse("var b; procedure a(d, t); b = 2; call a(b, b).")
    assert.equal(object.block.procs[0].symbol_table.d.type, "argument")
  });
  
  test('Atributo de declaracion de identificador: ', function(){
    object = pl0.parse("var b; procedure a(d, t); const xy = 10; b = xy; call a(b, b).")
    assert.equal(object.block.procs[0].block.st.left.declared_in, "global")
    assert.equal(object.block.procs[0].block.st.right.declared_in, "a")
  });
  
  test('Error de ID no declarada: ', function(){
    assert.throws(function() { pl0.parse("procedure a; mal = 2; call a."); }, /previa de 'mal'/);
  });
  
  test('Error de Call a un no procedimiento: ', function(){
    assert.throws(function() { pl0.parse("var tr; procedure a; tr = 2; call tr."); }, /previa de 'tr'/);
  });

  test('Error de Numero de Argumentos: ', function(){
     assert.throws(function() { pl0.parse("var b; procedure a(d, t); b = 2; call a(b)."); }, /Se pasa\/n 1 parametro\/s a \'a\'; se esperaba\/n 2/);
  });
  
  test('Error de Asignacion a Constante: ', function(){
    assert.throws(function() { pl0.parse("const ct = 4; procedure a(d, t); ct = 2; call a(b, b)."); }, /'ct' no es una variable/);
  });

});

