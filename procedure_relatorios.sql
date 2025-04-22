-- Laura de Oliveira Cintra
-- RM558843
-- 2TDSPK
 
SET SERVEROUTPUT ON;
 
-- Ex 1
CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    p_cod_pedido NUMBER
) RETURN NUMBER IS
    v_desconto NUMBER;
    error_not_found EXCEPTION;
BEGIN
    SELECT
        ( SUM(val_desconto_item) ) / 100
    INTO v_desconto
    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = p_cod_pedido;
 
    IF ( v_desconto IS NULL ) THEN
        RAISE error_not_found;
    END IF;
    RETURN ROUND(v_desconto, 2);
EXCEPTION
    WHEN error_not_found THEN
        raise_application_error(-20045, 'Erro: Produto não existe!');
    WHEN zero_divide THEN
        raise_application_error(-20001, 'Erro: Divisão por zero');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END fnc_percentual_desconto;
 
SELECT fnc_percentual_desconto(130506) FROM dual;
 
-- Ex 2
CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido 
RETURN NUMBER IS
    v_total_itens NUMBER;
    v_total_pedidos NUMBER;
    v_media NUMBER;
    division_by_zero EXCEPTION;
BEGIN
    SELECT 
        SUM(a.qtd_item),
        COUNT(DISTINCT a.cod_pedido)
    INTO 
        v_total_itens, 
        v_total_pedidos
    FROM 
        item_pedido a
        INNER JOIN historico_pedido b ON a.cod_pedido = b.cod_pedido;
 
    IF v_total_pedidos = 0 THEN
        RAISE division_by_zero;
    END IF;
 
    v_media := ROUND(v_total_itens / v_total_pedidos, 2);
    RETURN v_media;
 
EXCEPTION
    WHEN division_by_zero THEN
        raise_application_error(-20046, 'Erro: Divisão por zero');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END fnc_media_itens_por_pedido;
 
SELECT fnc_media_itens_por_pedido FROM dual;
 
-- Ex 3
CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto (
    p_cod_produto NUMBER
) IS
    v_total_unidades NUMBER;
    v_data_mov       DATE;
    error_not_found  EXCEPTION;
BEGIN
    SELECT 
        SUM(a.qtd_movimentacao_estoque),
        MAX(a.dat_movimento_estoque)
    INTO 
        v_total_unidades,
        v_data_mov
    FROM 
        movimento_estoque a
        LEFT JOIN produto_composto b ON a.cod_produto = b.cod_produto
    WHERE 
        a.cod_produto = p_cod_produto;
 
    IF v_total_unidades IS NULL AND v_data_mov IS NULL THEN
        RAISE error_not_found;
    END IF;
    dbms_output.put_line('Código Produto: ' || p_cod_produto);
    dbms_output.put_line('Total de unidades movimentadas: ' || v_total_unidades);
    dbms_output.put_line('Última movimentação: ' || v_data_mov);
 
EXCEPTION
    WHEN error_not_found THEN
        dbms_output.put_line('Nenhuma movimentação encontrada para o produto');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;
 
CALL prc_relatorio_estoque_produto(25);
 
-- Ex 4
CREATE OR REPLACE PROCEDURE prc_relatorio_composicao_ativa (
p_cod_produto NUMBER
) AS
BEGIN
    FOR i IN (
        SELECT
            a.cod_produto_relacionado,
            a.qtd_produto_relacionado,
            SUM(b.qtd_movimentacao_estoque) AS total_movimentado,
            MAX(b.dat_movimento_estoque) AS ultima_movimentacao
        FROM
            produto_composto a
            JOIN movimento_estoque b
                ON a.cod_produto_relacionado = b.cod_produto
        WHERE
            a.cod_produto = p_cod_produto
            AND a.sta_ativo = 'S'
        GROUP BY
            a.cod_produto_relacionado,
            a.qtd_produto_relacionado
        ORDER BY
            a.cod_produto_relacionado
    ) LOOP
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('Produto: ' || p_cod_produto);
        dbms_output.put_line('Produto Composto: ' || i.cod_produto_relacionado);
        dbms_output.put_line('Quantidade na Composição: ' || i.qtd_produto_relacionado);
        dbms_output.put_line('Total Movimentado: ' || i.total_movimentado);
        dbms_output.put_line('Última Movimentação: ' || i.ultima_movimentacao);
    END LOOP;
 
EXCEPTION
    WHEN program_error THEN
            raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END prc_relatorio_composicao_ativa;
 
CALL prc_relatorio_composicao_ativa(25);

-- Ex 5
SELECT a.val_total_pedido, a.val_desconto, a.status FROM pedido a WHERE a.cod_pedido = 131232;
-- processando, pendente, concluído

CREATE OR REPLACE PROCEDURE prc_relatorio_pedido (
    p_cod_pedido NUMBER
) IS
    v_status VARCHAR2(20);
    error_not_found EXCEPTION;
    v_encontrou_pedido BOOLEAN := FALSE;
BEGIN
    FOR i IN (
        SELECT 
            a.val_total_pedido,
            a.val_desconto,
            a.status,
            b.cod_item_pedido
        FROM
            pedido a 
            JOIN item_pedido b ON a.cod_pedido = b.cod_pedido 
        WHERE 
            a.cod_pedido = p_cod_pedido
    ) LOOP
        v_encontrou_pedido := TRUE;
        IF LOWER(i.status) IN ('pendente', 'processando') THEN
            v_status := 'PENDENTE';
        ELSE
            v_status := 'ENTREGUE';
        END IF;
        dbms_output.put_line('Código item pedido: ' || i.cod_item_pedido);
        dbms_output.put_line('Código do pedido: ' || p_cod_pedido);
        dbms_output.put_line('Valor total: ' || i.val_total_pedido);
        dbms_output.put_line('Valor do desconto: ' || i.val_desconto);
        dbms_output.put_line('Status: ' || v_status);
        dbms_output.put_line('-----------------------------------------------');
    END LOOP;
    IF NOT v_encontrou_pedido THEN
        RAISE error_not_found;
    END IF;
EXCEPTION
    WHEN error_not_found THEN
        raise_application_error(-20046, 'Erro: o pedido não existe ou não possui itens');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

CALL prc_relatorio_pedido(130506);