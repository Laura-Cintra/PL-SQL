SET SERVEROUTPUT ON;

-- RM558843 - Laura de Oliveira Cintra
-- RM 558832 - Maria Eduarda Alves da Paixao
-- RM 554456 - Vinicius Saes de Souza
-- 2TDSPK

-- Ex 1 - Fun que retorna a categoria mais movimentada (em quantidade total) no mês atual. Use JOINs, CASE e SYSDATE.

-- categoria = nome do produto?
SELECT * FROM movimento_estoque WHERE EXTRACT(MONTH FROM dat_movimento_estoque) = EXTRACT(MONTH FROM SYSDATE);

-- outra alternativa - gambiarra
SELECT TO_CHAR(SYSDATE,'MM') FROM DUAL;

CREATE OR REPLACE FUNCTION fn_categoria_movimentada
RETURN VARCHAR2
IS
    v_categoria VARCHAR2(40);
BEGIN
    FOR i IN (
        SELECT a.nom_produto, SUM(b.qtd_movimentacao_estoque) AS total_movimentacao
        FROM produto a
        JOIN movimento_estoque b ON a.cod_produto = b.cod_produto
        WHERE EXTRACT(MONTH FROM dat_movimento_estoque) = EXTRACT(MONTH FROM SYSDATE)
        GROUP BY a.nom_produto
        ORDER BY total_movimentacao DESC
    ) LOOP
        v_categoria := i.nom_produto;
        RETURN v_categoria;
    END LOOP;
END;

SELECT fn_categoria_movimentada FROM dual;

-- Ex 2 - Procedure que lista produtos sem nenhum movimento nos últimos 6 meses

CREATE OR REPLACE PROCEDURE sp_valida_produtos_sem_movimento
IS
    me_erro EXCEPTION;
    v_total_produtos NUMBER;
BEGIN
    FOR i IN (
        SELECT b.cod_produto, b.nom_produto
        FROM movimento_estoque a
        RIGHT JOIN produto b ON b.cod_produto = a.cod_produto
            AND a.dat_movimento_estoque >= ADD_MONTHS(SYSDATE, -6)
        WHERE a.cod_produto IS NULL
        ORDER BY b.cod_produto
    ) LOOP
        v_total_produtos := v_total_produtos + 1;
        dbms_output.put_line('Código: ' || i.cod_produto || ' | Nome: ' || i.nom_produto);
    END LOOP;

    IF v_total_produtos = 0 THEN
        RAISE me_erro;
    END IF;

EXCEPTION
    WHEN me_erro THEN
        dbms_output.put_line('Não existem produtos sem movimentação nos últimos 6 meses.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || SQLERRM);
END;

SET SERVEROUTPUT ON;
CALL sp_valida_produtos_sem_movimento(); -- trás todos os produtos porque todos eles tiveram a última movimentação em 03/05/24

-- Ex 3 - Cursor que lista todos os produtos com mais de 100 unidades movimentadas no total

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_mov_produtos IS
        SELECT a.cod_produto, a.nom_produto, SUM(b.qtd_movimentacao_estoque) AS total_movimentacao
        FROM produto a
        JOIN movimento_estoque b ON a.cod_produto = b.cod_produto
        GROUP BY a.cod_produto, a.nom_produto;
BEGIN
    FOR i IN c_mov_produtos LOOP
        IF i.total_movimentacao > 100 THEN

            dbms_output.put_line('Produto: ' || i.cod_produto);
            dbms_output.put_line('Nome: ' || i.nom_produto);
            dbms_output.put_line('Unidades movimentadas: ' || i.total_movimentacao);
            dbms_output.put_line('----------------------------------------');
        END IF;
    END LOOP;
END;

-- Ex 4 - Procedure que retorna a quantidade total de movimentos associados ao produto
CREATE OR REPLACE PROCEDURE sp_qtd_movimentos_produto(
    p_cod_produto IN NUMBER,
    p_total OUT NUMBER
) IS
BEGIN
    p_total := 0;

    SELECT SUM(a.qtd_movimentacao_estoque)
    INTO p_total
    FROM movimento_estoque a
    WHERE a.cod_produto = p_cod_produto;

    IF p_total IS NULL THEN
        p_total := 0;
    END IF;
    dbms_output.put_line('Produto: ' || p_cod_produto || ' | Total de movimentações: ' || p_total);
END;

-- Testando - usamos esse formato pois ele espera um parâmetro de saída (out)
SET SERVEROUTPUT ON;
DECLARE
    v_total NUMBER;
BEGIN
    sp_qtd_movimentos_produto(5, v_total);
END;

-- Ex 5 - atualize todos os produtos da categoria e de uma categoria específica, apenas se sua movimentação total for inferior a 50 unidades. Use cursor + LOOP com UPDATE.

CREATE OR REPLACE PROCEDURE atualizar_categoria_simulada IS

  CURSOR c_produtos IS
    SELECT cod_produto, nom_produto, cod_barra
    FROM produto
    WHERE nom_produto = 'Mouse'; -- simulando categoria
  v_total_movimentacao NUMBER;

BEGIN
  FOR p IN c_produtos LOOP

    SELECT NVL(SUM(ABS(mv.qtd_movimentacao_estoque)), 0)
    INTO v_total_movimentacao
    FROM movimento_estoque mv
    WHERE mv.cod_produto = p.cod_produto;

    IF v_total_movimentacao < 50 THEN
      UPDATE produto
      SET cod_barra = SUBSTR(cod_barra || '_ATLD', 1, 20)
      WHERE cod_produto = p.cod_produto;

      dbms_output.put_line('Produto atualizado: ' || p.nom_produto || 
                           ' | Novo cod_barra: ' || SUBSTR(p.cod_barra || '_ATLD', 1, 20));
    END IF;
  END LOOP;
  COMMIT;
END;

SET SERVEROUTPUT ON;
CALL atualizar_categoria_simulada();

-- Ex 6 - crie uma procedure que para cada produto, busque as datas e quantidades dos movimentos

CREATE OR REPLACE PROCEDURE p_historico_produtos IS
  -- Cursor externo: percorre os produtos
  CURSOR c_produtos IS
    SELECT cod_produto, nom_produto
    FROM produto;

  -- Cursor interno: pega as movimentacoes para um produto especifico
  CURSOR c_movimentacoes(p_cod_produto produto.cod_produto%TYPE) IS
    SELECT 
      mv.dat_movimento_estoque,
      tme.des_tipo_movimento_estoque,
      mv.qtd_movimentacao_estoque
    FROM 
      movimento_estoque mv
    JOIN 
      tipo_movimento_estoque tme ON mv.cod_tipo_movimento_estoque = tme.cod_tipo_movimento_estoque
    WHERE 
      mv.cod_produto = p_cod_produto
    ORDER BY 
      mv.dat_movimento_estoque;

BEGIN
  -- Loop pelos produtos
  FOR prod IN c_produtos LOOP
    dbms_output.put_line(' -------------------------------------------------------------- ');
    dbms_output.put_line('Produto: ' || prod.nom_produto);

    -- Loop pelas movimentacoes do produto atual
    FOR mov IN c_movimentacoes(prod.cod_produto) LOOP
      dbms_output.put_line('-> ' || mov.dat_movimento_estoque || 
                           ' | ' || mov.des_tipo_movimento_estoque || ': ' || mov.qtd_movimentacao_estoque);
                           
    END LOOP;
  END LOOP;
END;

CALL p_historico_produtos();

-- Ex 7 - crie `sp_relatorio_geral_movimento` que exiba o total movimentado por tipo de movimento (entrada/saída), inclusive aqueles sem registro associado (produto ou tipo). Use GROUP BY.

CREATE OR REPLACE PROCEDURE sp_relatorio_geral_movimento IS
BEGIN
  FOR i IN (
    SELECT 
      tme.des_tipo_movimento_estoque,
      NVL(SUM(mv.qtd_movimentacao_estoque), 0) AS total_movimentado
    FROM 
      tipo_movimento_estoque tme
    LEFT JOIN 
      movimento_estoque mv 
      ON mv.cod_tipo_movimento_estoque = tme.cod_tipo_movimento_estoque
    GROUP BY 
      tme.des_tipo_movimento_estoque
  ) LOOP
    dbms_output.put_line('Tipo de Movimento: ' || i.des_tipo_movimento_estoque ||
                         ' | Total: ' || i.total_movimentado);
  END LOOP;
END;

CALL sp_relatorio_geral_movimento();

-- Ex 8 - bloco anônimo que tenta inserir um novo produto já existente e capture o erro ORA-00001

DECLARE
    v_cod_produto PRODUTO.COD_PRODUTO%TYPE := 1;
    v_nome PRODUTO.NOM_PRODUTO%TYPE := 'Teclado Gamer';
    v_cod_barra PRODUTO.COD_BARRA%TYPE := '9012345678950';
BEGIN
    INSERT INTO PRODUTO (COD_PRODUTO, NOM_PRODUTO, COD_BARRA)
    VALUES (v_cod_produto, v_nome, v_cod_barra);
    
    COMMIT;
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('ERRO! Produto com código ' || v_cod_produto || ' Já existe.');
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
        
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Erro desconhecido: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
END;

-- Ex 9 - exclui movimentações com mais de 2 anos, mas faz rollback se a quantidade de registros excluídos ultrapassar 1000. 
CREATE OR REPLACE PROCEDURE sp_limpa_movimentos_antigos IS
    v_qtd       NUMBER;
BEGIN
    SELECT
        COUNT(seq_movimento_estoque)
    INTO
        v_qtd
    FROM
        movimento_estoque
    WHERE
        dat_movimento_estoque < add_months(sysdate, -24);

    IF v_qtd > 1000 THEN
        dbms_output.put_line('Operação de limpeza cancelada');
        dbms_output.put_line(v_qtd ||' registros seriam apagados');
        ROLLBACK;
    ELSE
        DELETE FROM movimento_estoque
        WHERE
            dat_movimento_estoque < add_months(sysdate, -24);

        COMMIT;
        dbms_output.put_line('Quantidade de registros antigos deletados: ' || v_qtd);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001,'Erro durante a exclusão: ' || sqlerrm);
        ROLLBACK;
END;

EXEC sp_limpa_movimentos_antigos;


-- Ex 10 -  função `fn_previsao_movimentacao(p_cod_produto NUMBER) ` que, com base na média de movimentações nos últimos 3 meses, retorna uma previsão da movimentação esperada para o próximo mês.
CREATE OR REPLACE FUNCTION fnc_previsao_movimentacao(
    p_cod_produto NUMBER
) RETURN NUMBER AS
    v_avg NUMBER;
BEGIN
    SELECT AVG(ABS(QTD_MOVIMENTACAO_ESTOQUE)) INTO v_avg
    FROM movimento_estoque
    WHERE 
        cod_produto = p_cod_produto 
    AND dat_movimento_estoque >= ADD_MONTHS(SYSDATE, -3)
    AND dat_movimento_estoque <= SYSDATE;
    RETURN NVL(ROUND(v_avg),0);
    
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20001, 'Erro desconhecido: ' || SQLERRM);
END;

SELECT fnc_previsao_movimentacao(1) AS PREVISAO_DE_MOVIMENTACAO FROM dual;