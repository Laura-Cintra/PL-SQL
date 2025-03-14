-- Laura de Oliveira Cintra
-- RM558843

SET SERVEROUTPUT ON;

-- 1. Crie um bloco an�nimo que calcula o total de movimenta��es de estoque para um determinado produto.

DECLARE
    v_movimentacoes NUMBER;
    v_cod_prod NUMBER := 16; -- &cod_produto
BEGIN
    SELECT SUM(qtd_movimentacao_estoque)INTO v_movimentacoes
    FROM movimento_estoque
    WHERE cod_produto = v_cod_prod;
    dbms_output.put_line('Produto: ' || v_cod_prod || ' | Total de Movimenta��es: ' || v_movimentacoes);
END;

-- 2. Utilizando FOR crie um bloco an�nimo que calcula a m�dia de valores totais de pedidos para um cliente espec�fico.

DECLARE
    v_total_pedidos NUMBER := 0;
    v_quant_prod NUMBER := 0;
    v_cod_cliente NUMBER := 88; -- $cod_cliente
BEGIN
    SELECT COUNT(1) INTO v_quant_prod
    FROM pedido
    WHERE cod_cliente = v_cod_cliente;

    FOR i IN (SELECT val_total_pedido FROM pedido WHERE cod_cliente = v_cod_cliente) LOOP
        v_total_pedidos := v_total_pedidos + i.val_total_pedido;
    END LOOP;
    dbms_output.put_line('Cliente: ' || v_cod_cliente || ' | Quant.Pedidos: ' || v_quant_prod || ' | M�dia de valores R$' || ROUND(v_total_pedidos / v_quant_prod));
END;

-- 3. Crie um bloco an�nimo que exiba os produtos compostos ativos

BEGIN
    FOR i IN (SELECT cod_produto_relacionado, cod_produto FROM produto_composto WHERE sta_ativo = 'S'
    ) LOOP
        dbms_output.put_line('Produto Composto: ' || i.cod_produto_relacionado || ' | Produto: ' || i.cod_produto);
    END LOOP;
END;

-- 4. Crie um bloco an�nimo para calcular o total de movimenta��es de estoque para um determinado produto usando INNER JOIN com a tabela de tipo_movimento_estoque.

DECLARE
    v_total_movimentacoes NUMBER := 0;
    v_cod_prod NUMBER := 16;
BEGIN
    SELECT SUM(qtd_movimentacao_estoque)
    INTO v_total_movimentacoes
    FROM movimento_estoque
    INNER JOIN tipo_movimento_estoque ON movimento_estoque.cod_tipo_movimento_estoque = tipo_movimento_estoque.cod_tipo_movimento_estoque
    WHERE movimento_estoque.cod_produto = v_cod_prod;

    dbms_output.put_line('Produto: ' || v_cod_prod || ' | Total de Movimenta��es: ' || v_total_movimentacoes);
END;

-- 5. Crie um bloco an�nimo para exibir os produtos compostos e, se houver, suas informa��es de estoque, usando LEFT JOIN com a tabela estoque_produto.

BEGIN
    FOR i IN (
        SELECT tbl_pc.cod_produto, tbl_ep.qtd_produto FROM produto_composto tbl_pc LEFT JOIN estoque_produto tbl_ep ON tbl_pc.cod_produto = tbl_ep.cod_produto) LOOP
        IF i.qtd_produto IS NULL THEN
            i.qtd_produto := 0;
        END IF;
        dbms_output.put_line('Produto Composto: ' || i.cod_produto || ' | Estoque: ' || i.qtd_produto);
    END LOOP;
END;

-- 6. Crie um bloco que exiba as informa��es de pedidos e, se houver, as informa��es dos clientes relacionados usando RIGHT JOIN com a tabela cliente.

-- 7. Crie um bloco que calcule a m�dia de valores totais de pedidos para um cliente espec�fico e exibe as informa��es do cliente usando INNER JOIN com a tabela cliente.