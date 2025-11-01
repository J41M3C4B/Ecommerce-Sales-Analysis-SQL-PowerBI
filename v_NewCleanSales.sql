CREATE OR REPLACE VIEW v_NewCleanSales AS

-- PASO 1: (NUEVO) Crear un "Maestro de Productos" dinámico.
-- Esto identifica la descripción "correcta" (la más frecuente)
-- para cada StockCode, ignorando la basura.
WITH ProductMaster AS (
    SELECT
        StockCode,
        Description
    FROM (
        SELECT
            StockCode,
            -- Limpio la descripción ANTES de agruparla
            INITCAP(TRIM(REGEXP_REPLACE(TRANSLATE(Description, '+*.?', '    '), '\s+', ' ', 'g'))) AS Description,
            
            -- Cuento cuántas veces aparece cada descripción por StockCode
            COUNT(*) AS Freq,
            
            -- Creo un ranking (rn=1 será la más frecuente)
            ROW_NUMBER() OVER(PARTITION BY StockCode ORDER BY COUNT(*) DESC) as rn
        FROM
            Retail_Raw
        WHERE
            -- Filtro basura obvia ANTES de contar.
            -- Regla de negocio: una descripción real debe tener > 3 caracteres.
            -- Esto elimina '?', '??', etc.
            LENGTH(TRIM(Description)) > 3
            -- Filtro notas de texto comunes
            AND TRIM(Description) NOT IN ('check', 'wrongly marked', 'temp', '?', '???', ' Came as green?')
        GROUP BY
            StockCode, Description
    ) AS RankedDescriptions
    WHERE
        rn = 1 -- Me quedo solo con la descripción más frecuente (la "correcta")
),

-- PASO 2: CTE para la limpieza primaria de transacciones.
-- ¡OJO! He quitado los filtros de Descripción de aquí.
BaseData AS (
    SELECT
        InvoiceNo,
        StockCode,
        Quantity,
        InvoiceDate,
        UnitPrice,
        (Quantity * UnitPrice) AS TotalSale,
        CAST(CustomerID AS INT) AS CustomerID,
        INITCAP(TRIM(Country)) AS Country
    FROM
        Retail_Raw
    WHERE
        Quantity > 0
        AND UPPER(InvoiceNo) NOT LIKE 'C%'
        AND CustomerID IS NOT NULL
        AND UnitPrice > 0
        AND LENGTH(TRIM(StockCode)) > 1 -- Mantenemos este filtro
        AND TRIM(Country) IS NOT NULL AND TRIM(Country) != ''
        -- Quito los filtros de Description para no perder ventas
        -- que tengan '?' o 'check'.
),

-- PASO 3: CTE para eliminar duplicados de transacciones.
DeduplicatedSales AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY 
                InvoiceNo, 
                StockCode, 
                Quantity, 
                InvoiceDate, 
                CustomerID
            ORDER BY 
                InvoiceDate
        ) AS rn
    FROM
        BaseData
)

-- PASO 4: Selección final uniendo los datos.
SELECT
    ds.InvoiceNo,
    ds.StockCode,
    
-- Uso la descripción del maestro de productos.
    pm.Description AS Description,
    
    ds.Quantity,
    ds.InvoiceDate,
    ds.UnitPrice,
    ds.TotalSale,
    ds.CustomerID,
    ds.Country
FROM
    DeduplicatedSales ds
    
-- Uso INNER JOIN para unir con el maestro de productos.
-- Esto también filtra automáticamente cualquier StockCode 
INNER JOIN ProductMaster pm ON ds.StockCode = pm.StockCode

WHERE
    ds.rn = 1;  -- Me quedo solo con transacciones únicas