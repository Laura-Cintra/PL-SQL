-- Estrutura de decisão

set serveroutput on;

DECLARE
    genero CHAR(1) := '&digite';
BEGIN
    IF upper(genero) = 'M' THEN
        dbms_output.put_line('O gênero informado é Masculino');
    ELSIF upper(genero) = 'F' THEN
        dbms_output.put_line('O gênero informado é Feminino');
    ELSE
        dbms_output.put_line('Outros');
    END IF;
END;

-- 1. Criar um bloco anônimo para informar se o número informado é par ou ímpar

DECLARE
    numero NUMBER := &num;
BEGIN
    IF MOD(numero, 2) = 0 THEN
        dbms_output.put_line('O número informado é par');
    ELSE
        dbms_output.put_line('O número informado é ímpar');
    END IF;
END;

-- 2. Criar um bloco anônimo para informar o usuário se a nota está acima da média, na média ou reprovado.
--      * Acima de 8 e menor que 10 = nota acima da média!
--      * Entre 6 e 7 na média.
--      * menor que 6 reprovado.

DECLARE
    nota NUMBER := &nota;
BEGIN
    IF nota >= 8 AND nota <= 10 THEN
        dbms_output.put_line('Sua nota está acima da média!');
    ELSIF nota BETWEEN 6 AND 7 THEN
        dbms_output.put_line('Sua nota está na média');
    ELSE
        dbms_output.put_line('Você foi reprovado :(');
    END IF;
END;

-- Instruções DML e DQL no bloco

-- DQL
CREATE TABLE aluno (
    ra   CHAR(9),
    nome VARCHAR2(50),
    CONSTRAINT aluno_pk PRIMARY KEY (ra)
);

INSERT INTO ALUNO (RA, NOME) VALUES ('111222333', 'Antonio Alves');
INSERT INTO ALUNO (RA, NOME) VALUES ('222333444', 'Beatriz Bernardes');
INSERT INTO ALUNO (RA, NOME) VALUES ('333444555', 'Cláudio Cardoso');

-- Buscando o aluno por uma consulta ra
DECLARE
    v_ra   CHAR(9) := '333444555';
    v_nome VARCHAR2(50);
BEGIN
    SELECT NOME INTO v_nome FROM ALUNO WHERE RA = v_ra;
    dbms_output.put_line('O nome do aluno é: ' || v_nome);
END;

-- Inserindo valores no banco usando variáveis
DECLARE
    v_ra   CHAR(9) := '444555666';
    v_nome VARCHAR2(50) := 'Daniela Dorneles';
BEGIN
    INSERT INTO ALUNO (ra, nome) VALUES (v_ra, v_nome);
END;

-- Atualizando um registro no bando a partir do valor de uma variável
DECLARE
    v_ra   CHAR(9) := '111222333';
    v_nome VARCHAR2(50) := 'Antonio Rodrigues';
BEGIN
    UPDATE aluno SET nome = v_nome WHERE ra = v_ra;
END;

-- Deletando valores do banco através do valor da variável
DECLARE
    v_ra CHAR(9) := '444555666';
BEGIN
    DELETE FROM aluno WHERE ra = v_ra;
END;

