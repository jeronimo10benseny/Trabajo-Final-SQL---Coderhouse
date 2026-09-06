-- ==============================================================================
-- PROYECTO FINAL INTEGRADOR -- MATERIA: SQL -- CODERHOUSE 
-- ARCHIVO: analisis.sql
-- AUTOR: Jerónimo Diez Benseny
-- ==============================================================================

-- ==============================================================================
-- SECCIÓN 1: ETAPA DE LIMPIEZA Y NORMALIZACIÓN DE NULOS
-- ==============================================================================

-- Empleamos COALESCE para imputar un descuento de 0.00 en transacciones sin bonificación
-- y calcular el valor transaccional neto sin sesgar operaciones aritméticas.
SELECT 
    p.id_pedido,
    c.nombre AS cliente,
    pr.nombre AS producto,
    p.cantidad,
    pr.precio,
    COALESCE(p.descuento_aplicado, 0.00) AS descuento_limpio,
    (p.cantidad * pr.precio) - COALESCE(p.descuento_aplicado, 0.00) AS monto_neto
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN productos pr ON p.id_producto = pr.id_producto;


-- ==============================================================================
-- SECCIÓN 2: CONSULTAS DE ANÁLISIS DE NEGOCIO
-- ==============================================================================

-- REQUERIMIENTO A: Top 5 Clientes por Gasto Total
-- Justificación: Identificar al segmento más alto de clientes para priorizar programas de fidelización.
SELECT 
    c.id_cliente,
    c.nombre,
    c.ciudad,
    COUNT(p.id_pedido) AS total_ordenes,
    SUM((p.cantidad * pr.precio) - COALESCE(p.descuento_aplicado, 0.00)) AS gasto_total_acumulado
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN productos pr ON p.id_producto = pr.id_producto
GROUP BY 
    c.id_cliente,
    c.nombre,
    c.ciudad
ORDER BY 
    gasto_total_acumulado DESC
LIMIT 5;


-- REQUERIMIENTO B: Facturación Total Agrupada por Mes
-- Justificación: Evaluar la tasa de crecimiento mensual para proyecciones de flujo de caja.
SELECT 
    DATE_TRUNC('month', p.fecha_pedido)::DATE AS periodo_mes,
    COUNT(p.id_pedido) AS volumen_transacciones,
    SUM((p.cantidad * pr.precio) - COALESCE(p.descuento_aplicado, 0.00)) AS facturacion_total_neta
FROM pedidos p
INNER JOIN productos pr ON p.id_producto = pr.id_producto
GROUP BY 
    DATE_TRUNC('month', p.fecha_pedido)::DATE
ORDER BY 
    periodo_mes ASC;


-- REQUERIMIENTO C: Los 3 Productos con Menor Desempeño Comercial
-- Justificación: Detectar artículos con rotación nula o deficiente para planes de desinversión.
SELECT 
    pr.id_producto,
    pr.nombre,
    pr.categoria,
    COALESCE(SUM(p.cantidad), 0) AS unidades_vendidas
FROM productos pr
LEFT JOIN pedidos p ON pr.id_producto = p.id_producto
GROUP BY 
    pr.id_producto,
    pr.nombre,
    pr.categoria
ORDER BY 
    unidades_vendidas ASC,
    pr.nombre ASC
LIMIT 3;


-- REQUERIMIENTO D: Ranking de Pedidos dentro de cada Categoría (con CTEs)
-- Justificación: Determinar qué tickets lideran la facturación dentro de cada línea de negocio.
WITH ventas_con_monto AS (
    SELECT 
        p.id_pedido,
        pr.categoria,
        pr.nombre AS producto,
        ((p.cantidad * pr.precio) - COALESCE(p.descuento_aplicado, 0.00)) AS monto_pedido
    FROM pedidos p
    INNER JOIN productos pr ON p.id_producto = pr.id_producto
)
SELECT 
    id_pedido,
    categoria,
    producto,
    monto_pedido,
    DENSE_RANK() OVER (
        PARTITION BY categoria 
        ORDER BY monto_pedido DESC
    ) AS ranking_en_categoria
FROM ventas_con_monto
ORDER BY 
    categoria ASC,
    ranking_en_categoria ASC;