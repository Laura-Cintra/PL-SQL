SET SERVEROUTPUT ON;

-- Loop
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 20;
    END LOOP;
END;

-- While
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    WHILE v_contador <= 20 LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
    END LOOP;
END;

-- For
BEGIN
    FOR v_contador IN 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- Exerc�cios

-- 1. Montar um bloco de programa��o que realize o processamento de uma tabuada qualquer, por exemplo a tabuada do n�mero 150.
DECLARE
    v_tabuada NUMBER := &num;
BEGIN
    dbms_output.put_line('Tabuada do ' || v_tabuada);
    FOR v_contador IN 1..10 LOOP
        dbms_output.put_line(v_contador * v_tabuada);
    END LOOP;
END;

-- 2. Em um intervalo num�rico inteiro, informar quantos n�meros s�o pares e quantos s�o �mpares.
DECLARE
    n1    NUMBER := &n1;
    n2    NUMBER := &n2;
    par   NUMBER := 0;
    impar NUMBER := 0;
BEGIN
    FOR v_contador IN n1..n2 LOOP
        IF MOD(v_contador, 2) = 0 THEN
            par := par + 1;
        ELSE
            impar := impar + 1;
        END IF;
    END LOOP;
    dbms_output.put_line('Pares ' || par || ' | �mpares ' || impar);
END;

-- 3. Exibir e m�dia dos valores pares em um intervalo num�rico e soma dos �mpares.
DECLARE
    n1    NUMBER := &n1;
    n2    NUMBER := &n2;
    par   NUMBER := 0;
    impar NUMBER := 0;
    somaPar NUMBER := 0;
    somaImpar NUMBER := 0;
BEGIN
    FOR v_contador IN n1..n2 LOOP
        IF MOD(v_contador, 2) = 0 THEN
            par := par + 1;
            somaPar := somaPar + v_contador;
        ELSE
            impar := impar + 1;
            somaImpar := somaImpar + v_contador;
        END IF;
    END LOOP;
    dbms_output.put_line('-- Pares | Soma: ' || somaPar|| ' | M�dia ' || somaPar/par);
    dbms_output.put_line('-- Impar | Soma: ' || somaImpar|| ' | M�dia ' || somaImPar/impar);
END;