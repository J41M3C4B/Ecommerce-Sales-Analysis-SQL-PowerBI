# Ecommerce-Sales-Analysis-SQL-PowerBI

## 1. Problema de Negocio

La empresa ficticia "UK Gifts Online", una tienda de e-commerce de regalos en el Reino Unido, **experimentó** un estancamiento en sus ventas. La gerencia operaba "a ciegas", sin comprender **qué** productos eran exitosos, **cuándo** ocurrían los picos de ventas, o **quiénes** eran sus clientes **más** valiosos.

## 2. Objetivo

El objetivo de este proyecto fue analizar el historial de transacciones en un periodo de 2 años para proporcionar a la gerencia informes accionables que permitieran:
* Optimizar el inventario.
* Diseñar estrategias de marketing y fidelización.
* Identificar oportunidades de crecimiento.

## 3. Herramientas y Porqué

* **PostgreSQL (SQL):** Se **utilizó** para todo el proceso de **ETL (Extracción, Transformación y Carga)**. Debido al gran volumen de datos (+500,000 filas), SQL fue esencial para almacenar, limpiar, estandarizar y completar datos de forma eficiente antes del **análisis**.
* **Power BI:** Se usó como la herramienta de **Business Intelligence (BI)** para conectar directamente a la vista de SQL (`v_NewCleanSales`), crear **métricas** DAX y visualizar los **hallazgos** en un dashboard interactivo de 3 páginas.

## 4. Proceso de Análisis (ETL y Modelado)

El **análisis** se dividió en 4 fases clave:

**Fase 1: Carga y Exploración (ETL)**
* Se cargó el dataset crudo (.csv) de más de 500,000 registros en una base de datos PostgreSQL.

**Fase 2: Limpieza y Transformación (SQL)**
* Se **creó** una **Vista (`v_NewCleanSales`)** como capa de negocios para Power BI. Esta vista realiza la limpieza en tiempo real.
* **Limpieza Clave:**
    * Se filtraron cancelaciones (`Quantity` < 0) y transacciones sin `CustomerID`.
    * **Imputación de datos:** Se corrigieron descripciones de productos erróneas (ej. '?', 'check', 'wrongly marked') **reemplazándolas** con la descripción **más** frecuente para ese `StockCode`.
    * **Estandarización:** Se limpiaron caracteres no deseados ('+', '*', '?') y se estandarizó el formato de `Description` y `Country` usando `INITCAP` y `TRIM`.
* *El script SQL completo (`v_NewCleanSales.sql`) **está incluido** en el repositorio.*

**Fase 3: Modelado de Datos (DAX en Power BI)**
* Se **creó** una tabla de medidas ('\_Medidas') para centralizar los cálculos.
* **Medidas DAX creadas:** `[Total Ventas]`, `[Num Pedidos]`, `[Num Clientes]`, `[Ticket Promedio]`, `[Total Unidades]`.
* **Tabla RFM:** Se **creó** una tabla calculada ('CustomerTable') usando `SUMMARIZE` para agrupar las transacciones por cliente y calcular su `Frequency` y `Monetary`. Se **añadió** una columna calculada para `Recency`.

## 5. Hallazgos y Visualización (El Dashboard)

El dashboard interactivo de 3 páginas responde a las preguntas clave del negocio.

### Página 1: Resumen General
* **KPIs:** [Ventas Totales: $17.07 M], [Num. Clientes: 5,861], [Ticket Promedio: $465.59], [Num. Pedidos: 37,000], [Prom. Pedidos/Cliente: ~6.3].
* **Hallazgos:**
    * Tenemos un volumen de ventas fuerte ($17 M) con un ticket promedio muy alto ($465.59) y clientes leales (alta tasa de pedidos por cliente).
    * Las ventas dependen **en gran medida** de la temporada de fin de año (noviembre y diciembre). La planificación para estos meses es crucial.
    * Nuestro mercado principal es, sin duda, Europa (Reino Unido).
    * Se observa **también** que hay un promedio de ~6.3 pedidos por cliente, indicando una tasa saludable de **repetición** de compra.
    * El top 3 de productos **más vendidos** lo lideran: 'Regency Cake 3 Tier', 'White Hanging Heart T-Light Holder' y 'Paper Craft, Little Birdie'.

### Página 2: Análisis de Productos
* **Hallazgos:**
    * **Identidad clara:** Somos una tienda de regalos que basa sus ventas en **Decoración**, **por lo que** debemos guiar nuestra estrategia de marketing y compras en esa línea.
    * **Principio de Pareto (80/20):** El 80% de nuestras unidades vendidas provienen de 1 **categoría** (Decoration). Solo una pequeña lista de productos "héroe" genera una parte desproporcionada de nuestros ingresos.
    * **Oportunidad de Optimización:** Tenemos una **oportunidad** clara de mejorar la rentabilidad al eliminar el "inventario zombie" (los productos menos vendidos) y reinvertir esos recursos (dinero, espacio) en asegurar el stock de nuestros productos "héroe".

### Página 3: Análisis de Clientes (RFM)
* **Hallazgo:**
    * Se identifica que el negocio es saludable con una base de "Clientes Leales" muy fuerte y activa.
    * El principal reto y oportunidad reside en el grupo de "Clientes en Riesgo" (azul oscuro): necesitamos crear campañas de reactivación urgentes para evitar que se conviertan en "Clientes Perdidos".
    * Nuestro **crecimiento** se verá fortalecido al convertir a los "**Clientes** Nuevos" (naranja) en Leales.

## 6. Recomendaciones Accionables

1.  **Focalizar el Inventario:** Descontinuar los 10 **productos** con menores ingresos y volumen para liberar capital de almacén y reinvertir en los productos "héroe".
2.  **Reactivación de Clientes:** Lanzar una campaña de email marketing con un descuento especial **dirigida** al segmento de **Clientes en Riesgo** identificados en el gráfico RFM.
3.  **Crecimiento y Venta Cruzada:** Ofrecer promociones de los Top 10 productos al segmento de **Clientes Nuevos** (baja recencia, baja frecuencia) para aumentar su lealtad e **interés**.

## 7. Dashboard Interactivo






