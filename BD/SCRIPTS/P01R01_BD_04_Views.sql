USE GenNov
GO
/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261027
DESCRIPCI�N: CREACI�N DE VISTAS 
*/
/*
CREATE OR ALTER VIEW VWVistaResumenVentas
AS 
	SELECT
	C.ClienteID,
	C.Nombre AS Cliente,
	C.Email,
	COUNT(P.PedidoID) AS TotalPedidos,
	ISNULL (SUM(P.Total),0) AS MontoTotal,
	MAX(P.Fecha) AS UltimaFecha
FROM Clientes AS C
LEFT JOIN Pedidos AS P
ON C.ClienteID = P.ClienteID
GROUP BY C.ClienteID;
GO*/
/*
CREATE OR ALTER VIEW VwVistaResumenes
AS  
	SELECT
	C.ClienteID,
	C.Nombre AS Cliente,
	C.Email,
	COUNT(P.PedidoID) AS TotalPedidos,
	ISNULL(SUM(P.Total),0) AS MontoTotal,
	MAX(P.Fecha) AS UltimaCompra
FROM Clientes AS C
LEFT JOIN Pedidos AS P
ON C.ClienteID = P.ClienteID
GROUP BY C.ClienteID, C.Nombre, C.Email;
GO*/