# Trabajo-Final-SQL---Coderhouse
Proyecto final de la materia SQL dentro de la diplomatura de Data Science.

# Capstone Project: Análisis Estratégico de Datos en PostgreSQL

## 1. Contexto y Problema de Negocio
Una compañía especializada en repuestos y accesorios off-road requiere auditar el rendimiento comercial de su plataforma durante el primer semestre de 2026. La gerencia detectó inconsistencias en el cálculo de tickets debido a descuentos no registrados (valores nulos) y carece de visibilidad sobre los clientes estratégicos, la estacionalidad mensual y los artículos inmovilizados en inventario.

El objetivo de este proyecto consiste en estructurar un modelo relacional en SQL, ejecutar la limpieza de datos nulos y extraer métricas operativas directivas.

---

## 2. Decisiones Técnicas y Etapa de Limpieza
* **Gestión de Nulos (`COALESCE`):** El campo `descuento_aplicado` contiene transacciones donde la bonificación no existió (`NULL`). Se aplicó `COALESCE(descuento_aplicado, 0.00)` para asegurar que las operaciones de cálculo neto (`cantidad * precio - descuento`) mantengan coherencia aritmética sin omitir filas.
* **Integridad Relacional:** Tipos de datos estrictos (`NUMERIC(10,2)` para balances monetarios y `TIMESTAMP` para transacciones), acompañados de restricciones `CHECK` en precios y cantidades.
* **Trazabilidad Completa:** Uso de `LEFT JOIN` en el análisis de productos para visibilizar referencias con cero ventas registradas.

---

## 3. Hallazgos Clave e Interpretación de Negocio

| Requerimiento | Hallazgo Operativo | Recomendación / Decisión Ejecutiva |
| :--- | :--- | :--- |
| **Top Clientes** | El cliente **Martín Rossi** lidera el gasto acumulado con compras de alta gama en suspensión y neumáticos. | Incorporarlo a un programa de fidelización exclusiva y venta cruzada de componentes de rescate. |
| **Ventas Mensuales** | El volumen de facturación exhibe estabilidad entre febrero y marzo, impulsado por pedidos corporativos. | Planificar campañas de preventa a finales de cada ciclo mensual para sostener la curva de liquidez. |
| **Baja Rotación** | La *Placa Desatasco Aluminio* presenta 0 unidades vendidas, ocupando capacidad estática de almacén. | Liquidar el lote con un 20% de descuento para recuperar capital de trabajo inmovilizado. |
| **Ranking Categoría** | La categoría *Rescate* concentra los tickets promedio más altos mediante la venta de malacates sintéticos. | Aumentar el presupuesto de stock de seguridad para evitar quiebres de inventario en componentes críticos. |

---

## 4. Instrucciones de Ejecución
1. Conectar a PostgreSQL (mediante pgAdmin 4, DBeaver o terminal `psql`).
2. Abrir y ejecutar en su totalidad el script `estructura.sql` para crear la base de datos `capstone_project`, sus tablas y la carga inicial de registros.
3. Abrir y ejecutar el script `analisis.sql` para validar las transformaciones de limpieza y los cuatro reportes de negocio solicitados.
