-- Estrutura de decis�o

set serveroutput on;

DECLARE
    genero CHAR(1) := '&digite';
BEGIN
    IF upper(genero) = 'M' THEN
        dbms_output.put_line('O g�nero informado � Masculino');
    ELSIF upper(genero) = 'F' THEN
        dbms_output.put_line('O g�nero informado � Feminino');
    ELSE
        dbms_output.put_line('Outros');
    END IF;
END;

-- 1. Criar um bloco an�nimo para informar se o n�mero informado � par ou �mpar

DECLARE
    numero NUMBER := &num;
BEGIN
    IF MOD(numero, 2) = 0 THEN
        dbms_output.put_line('O n�mero informado � par');
    ELSE
        dbms_output.put_line('O n�mero informado � �mpar');
    END IF;
END;

-- 2. Criar um bloco an�nimo para informar o usu�rio se a nota est� acima da m�dia, na m�dia ou reprovado.
--      * Acima de 8 e menor que 10 = nota acima da m�dia!
--      * Entre 6 e 7 na m�dia.
--      * menor que 6 reprovado.

DECLARE
    nota NUMBER := &nota;
BEGIN
    IF nota >= 8 AND nota <= 10 THEN
        dbms_output.put_line('Sua nota est� acima da m�dia!');
    ELSIF nota BETWEEN 6 AND 7 THEN
        dbms_output.put_line('Sua nota est� na m�dia');
    ELSE
        dbms_output.put_line('Voc� foi reprovado :(');
    END IF;
END;

-- Instru��es DML e DQL no bloco

-- DQL
CREATE TABLE aluno (
    ra   CHAR(9),
    nome VARCHAR2(50),
    CONSTRAINT aluno_pk PRIMARY KEY (ra)
);

INSERT INTO ALUNO (RA, NOME) VALUES ('111222333', 'Antonio Alves');
INSERT INTO ALUNO (RA, NOME) VALUES ('222333444', 'Beatriz Bernardes');
INSERT INTO ALUNO (RA, NOME) VALUES ('333444555', 'Cl�udio Cardoso');

-- Buscando o aluno por uma consulta ra
DECLARE
    v_ra   CHAR(9) := '333444555';
    v_nome VARCHAR2(50);
BEGIN
    SELECT NOME INTO v_nome FROM ALUNO WHERE RA = v_ra;
    dbms_output.put_line('O nome do aluno �: ' || v_nome);
END;

-- Inserindo valores no banco usando vari�veis
DECLARE
    v_ra   CHAR(9) := '444555666';
    v_nome VARCHAR2(50) := 'Daniela Dorneles';
BEGIN
    INSERT INTO ALUNO (ra, nome) VALUES (v_ra, v_nome);
END;

-- Atualizando um registro no bando a partir do valor de uma vari�vel
DECLARE
    v_ra   CHAR(9) := '111222333';
    v_nome VARCHAR2(50) := 'Antonio Rodrigues';
BEGIN
    UPDATE aluno SET nome = v_nome WHERE ra = v_ra;
END;

-- Deletando valores do banco atrav�s do valor da vari�vel
DECLARE
    v_ra CHAR(9) := '444555666';
BEGIN
    DELETE FROM aluno WHERE ra = v_ra;
END;

