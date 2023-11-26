-------------------------------Borrar tablas de BI---------------------------------

DECLARE @SchemaName NVARCHAR(255) = 'LOS_BORBOTONES'
DECLARE @ObjectName NVARCHAR(255)

-- Drop tables
DECLARE table_cursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = @SchemaName

OPEN table_cursor

FETCH NEXT FROM table_cursor INTO @ObjectName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @Sql0 NVARCHAR(MAX)
    SET @Sql0 = 'DROP TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
    EXEC sp_executesql @Sql0

    FETCH NEXT FROM table_cursor INTO @ObjectName
END

CLOSE table_cursor
DEALLOCATE table_cursor

-- Drop views

DECLARE view_cursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = @SchemaName

OPEN view_cursor

FETCH NEXT FROM view_cursor INTO @ObjectName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @Sql1 NVARCHAR(MAX)
    SET @Sql1 = 'DROP VIEW ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
    EXEC sp_executesql @Sql1

    FETCH NEXT FROM view_cursor INTO @ObjectName
END

CLOSE view_cursor
DEALLOCATE view_cursor

-- Drop procedures

DECLARE procedure_cursor CURSOR FOR
SELECT ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = @SchemaName AND ROUTINE_TYPE = 'PROCEDURE'

OPEN procedure_cursor

FETCH NEXT FROM procedure_cursor INTO @ObjectName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @Sql2 NVARCHAR(MAX)
    SET @Sql2 = 'DROP PROCEDURE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
    EXEC sp_executesql @Sql2

    FETCH NEXT FROM procedure_cursor INTO @ObjectName
END

CLOSE procedure_cursor
DEALLOCATE procedure_cursor

-- Drop functions
DECLARE @FunctionName NVARCHAR(255)
DECLARE function_cursor CURSOR FOR
SELECT ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = @SchemaName AND ROUTINE_TYPE = 'FUNCTION'

OPEN function_cursor

FETCH NEXT FROM function_cursor INTO @FunctionName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @Sql3 NVARCHAR(MAX)
    SET @Sql3 = 'DROP FUNCTION ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@FunctionName)
    EXEC sp_executesql @Sql3

    FETCH NEXT FROM function_cursor INTO @FunctionName
END

CLOSE function_cursor
DEALLOCATE function_cursor

drop schema LOS_BORBOTONES