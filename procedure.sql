-- hardcore insert - na mão
INSERT INTO PAIS VALUES (18, 'Coreia do Sul');
COMMIT;

SELECT * FROM PAIS;

SET SERVEROUTPUT ON;

-- Transforme esse insert em um bloco anônimo utilizando variáveis

-- criando um objeto do tipo procedure para insert
CREATE OR REPLACE PROCEDURE prd_insert_pais(
    p_cod NUMBER,
    p_nome VARCHAR2
) AS
BEGIN
    INSERT INTO pais VALUES (
        p_cod,
        p_nome
    );
    COMMIT;
END;

-- Executando a procedure
CALL prd_insert_pais(); -- JAVA, PYTHON
EXEC prd_insert_pais(); -- JAVA
EXECUTE prd_insert_pais(); -- PYTHON, .NET

-- JAVA, .NET
BEGIN
    prd_insert_pais();
END;

CALL prd_insert_pais(19, 'Jamaica');

-- procedure para update
CREATE OR REPLACE PROCEDURE prd_update_pais(
    p_cod NUMBER,
    p_nome VARCHAR2
) AS
BEGIN
    UPDATE pais SET nom_pais = p_nome WHERE cod_pais = p_cod;
    COMMIT;
END;

CALL prd_delete_pais(19, 'Jamaicaa');

-- procedure para delete
CREATE OR REPLACE PROCEDURE prd_delete_pais(
    p_cod NUMBER
) AS
BEGIN
    DELETE FROM pais WHERE cod_pais = p_cod;
    COMMIT;
END;

CALL prd_delete_pais(19);

-- Crie uma procedure que informe o código do cliente e ela retorne as seguintes informações: 
-- nome do cliente, cod do produto, cod do pedido, nome do produto, total por pedidos

CREATE OR REPLACE PROCEDURE prd_info_pedidos_cliente(
    p_cod_cliente NUMBER
) AS 
BEGIN

FOR i IN(
    SELECT
    b.nom_cliente,
    a.cod_pedido,
    c.cod_produto,
    d.nom_produto,
    SUM(a.val_total_pedido) "Total Pedido",
    MAX(dat_pedido) "Data pedido"
    
    FROM pedido a 
    INNER JOIN cliente b on (a.cod_cliente = b.cod_cliente)
    JOIN item_pedido c on (a.cod_pedido = c.cod_pedido)
    JOIN produto d on(c.cod_produto = d.cod_produto)
    WHERE a.cod_pedido = p_cod_cliente
    
    GROUP BY b.nom_cliente,
    a.cod_pedido,
    c.cod_produto,
    d.nom_produto
    ) LOOP
    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('Nome Cliente: ' || i.nom_cliente);
    dbms_output.put_line('Código Produto: ' || i.cod_produto);
    dbms_output.put_line('Nome Produto: ' || i.nom_produto);
    dbms_output.put_line('Total por Pedidos: ' || i);
    END LOOP;
END;