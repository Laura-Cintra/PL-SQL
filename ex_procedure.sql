-- Laura de Oliveira Cintra
-- RM558843
-- 2TDSPK

SET SERVEROUTPUT ON;

-- 1.
CREATE OR REPLACE PROCEDURE prd_listar_pedidos_cliente(
    p_cod_cliente NUMBER
) AS 
BEGIN

FOR i IN(
    SELECT
    a.cod_pedido,
    a.dat_pedido,
    (a.val_total_pedido - a.val_desconto) "Total Produto"
    
    FROM pedido a 
    INNER JOIN cliente b on (a.cod_cliente = b.cod_cliente)
    WHERE a.cod_cliente = p_cod_cliente  
    
    ORDER BY a.cod_pedido
    ) LOOP
    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('Número do Pedido: ' || i.cod_pedido);
    dbms_output.put_line('Data do Pedido: ' || i.dat_pedido);
    dbms_output.put_line('Total do Pedido: ' || i."Total Produto");
    END LOOP;
END;

CALL prd_listar_pedidos_cliente(67);

-- 2.
CREATE OR REPLACE PROCEDURE prd_listar_itens_pedido(
    p_cod_pedido NUMBER
) AS 
BEGIN

FOR i IN(
    SELECT
    b.cod_item_pedido,
    b.qtd_item,
    c.nom_produto
    
    FROM pedido a 
    JOIN item_pedido b on (a.cod_pedido = b.cod_pedido)
    JOIN produto c on(b.cod_produto = c.cod_produto)
    WHERE a.cod_pedido = p_cod_pedido
    
    ORDER BY a.cod_pedido
    ) LOOP
    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('Código do Item: ' || i.cod_item_pedido);
    dbms_output.put_line('Nome Produto: ' || i.nom_produto);
    dbms_output.put_line('Quantidade: ' || i.qtd_item);
    END LOOP;
END;

CALL prd_listar_itens_pedido(131232);

-- 3.
CREATE OR REPLACE PROCEDURE prd_listar_movimentos_estoque_produto(
    p_cod_produto NUMBER
) AS 
BEGIN

FOR i IN(
    SELECT
    a.seq_movimento_estoque,
    a.cod_produto,
    a.dat_movimento_estoque,
    b.des_tipo_movimento_estoque
    
    FROM movimento_estoque a 
    JOIN tipo_movimento_estoque b on (a.cod_tipo_movimento_estoque = b.cod_tipo_movimento_estoque)
    WHERE a.cod_produto = p_cod_produto
    
    ORDER BY a.cod_produto
    ) LOOP
    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('Produto: ' || i.cod_produto);
    dbms_output.put_line('Código do Movimento: ' || i.seq_movimento_estoque);
    dbms_output.put_line('Data do Movimento: ' || i.dat_movimento_estoque);
    dbms_output.put_line('Tipo Movimento: ' || i.des_tipo_movimento_estoque);
    END LOOP;
END;

CALL prd_listar_movimentos_estoque_produto(8);

-- 4.
CREATE OR REPLACE PROCEDURE prc_insere_produto(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE
) AS
BEGIN
    IF LENGTH(p_nome) > 3 AND REGEXP_LIKE(p_nome, '[^0-9]') THEN
    INSERT INTO produto VALUES (
        p_cod,
        p_nome,
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
    END IF;
    COMMIT;
END;

CALL prc_insere_produto(57, 'Processador', 5678905734567, 'Ativo', SYSDATE);

-- 5.
CREATE OR REPLACE PROCEDURE prc_insere_cliente(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
BEGIN
    IF LENGTH(p_nom_cliente_des_razao) > 3 AND REGEXP_LIKE(p_nom_cliente_des_razao, '[^0-9]') THEN
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
            COMMIT;
        END IF;
    END IF;
END;

CALL prc_insere_cliente(152, 'Clínica dos Olhos', 'J', 34567892300489, SYSDATE, 'S');

SELECT * FROM CLIENTE;