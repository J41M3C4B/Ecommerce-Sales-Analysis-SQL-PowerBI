# Ecommerce-Sales-Analysis-SQL-PowerBI

## 1. Problema de Negocio
La empresa ficticia "UK Gifts Online", una tienda de e-commerce de regalos en el Reino Unido, experimento un estancamiento en sus ventas. La gerencia operaba "a ciegas", sin entender que productos eran exitosos, cúando ocurrian los picos de ventas, o quienes eran sus clientes mas valiosos.

## 2. Objetivo
El objetivo de este proyecto fue analizar el historial de transacciones en un periodo de 2 años para proporcionar a la gerencia informes accionables que permitieran: 
* Optimizar el inventario.
* Diseñar estrategias de marketing  de fidelización.
* Identificar oportunidades de crecimiento.

## 3. Herramientas y Porqué

**PostgreSQL (SQL):** Se utilizo para todo el proceso de **ETL (Extracción, Transformación y Carga)**. Debido al gran volumen de datos (+500,000 filas), SQL fue esencial para almacenar, limpiar, estandarizar e imputar datos de forma eficiente antes del analisis. 
**Power BI:** Se usó como la herramienta de **Business Intelligence (BI)** para conectar en vivo la vista de SQL (v_NewCleanSales), crear metricas DAX y visualizar los hallazgos en un dashboard interactivo de 3 paginas.

## 4. Proceso de Análisis (ETL y Modelado)
El análisis se dividió en 4 fases clave:
**Fase 1: Carga y Exploración (ETL)**
*Se cargo el dataset crudo (.csv) de mas de 500,000 registros en una base de datos PostgreSQL.

**Fase 2: Liempieza y Transformación (SQL)**
*Se creo una **Vista(v_NewCleanSales)** como capa de negocios para Power BI. Esta vista realiza la limpieza en tiempo real.

* **Liempieza Clave:**
  *Se filtraron cancelaciones ('Quantity' < 0) y transacciones sin 'CustomeID'.
  * **Imputación de datos:** Se corrigieron descripciones de productos erróneas (ej. '?', 'check', 'wrongly marked') reemplazandolas con la descripción mas frecuente para ese 'StockCode'.
  * **Estandarización:** Se limpiaron caracteres no deseados ('+', '*', '?') y se estandarizó el formato de 'Description' y 'Country' usando 'INITCAP' Y 'TRIM'.
* *El script SQL completo (v_NewCleanSales.sql) esta iuncluido en el repositorio.*

  
**Fase3: Modelado de Datos (DAX en Power BI)**
*Se creó una tabla de medidas ('_Medidas') para centralizar los cálculos.
* **Medidas DAX Creadas:** '[Total Ventas]', '[Num Pedidos]', '[Num Clientes]', '[Ticket Promedio]', '[Total Unidades]'.
* **Tabla RFM:** Se creo una tabla calculada ('CustomerTable') usando 'SUMMARIZE' para agrupar las transacciones por cliente y calcular su 'Frequency' y 'Monetary'. Se añadio una columna calculada para 'Recency'.

## 5. Hallazgos y Visualización (El Dashboard)

El dashboard interactivo de 3 paginas responde a las preguntas clave del negocio.

### Pagina 1: Resumen general
* **KPI´s:** [Ventas Totales: $17.07 Mill.], [Num. Clientes: 5,861], [Ticket Promedio: $465.59], [Num. Pedidos: 37,000].
* **Hallazgo:
