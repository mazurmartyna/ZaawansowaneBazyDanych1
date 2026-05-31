CREATE TABLE [dbo].[AlbumyMuzyczne] (
    [AlbumID]    INT           NOT NULL,
    [Wykonawca]  NVARCHAR (50) NULL,
    [Album]      NVARCHAR (50) NULL,
    [RokWydania] INT           NULL,
    PRIMARY KEY CLUSTERED ([AlbumID] ASC)
);

