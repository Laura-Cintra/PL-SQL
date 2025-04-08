-- Função para calcular FGTS
CREATE OR REPLACE FUNCTION calcx_fgts (
    valor NUMBER    
) RETURN NUMBER IS
BEGIN
    RETURN valor * 0.08;
END calcx_fgts;

-- Consulta usando a função
SELECT calcx_fgts(1000) FROM DUAL;

-- Procedure usando a função
CREATE OR REPLACE PROCEDURE prx_fgts AS
    v_valor NUMBER;
BEGIN
    v_valor := calcx_fgts(150000);
    dbms_output.put_line('O valor do FGTS é: ' || v_valor);
END;

SET SERVEROUTPUT ON;
CALL prx_fgts();

-- Exceções
CREATE OR REPLACE FUNCTION calcx_fgts_ex (
    valor NUMBER    
) RETURN NUMBER IS
    me_erro EXCEPTION;
    v_valor NUMBER;
BEGIN
    v_valor := valor * 0.08;
    IF v_valor < 80 THEN
        RAISE me_erro;
    END IF;
    RETURN v_valor;
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20001, 'FGTS NÃO PODE SER MENOR QUE 80 REAIS');
END calcx_fgts_ex;

SELECT calcx_fgts_ex(100) FROM DUAL;

-- Exercícios

-- 1. Crie um procedimento chamado prc_insere_produto para todas as colunas da tabela de produtos, valide:
--    Se o nome do produto tem mais de 3 caracteres e não contem números (0 a 9)

CREATE OR REPLACE PROCEDURE prc_insere_produto_ex(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE
) AS
    me_erro EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 3 OR REGEXP_LIKE(p_nome, '^[0-9]') THEN
        RAISE me_erro;
    END IF;
    
    INSERT INTO produto VALUES (
        p_cod,
        p_nome,
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
    
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20045, 'Nome do produto inválido!');
    COMMIT;
END;

CALL prc_insere_produto_ex(51, 'Processador', 5678905734567, 'Ativo', SYSDATE);

-- 2. Crie um procedimento chamado prc_insere_cliente para inserir novos clientes, valide:
--    Se o nome do cliente tem mais de 3 caracteres e não contem números (0 a 9)

CREATE OR REPLACE PROCEDURE prc_insere_cliente_ex(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
    me_erro EXCEPTION;
BEGIN
    IF LENGTH(p_nom_cliente_des_razao) < 3 OR REGEXP_LIKE(p_nom_cliente_des_razao, '^[0-9]') THEN
        RAISE me_erro;
    END IF;
        IF p_tipo = 'F' THEN 
            INSERT INTO cliente VALUES (
                p_cod,
                p_nom_cliente_des_razao,
                null,
                p_tipo,
                p_num_cpf_cnpj,
                p_dat_cadastro,
                null,
                p_status
            );
        ELSE
            INSERT INTO cliente VALUES (
                p_cod,
                p_nom_cliente_des_razao,
                p_nom_cliente_des_razao,
                p_tipo,
                p_num_cpf_cnpj,
                p_dat_cadastro,
                null,
                p_status
            );
        END IF;
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20045, 'Nome do cliente inválido!');
    COMMIT;
END;

CALL prc_insere_cliente_ex(153, 'Portal Banco', 'J', 34567892301489, SYSDATE, 'S');

-- 3. Crie uma função chamada FUN_VALIDA_NOME que valide se o nome tem mais do que 3 caracteres e não tenha números.

CREATE OR REPLACE FUNCTION fun_valida_nome (
    p_nome VARCHAR2   
) RETURN VARCHAR2 IS
    me_erro_carac EXCEPTION;
    me_erro_number EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 3 THEN
        RAISE me_erro_carac;
    ELSIF REGEXP_LIKE(p_nome, '\d') THEN
        RAISE me_erro_number;
    END IF;
    RETURN p_nome;
EXCEPTION
    WHEN me_erro_carac THEN 
        raise_application_error(-20045, 'Nome deve ter mais que 3 caracteres');
    WHEN me_erro_number THEN 
        raise_application_error(-20001, 'Nome não pode conter números');
END fun_valida_nome;

SELECT fun_valida_nome('Vergílio') FROM DUAL;

-- 4. Altere os procedimentos dos exercícios 1 e 2 para chamar a função do exercício 3

-- 4.1
CREATE OR REPLACE PROCEDURE prc_insere_produto_function(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE
) AS
BEGIN 
    INSERT INTO produto VALUES (
        p_cod,
        fun_valida_nome(p_nome),
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
END;

CALL prc_insere_produto_function(52, 'Processador', 5678905734567, 'Ativo', SYSDATE);

-- 4.2
CREATE OR REPLACE PROCEDURE prc_insere_cliente_function(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
BEGIN
    IF p_tipo = 'F' THEN 
        INSERT INTO cliente VALUES (
            p_cod,
            fun_valida_nome(p_nom_cliente_des_razao),
            null,
            p_tipo,
            p_num_cpf_cnpj,
            p_dat_cadastro,
            null,
            p_status
        );
    ELSE
        INSERT INTO cliente VALUES (
            p_cod,
            fun_valida_nome(p_nom_cliente_des_razao),
            fun_valida_nome(p_nom_cliente_des_razao),
            p_tipo,
            p_num_cpf_cnpj,
            p_dat_cadastro,
            null,
            p_status
        );
    END IF;
END;

CALL prc_insere_cliente_function(154, 'Teste', 'J', 34567892301489, SYSDATE, 'S');

-- 5. Altere o procedimento do exercício 1 para que tenha um último parâmetro chamado P_RETORNO do tipo varchar2 
--    que deverá retornar a informação ‘produto cadastrado com sucesso’

-- 6. Crie um bloco anônimo e chame o procedimento do exercício 1