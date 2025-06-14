WITH RFM AS (
    SELECT
        V.cliente_id                                             AS CLIENTE_ID
        ,DATE_DIFF( MAX(V.data_venda), MAX(V2.data_base), "DAY" ) AS RECENCIA
        ,COUNT(*)                                                 AS FREQUENCIA
        ,SUM(v.valor_total)                                       AS VALOR_TOTAL
    FROM 
        vendas_rfm_simulada AS V
    CROSS JOIN
        ( SELECT MAX(data_venda) AS data_base FROM vendas_rfm_simulada ) V2
    GROUP BY 
        V.cliente_id
),
SCORED AS (
    SELECT 
        CLIENTE_ID                                   AS CLIENTE_ID
        ,NTILE( 5 ) OVER ( ORDER BY recencia DESC )   AS SCORE_R
        ,NTILE( 5 ) OVER ( ORDER BY frequencia ASC )  AS SCORE_F
        ,NTILE( 5 ) OVER ( ORDER BY valor_total ASC ) AS SCORE_M
    FROM 
        RFM
)
, SEGMENTACAO AS (
    SELECT 
        CLIENTE_ID AS CLIENTE_ID
        ,CASE
            WHEN score_r <= 2 AND score_f <= 2 AND score_m <= 2 THEN 'Clientes Inativos'
            WHEN score_r <= 2 AND score_f >= 4                  THEN 'Novos Clientes'
            WHEN score_r >= 4 AND score_f >= 4 AND score_m >= 4 THEN 'Clientes VIP'
            WHEN score_r >= 3 AND score_f >= 3 AND score_m >= 3 THEN 'Clientes Leais'
            ELSE 'Outros'
        END                               AS SEGMENTO_RFM
        ,CONCAT(score_r, score_f, score_m) AS SCORE_RFM
    FROM 
        SCORED
    ORDER BY 
        SCORE_RFM
)
, PRODUTOS_POR_SEGMENTO AS (
    -- Etapa 4: Junta com os produtos e SOMA as quantidades
    SELECT
         S.SEGMENTO_RFM    AS SEGMENTO_RFM
        ,P.PRODUTO_ID      AS PRODUTO_ID
        ,SUM(P.QUANTIDADE) AS TOTAL_QUANTIDADE
    FROM 
        SEGMENTACAO AS S
    INNER JOIN 
        plan1 AS P ON S.CLIENTE_ID = P.CLIENTE_ID
    GROUP BY
        S.SEGMENTO_RFM,
        P.PRODUTO_ID
),
RANKING_PRODUTOS AS (
    -- Etapa 5: Cria um RANK para os produtos dentro de cada segmento
    SELECT
         SEGMENTO_RFM     AS SEGMENTO_RFM
        ,PRODUTO_ID       AS PRODUTO_ID
        ,TOTAL_QUANTIDADE AS TOTAL_QUANTIDADE
        ,RANK() OVER (PARTITION BY SEGMENTO_RFM ORDER BY TOTAL_QUANTIDADE DESC) AS RANK_PRODUTO
    FROM
        PRODUTOS_POR_SEGMENTO
)
-- Etapa Final: Seleciona apenas o produto mais vendido (rank 1) de cada segmento
SELECT 
     SEGMENTO_RFM     AS SEGMENTO_RFM
    ,PRODUTO_ID       AS PRODUTO_ID
    ,TOTAL_QUANTIDADE AS TOTAL_QUANTIDADE
    ,RANK_PRODUTO     AS RANK_PRODUTO
FROM
    RANKING_PRODUTOS
ORDER BY
    TOTAL_QUANTIDADE DESC;