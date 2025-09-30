SELECT  
    prod.nome,
    prod.categoria,
    SUM(itens.subtotal) AS total_vendido
FROM produto AS prod
INNER JOIN itens_pedido AS itens 
    ON prod.id_produto = itens.id_produto
GROUP BY prod.nome, prod.categoria
ORDER BY total_vendido DESC;


-- Escreva uma consulta que identifique todos os usuários ativos que nunca fizeram um pedido no sistema.
SELECT u.*
FROM usuario as u
FULL OUTER JOIN pedido ped on u.id_usuario = ped.id_usuario
WHERE ped.id_usuario is null


WITH pedidos_totais AS (
    SELECT 
        ped.id_pedido,
        ped.id_usuario,
        SUM(itens.subtotal) AS valor_pedido
    FROM pedido ped
    INNER JOIN itens_pedido itens ON ped.id_pedido = itens.id_pedido
    GROUP BY ped.id_pedido, ped.id_usuario
)

SELECT 
    u.nome,
    COUNT(p.id_pedido) AS numero_pedidos,
    ROUND(AVG(p.valor_pedido), 2) AS valor_medio_pedido, -- arredonda e media 
    ROUND(SUM(p.valor_pedido), 2) AS valor_total_gasto
FROM pedidos_totais p
INNER JOIN usuario u ON p.id_usuario = u.id_usuario
GROUP BY u.nome
ORDER BY valor_total_gasto DESC;


SELECT 
    TO_CHAR(ped.data_pedido, 'MM/YYYY') AS periodo,
    COUNT(DISTINCT ped.id_pedido) AS quantidade_pedidos,
    COUNT(DISTINCT itens.id_produto) AS produtos_diferentes,
    ROUND(SUM(itens.subtotal), 2) AS faturamento_total
FROM pedido ped
INNER JOIN itens_pedido itens ON ped.id_pedido = itens.id_pedido
INNER JOIN produto prod ON itens.id_produto = prod.id_produto
GROUP BY TO_CHAR(ped.data_pedido, 'MM/YYYY')
ORDER BY MIN(ped.data_pedido);


-- Faça uma consulta que identifique produtos ativos que nunca foram incluídos em nenhum pedido.
SELECT prod.*
FROM produto as prod 
FULL OUTER JOIN itens_pedido itens on prod.id_produto = itens.id_produto
WHERE prod.ativo = False and itens.id_pedido is Null 

-- Crie uma consulta que calcule o ticket médio (valor médio de venda) para cada categoria de produto, considerando apenas pedidos não cancelados.
WITH pedidos_categoria AS (
    SELECT 
        ped.id_pedido,
        prod.categoria,
        SUM(itens.subtotal) AS valor_pedido_categoria
    FROM pedido ped
    INNER JOIN itens_pedido itens ON ped.id_pedido = itens.id_pedido 
    INNER JOIN produto prod ON itens.id_produto = prod.id_produto
    WHERE ped.status_pedido != 'cancelado'
    GROUP BY ped.id_pedido, prod.categoria
)

SELECT 
    categoria,
    ROUND(AVG(valor_pedido_categoria), 2) AS ticket_medio
FROM pedidos_categoria
GROUP BY categoria
