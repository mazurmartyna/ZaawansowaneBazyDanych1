
CREATE TRIGGER trg_DatabaseAuditLogChanges
ON DATABASE
FOR ALTER_TABLE, DROP_TABLE, CREATE_TABLE
AS
BEGIN
    SET NOCOUNT ON;
   
    BEGIN
        Insert Into dbo.DatabaseAuditLog(EventType,ObjectName, LoginName)
        Select  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
                EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(256)'),
                ORIGINAL_LOGIN()
    END
END;