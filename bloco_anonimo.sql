-- Bloco anônimo - estrutura de código que não salva em nenhum lugar, fica na IDE

-- serve para imprimir na tela
SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    nome  VARCHAR2(30) := 'VERGS';
    ende   VARCHAR2(50) := '&ENDERECO'; -- & cria uma caixa de texto
BEGIN
    idade := 39; -- atribuindo valor à variável
    dbms_output.put_line('A IDADE INFORMADA É : ' || idade);
    dbms_output.put_line('O NOME INFORMADO É : ' || nome); -- || concatenando o valor
    dbms_output.put_line('O ENDEREÇO INFORMADO É : ' || ende);
END;

-- EXERCÍCIOS

-- 1. Criar um bloco PL_SQL para calcular o valor do novo salário mínimo que deverá ser de 25% em cima do autal, que é de R$???

DECLARE
    salario NUMBER;
    novo_salario NUMBER;
BEGIN
    salario :=  1518;
     novo_salario := 1.25 * salario;
    dbms_output.put_line('Novo salário mínimo: R$' || novo_salario);
END;

-- prof

DECLARE
    salario FLOAT;
BEGIN
    salario :=  1518;
    dbms_output.put_line('Novo salário mínimo: R$' || 1.25 * salario);
END;

-- 2. Criar um bloco PL_SQL para calcular o valor em reais de 45 dólares, sendo que o valor do câmbio a ser considerado é de R$???

DECLARE
    dolar NUMBER := 5.70;
BEGIN
    dbms_output.put_line('US$45 é igual a R$' || 45 * dolar);
END;

-- 3. Criar um bloco PL_SQL para calcular o valor das parcelas de uma compra de um carro, nas seguintes condições: 
/*
        1. Parcelas para aquisição em 10 pagamentos.
        2. O valor da compra deverá ser informado em tempo de execução.
        3. O valor total dos juros é de 3% e deverá ser aplicado sobre o montante financiado.
        4. No final informar o valor de cada parcela.
        
        obs: O montante é calculado pela soma do capital com os juros (M = C + J)
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