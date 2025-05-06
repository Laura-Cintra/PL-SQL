-- Laura de Oliveira Cintra
-- RM558843
-- 2TDSPK

-- Ex 1
CREATE OR REPLACE FUNCTION fnc_valor_total_pedidos_por_estado  (
    p_uf VARCHAR2
) RETURN NUMBER IS
    v_total_pedidos NUMBER;
BEGIN
    SELECT SUM(b.val_total_pedido) as valor_total_pedido
    INTO v_total_pedidos
    FROM pedido a 
    INNER JOIN historico_pedido b ON ( a.cod_pedido = b.cod_pedido)
    INNER JOIN endereco_cliente c ON ( a.cod_cliente = c.cod_cliente )
    INNER JOIN cidade d ON ( c.cod_cidade = d.cod_cidade )
    INNER JOIN estado e ON ( d.cod_estado = e.cod_estado )
    WHERE e.nom_estado = p_uf AND a.dat_entrega IS NOT NULL;
    
    RETURN ROUND(v_total_pedidos, 2);
END fnc_valor_total_pedidos_por_estado;

SELECT fnc_valor_total_pedidos_por_estado('Alagoas') FROM dual;

-- Ex 2
CREATE OR REPLACE FUNCTION fnc_qtd_itens_em_pedidos_por_produto  (
    p_cod_produto NUMBER
) RETURN NUMBER IS
    v_total_itens NUMBER;
BEGIN
    SELECT SUM(b.qtd_item) 
    INTO v_total_itens
    FROM produto a
    INNER JOIN item_pedido b ON ( a.cod_produto = b.cod_produto)
    INNER JOIN pedido c ON ( b.cod_pedido = c.cod_pedido)
    WHERE a.cod_produto = p_cod_produto;
    
    RETURN v_total_itens;
END fnc_qtd_itens_em_pedidos_por_produto;

SELECT fnc_qtd_itens_em_pedidos_por_produto(33) FROM dual;

-- Ex 3
CREATE OR REPLACE PROCEDURE prc_relatorio_pedidos_por_cliente
IS
    v_pedido_cancelado VARCHAR2(30);
    me_error EXCEPTION;
BEGIN
    FOR i IN (
       SELECT 
          a.nom_cliente, 
          d.nom_cidade, 
          COUNT(1) as quant_pedidos_realizados, 
          SUM(b.val_total_pedido - b.val_desconto) as valor_total_comprado, 
          b.dat_cancelamento
        FROM 
            cliente a
            LEFT JOIN pedido b ON (a.cod_cliente = b.cod_cliente)
            JOIN endereco_cliente c ON (a.cod_cliente = c.cod_cliente)
            JOIN cidade d ON (c.cod_cidade = d.cod_cidade)
        
        GROUP BY a.nom_cliente, d.nom_cidade, b.dat_cancelamento
    ) LOOP
        IF i.dat_cancelamento IS NULL THEN 
            v_pedido_cancelado := 'Não';
        ELSE
            v_pedido_cancelado := 'Sim';
        END IF;
        
        IF i.nom_cidade IS NULL THEN
            RAISE me_error;
        END IF;
        
        dbms_output.put_line('Nome cliente: ' || i.nom_cliente);
        dbms_output.put_line('Cidade cliente: ' || i.nom_cidade);
        dbms_output.put_line('Quantidade de Pedidos: ' || i.quant_pedidos_realizados);
        dbms_output.put_line('Valor total comprado: ' || i.valor_total_comprado);
        dbms_output.put_line('Cancelado? ' || v_pedido_cancelado);
        dbms_output.put_line('-----------------------------------------------');
    END LOOP;
EXCEPTION
    WHEN me_error THEN
        raise_application_error(-20046, 'Erro: o cliente não tem cidade associada');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

SET SERVEROUTPUT ON;
CALL prc_relatorio_pedidos_por_cliente();

-- Ex 4
CREATE OR REPLACE PROCEDURE prc_movimentacao_produto_por_vendedor
IS
    v_vendas VARCHAR2(30);
    me_error EXCEPTION;
BEGIN
    FOR i IN (
       SELECT 
          a.nom_vendedor,
          COUNT(1) as quant_produtos_vendidos,
          ROUND(SUM(b.val_total_pedido - b.val_desconto),2) as quant_total
        FROM 
            vendedor a
            RIGHT JOIN pedido b ON (a.cod_vendedor = b.cod_vendedor)
            JOIN item_pedido c ON (b.cod_pedido = c.cod_pedido)
            JOIN produto d ON (c.cod_produto = d.cod_produto)
        
        GROUP BY a.nom_vendedor
    ) LOOP
        IF i.quant_produtos_vendidos = 0 THEN 
            v_vendas := 'Sem vendas registradas';
        ELSE
            v_vendas := 'Vendas registradas';
        END IF;
        
        dbms_output.put_line('Vendedor: ' || i.nom_vendedor);
        dbms_output.put_line('Produtos Vendidos: ' || i.quant_produtos_vendidos);
        dbms_output.put_line('Valor total das vendas: ' || i.quant_total);
        dbms_output.put_line('Vendas registradas? ' || v_vendas);
        dbms_output.put_line('-----------------------------------------------');
    END LOOP;
EXCEPTION
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

SET SERVEROUTPUT ON;
CALL prc_movimentacao_produto_por_vendedor();

-- Ex 5
CREATE OR REPLACE PROCEDURE prc_analise_vendas_por_vendedor(
    p_cod_vendedor NUMBER
)
AS
    v_compras VARCHAR2(50);
    me_error EXCEPTION;
BEGIN
    FOR i IN (
       SELECT 
          a.nom_vendedor,
          e.nom_cliente,
          d.nom_produto,
          COUNT(1) as quant_total_comprada
        FROM 
            vendedor a
            RIGHT JOIN pedido b ON (a.cod_vendedor = b.cod_vendedor)
            JOIN item_pedido c ON (b.cod_pedido = c.cod_pedido)
            JOIN produto d ON (c.cod_produto = d.cod_produto)
            JOIN cliente e ON (b.cod_cliente = e.cod_cliente)
        
        WHERE a.cod_vendedor = p_cod_vendedor
        
        GROUP BY a.nom_vendedor, e.nom_cliente, d.nom_produto
    ) LOOP
        IF i.quant_total_comprada >= 50 THEN 
            v_compras := 'CLIENTE RECORRENTE';
        ELSIF i.quant_total_comprada > 11 AND i.quant_total_comprada < 50 THEN
            v_compras := 'CLIENTE RECORRENTEL';
        ELSIF i.quant_total_comprada > 1 AND i.quant_total_comprada < 11 THEN
            v_compras := 'CLIENTE OCASIONAL';
        ELSE
            v_compras := 'NENHUMA COMPRA REGISTRADA';
        END IF;
        
        dbms_output.put_line('Vendedor: ' || i.nom_vendedor);
        dbms_output.put_line('Nome cliente: ' || i.nom_cliente);
        dbms_output.put_line('Nome produto: ' || i.nom_produto);
        dbms_output.put_line('Quantidade total comprada: ' || i.quant_total_comprada);
        dbms_output.put_line('Status cliente ' || v_compras);
        dbms_output.put_line('-----------------------------------------------');
    END LOOP;
EXCEPTION
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

SET SERVEROUTPUT ON;
CALL prc_analise_vendas_por_vendedor();

SELECT * FROM vendedor;
SELECT * FROM pedido;
SELECT * FROM item_pedido;
SELECT * FROM produto;
SELECT * FROM cliente;

-- nome cliente, nome produto adquirido, quantidade total comprada

SELECT * FROM historico_pedido;
SELECT * FROM endereco_cliente;
SELECT * FROM cidade;
SELECT * FROM estado;
SELECT * FROM cliente;