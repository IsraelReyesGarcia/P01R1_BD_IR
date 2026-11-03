-- USO DE JOINS
-- Obtener todos los pedidos con el nombre del cliente
USE GenNov
Go

SELECT 
	C.Nombre AS Cliente,
	P.PedidoID,
	P.Fecha,
	P.Total,
	P.Estado
FROM Clientes as C
INNER JOIN Pedidos AS P
ON C.ClienteID = P.ClienteID
ORDER BY P.Fecha DESC;

SELECT * FROM Pedidos;

SELECT * FROM Productos;
UPDATE Productos SET Stock = 0 WHERE ProductoID = 1;
DELETE FROM Productos WHERE ProductoID = 1;
SP_HELP 'Productos'

SELECT * FROM AuditoriaProductos;
SP_HELP 'AuditoriaProductos'

EXEC sp_rename 'dbo.AuditoriaProductos.PrecioNumero', 'PrecioNuevo', 'COLUMN';

--UPDATE
--SELECT * FROM 
Productos
SET PRECIO = 500
WHERE PRODUCTOID = 1

-- JOIN MULTIPLES
SELECT 
	C.Nombre AS Cliente,
	P.PedidoID,
	P.Fecha,
	PROD.Nombre AS Producto,
	DP.Cantidad,
	DP.PrecioUnitario,
	(DP.Cantidad * DP.PrecioUnitario) AS Subtotal
FROM Clientes AS C
INNER JOIN Pedidos AS P
ON 
C.ClienteID = P.ClienteID

INNER JOIN DetallesPedido AS DP
ON 
P.PedidoID > DP.PedidoID

INNER JOIN Productos AS PROD
ON
DP.PedidoID = PROD.ProductoID

WHERE P.FECHA >= '2024-01-01'
ORDER BY 3 DESC, P.PedidoID;
GO


-- Vista, es una consulta SQL guardada que funciona como una tabla virtual - no almacen datos físicamente, solo la consulta
-- Es una consulta creada como un objeto
-- Simplkifixa consultas complejas
-- Mejora la seguridad (puedes ocultar columnas sensibles)
-- Facilita el mantenimiento del código
-- Abstrae la complejidad para otros usuarios

-------------------VISTAS
SELECT * FROM [dbo].[VWVistaResumenVentas];
SELECT * FROM Clientes;
SELECT * FROM Pedidos;

----------------- CONFIRMAR STORE PROCEDURES
DECLARE @IDNuevo INT;
EXEC spInsertarPedido
	@ClienteID = 1,
	@Total = 1500.00,
	@NuevoPedidoID = @IDNuevo OUTPUT;

PRINT 'Pedido Creado con ID: ' + CAST(@IDNuevo AS NVARCHAR); -- CAST es una función para convertir un tipo de dato en otro

-------------------------------------------
-- Eliminar un TRIGGER
DROP TRIGGER IF EXISTS dbo.NombreDelTriggerAnterior;

-------------------------------------------
--============================================
--Consulta de tablas
--============================================
SELECT * FROM Productos;
SELECT * FROM Clientes
SELECT * FROM Pedidos
SELECT * FROM DetallesPedido
SELECT * FROM AuditoriaProductos

SELECT COUNT (*) FROM Productos;
---------------------------------------------
--ACTUALIZAR
UPDATE dbo.Productos SET Categoria = N'Bebida' WHERE Categoria IN(N'BEBIDAS', N'Bebidas');

-----------------------
--ALTER UNA COLUMNA
EXEC sp_rename 'dbo.AuditoriaProductos.PrecioNumero', 'PrecioNuevo', 'COLUMN';
--              'esquema.tabla.columna_actual', 'nombre_nuevo', 'COLUMN'

----------------------
--CONSULTA DE UN TRIGGER

SELECT name, is_instead_of_trigger
FROM sys.triggers
WHERE parent_id = OBJECT_ID('dbo.Productos');

---------------------------
--Deshabilitar Triggers
DROP TRIGGER dbo.TR_AuditoriaProductoInsteafOfInsert --ON dbo.Productos;
DROP TRIGGER dbo.TR_ValidarPrecioInsteadOfUpdate;
DROP TRIGGER dbo.TR_ValidarStockInsteadOfDelete;

---------------------------
-- Habilitar Triggers
ENABLE TRIGGER dbo.TR_AuditoriaProductoInsteafOfInsert ON dbo.Productos;

SELECT name, is_disabled, is_instead_of_trigger
FROM sys.triggers
WHERE parent_id = OBJECT_ID('dbo.Productos');
-- Si lo desactivaste: aparece con is_disabled = 1.
-- Si lo eliminaste: ya no aparece en la lista.

DECLARE @id INT;
EXEC dbo.spProductos_Insertar N'Latte', N'Bebida', 45, 10, @id OUTPUT;
SELECT @id;   -- debe mostrar un número


------------------------------------------------------
--=============================================================
--PRUEBA DE RENDIMIENTO
--=============================================================
USE GenNov;
GO

SET NOCOUNT ON;

DECLARE @Total       INT = 1000000;   -- Registros totales a insertar
DECLARE @TamanoLote  INT = 100000;    -- Registros por lote
DECLARE @Insertados  INT = 0;
DECLARE @Filas       INT;

WHILE @Insertados < @Total
BEGIN
    ;WITH Base AS (
        SELECT TOP (@TamanoLote)
               ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects AS a
        CROSS JOIN sys.all_objects AS b
    ),
    Rnd AS (
        -- Valores aleatorios no negativos por fila (& 0x7FFFFFFF evita el error de ABS con -2147483648)
        SELECT n,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 6      AS rProd,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 5      AS rVar,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 3      AS rCat,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 15000  AS rPrecio,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 201    AS rStock,
               (CHECKSUM(NEWID()) & 0x7FFFFFFF) % 525600 AS rMinutos
        FROM Base
    )
    INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, FechaCreacion)
    SELECT
        CONCAT(
            CASE rProd WHEN 0 THEN 'Cafe' WHEN 1 THEN 'Te' WHEN 2 THEN 'Pan'
                       WHEN 3 THEN 'Jugo' WHEN 4 THEN 'Pastel' ELSE 'Galleta' END,
            ' ',
            CASE rVar WHEN 0 THEN 'Americano' WHEN 1 THEN 'Capuchino' WHEN 2 THEN 'Chico'
                      WHEN 3 THEN 'Integral' ELSE 'Especial' END,
            ' ',
            @Insertados + n
        ),
        CASE rCat WHEN 0 THEN 'BEBIDAS' WHEN 1 THEN 'PANADERIA' ELSE 'POSTRES' END,
        CAST(rPrecio / 100.0 + 10 AS DECIMAL(10,2)),   -- 10.00 a 160.00
        rStock,                                         -- 0 a 200
        DATEADD(MINUTE, -rMinutos, GETDATE())           -- último año
    FROM Rnd;

    SET @Filas = @@ROWCOUNT;

    IF @Filas = 0
    BEGIN
        PRINT 'No se insertaron filas; proceso detenido.';
        BREAK;
    END

    SET @Insertados += @Filas;
    PRINT 'Insertados: ' + CAST(@Insertados AS VARCHAR(20));
END;

PRINT 'Proceso terminado.';
GO