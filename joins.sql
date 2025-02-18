-- Todos os países que têm estados cadastrados

SELECT
    a.nome_pais          pais,
    COUNT(b.nome_estado) "QTD ESTADOS"
FROM
         pais a
    INNER JOIN estado b ON ( a.id_pais = b.id_pais )
GROUP BY
    a.nome_pais;
    
-- Padrão não ANSI (oracle)

SELECT * FROM pf1788.pais;

SELECT
    a.nom_pais          pais,
    COUNT(b.nom_estado) "QTD ESTADOS"
FROM
    pf1788.pais   a,
    pf1788.estado b
WHERE
    a.cod_pais = b.cod_pais
GROUP BY
    a.nom_pais;
    
-- Todos os países, inclusive os que não tem estados cadastrados

SELECT
    a.nom_pais          pais,
    COUNT(b.nom_estado) "QTD ESTADOS"
FROM
    pf1788.pais   a
    LEFT JOIN pf1788.estado b ON ( a.cod_pais = b.cod_pais )
GROUP BY
    a.nom_pais;
    
-- Padrão não ANSI (oracle), + representa o left join

SELECT
    a.nom_pais          pais,
    COUNT(b.nom_estado) "QTD ESTADOS"
FROM
    pf1788.pais   a,
    pf1788.estado b
WHERE
    a.cod_pais = b.cod_pais(+)
GROUP BY
    a.nom_pais
HAVING COUNT (b.nom_estado) BETWEEN 1 AND 5
ORDER BY 2 DESC; -- pelo nome, apelido ou posição da coluna

-- Países que tem mais que cinco estados

SELECT
    a.nom_pais          pais,
    COUNT(b.nom_estado) "QTD ESTADOS"
FROM
    pf1788.pais   a,
    pf1788.estado b
WHERE
    a.cod_pais = b.cod_pais(+)
GROUP BY
    a.nom_pais
HAVING COUNT (b.nom_estado) > 5
ORDER BY 2 DESC; -- pelo nome, apelido ou posição da coluna

-- Quantas cidades cada estado tem

SELECT
    a.nom_estado          estado,
    COUNT(b.nom_cidade) "QTD CIDADES"
FROM
         pf1788.estado a
    INNER JOIN pf1788.cidade b ON ( a.cod_estado = b.cod_estado )
GROUP BY
    a.nom_estado
ORDER BY 2 DESC;

-- Trazendo o pais junto

SELECT
    a.nom_pais          pais,
    b.nom_estado        estado,
    COUNT(c.nom_cidade) "QTD CIDADES"
FROM
         pf1788.pais a
    JOIN pf1788.estado b ON ( a.cod_pais = b.cod_pais )
    LEFT JOIN pf1788.cidade c ON ( b.cod_estado = c.cod_estado )
GROUP BY
    a.nom_pais,
    b.nom_estado
ORDER BY 3 DESC,1,2;