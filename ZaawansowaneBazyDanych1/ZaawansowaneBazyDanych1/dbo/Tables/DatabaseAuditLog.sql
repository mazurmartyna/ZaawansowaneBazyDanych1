CREATE TABLE [dbo].[DatabaseAuditLog] (
    [LogID]      INT            IDENTITY (1, 1) NOT NULL,
    [EventType]  NVARCHAR (100) NULL,
    [ObjectName] NVARCHAR (256) NULL,
    [LoginName]  NVARCHAR (256) NULL,
    [EventTime]  DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

