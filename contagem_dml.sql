SELECT * FROM vendas;

-- 1. Criar um bloco para trazer a quantidade de pedidos por país

set serveroutput on;

DECLARE
    v_pedidos NUMBER;
    v_pais    VARCHAR2(30);
    v_quant   NUMBER;
BEGIN
    SELECT COUNT(1), country INTO v_pedidos, v_pais, v_quant FROM vendas WHERE country = 'France' GROUP BY country;
--  SELECT COUNT(1), SUM (quantityordered) country INTO v_pedidos, v_pais FROM vendas WHERE country = 'France' GROUP BY country;
    dbms_output.put_line('A quantidade de pedidos do país ' || v_pais || ' é ' || v_pedidos);
END;

-- Quantidade de produtos por pedido do país

DECLARE
    v_pedidos NUMBER;
    v_pais    VARCHAR2(30);
    v_quant   NUMBER;
BEGIN
    SELECT COUNT(1), SUM (quantityordered), country INTO v_pedidos, v_quant, v_pais FROM vendas WHERE country = 'France' GROUP BY country;
    dbms_output.put_line('A quantidade de pedidos do país ' || v_pais || ' é ' || v_pedidos || ' e a quantidade de produtos ' || v_quant);
END;