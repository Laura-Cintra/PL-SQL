-- Laura de Oliveira Cintra
-- RM558843

SET SERVEROUTPUT ON;

-- 1. Crie um bloco anônimo que calcula o total de movimentações de estoque para um determinado produto.

DECLARE
    v_movimentacoes NUMBER;
    v_cod_prod NUMBER := 16; -- &cod_produto
BEGIN
    SELECT SUM(qtd_movimentacao_estoque)INTO v_movimentacoes
    FROM movimento_estoque
    WHERE cod_produto = v_cod_prod;
    dbms_output.put_line('Produto: ' || v_cod_prod || ' | Movimentações: ' || v_movimentacoes);
END;

-- 2. Utilizando FOR crie um bloco anônimo que calcula a média de valores totais de pedidos para um cliente específico.

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
    dbms_output.put_line('Cliente: ' || v_cod_cliente || ' | Quant.Pedidos: ' || v_quant_prod || ' | Média de valores R$' || TRUNC(v_total_pedidos / v_quant_prod));
END;

-- 3. Crie um bloco anônimo que exiba os produtos compostos ativos

-- 4. Crie um bloco anônimo para calcular o total de movimentações de estoque para um determinado produto usando INNER JOIN com a tabela de tipo_movimento_estoque.

-- 5. Crie um bloco anônimo para exibir os produtos compostos e, se houver, suas informações de estoque, usando LEFT JOIN com a tabela estoque_produto.

-- 6. Crie um bloco que exiba as informações de pedidos e, se houver, as informações dos clientes relacionados usando RIGHT JOIN com a tabela cliente.

-- 7. Crie um bloco que calcule a média de valores totais de pedidos para um cliente específico e exibe as informações do cliente usando INNER JOIN com a tabela cliente.
