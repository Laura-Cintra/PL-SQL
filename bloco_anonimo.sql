-- Bloco an�nimo - estrutura de c�digo que n�o salva em nenhum lugar, fica na IDE

-- serve para imprimir na tela
SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    nome  VARCHAR2(30) := 'VERGS';
    ende   VARCHAR2(50) := '&ENDERECO'; -- & cria uma caixa de texto
BEGIN
    idade := 39; -- atribuindo valor � vari�vel
    dbms_output.put_line('A IDADE INFORMADA � : ' || idade);
    dbms_output.put_line('O NOME INFORMADO � : ' || nome); -- || concatenando o valor
    dbms_output.put_line('O ENDERE�O INFORMADO � : ' || ende);
END;

-- EXERC�CIOS

-- 1. Criar um bloco PL_SQL para calcular o valor do novo sal�rio m�nimo que dever� ser de 25% em cima do autal, que � de R$???

DECLARE
    salario NUMBER;
    novo_salario NUMBER;
BEGIN
    salario :=  1518;
     novo_salario := 1.25 * salario;
    dbms_output.put_line('Novo sal�rio m�nimo: R$' || novo_salario);
END;

-- prof

DECLARE
    salario FLOAT;
BEGIN
    salario :=  1518;
    dbms_output.put_line('Novo sal�rio m�nimo: R$' || 1.25 * salario);
END;

-- 2. Criar um bloco PL_SQL para calcular o valor em reais de 45 d�lares, sendo que o valor do c�mbio a ser considerado � de R$???

DECLARE
    dolar NUMBER := 5.70;
BEGIN
    dbms_output.put_line('US$45 � igual a R$' || 45 * dolar);
END;

-- 3. Criar um bloco PL_SQL para calcular o valor das parcelas de uma compra de um carro, nas seguintes condi��es: 
/*
        1. Parcelas para aquisi��o em 10 pagamentos.
        2. O valor da compra dever� ser informado em tempo de execu��o.
        3. O valor total dos juros � de 3% e dever� ser aplicado sobre o montante financiado.
        4. No final informar o valor de cada parcela.
        
        obs: O montante � calculado pela soma do capital com os juros (M = C + J)
*/

DECLARE
    valor_carro NUMBER := &carro;
    parcelas    NUMBER := &parcelas;
    juros       NUMBER := 1.03;
BEGIN
    dbms_output.put_line('Valor do carro a vista: R$'|| valor_carro);
    dbms_output.put_line('Valor de cada parcela: R$'||((valor_carro * juros) / parcelas));
    dbms_output.put_line('Valor do carro financiado: R$'|| valor_carro * juros);
END;