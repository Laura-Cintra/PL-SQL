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
    
    RETURN v_desconto;
    
EXCEPTION
    WHEN error_not_found THEN
        raise_application_error(-20045, 'Produto não existe!');
END fnc_percentual_desconto;

SELECT fnc_percentual_desconto(130506) FROM dual;

-- Ex 2
