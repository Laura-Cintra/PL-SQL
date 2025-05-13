-- === Cursores ===
-- Implícito: select
-- permitem que um comando SELECT possa retornar múltiplas linhas e as mesmas possam ser tratadas uma a uma pelo bloco PL/SQL
-- o BD tem uma área específica para instanciar os cursores

CREATE TABLE HISTORICO(
    cod_produto NUMBER,
    nome_produto VARCHAR2(50),
    data_movimentacao DATE
);

-- Explícito
-- cursor, nome do cursor, is, consulta que preciso
DECLARE
        -- herdando da tabela que tá pegando o dado, o dado será o mesmo tipo do dado da tabela
  v_codigo PRODUTO.cod_produto%type := 12349;
  cursor cur_emp IS
    SELECT nom_produto FROM produto WHERE cod_produto = v_codigo;
BEGIN
  FOR x IN cur_emp LOOP
    INSERT into HISTORICO VALUES (v_codigo, x.nom_produto, sysdate);
    COMMIT;
  END LOOP;
END;

-- Exemplo rowid 
SELECT rowid, x.* FROM cliente x;

/*
1) Fazer um bloco anônimo com cursor que realize uma consulta na tabela de clientes e retorne o código  e o nome do cliente, use dbms_output para mostrar as informações como o exemplo abaixo:
    Cliente: 1  Nome: Jose da Silva
    Cliente: 2  Nome: Maria  da Silva
*/
SET SERVEROUTPUT ON;

DECLARE
  cursor c_consulta_cliente IS
    SELECT cod_cliente, nom_cliente FROM cliente;
BEGIN
  FOR x IN c_consulta_cliente LOOP
    dbms_output.put_line('Cliente: ' || x.cod_cliente || ' | Nome: ' ||
                         x.nom_cliente);
    END LOOP;
END;

-- logradouro pode ter tbl tipo_logadrouro --> avenida, rua, praça