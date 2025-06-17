-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE updateShelterWithId
	-- Add the parameters for the stored procedure here
	@id int,
	@name nvarchar(100),
	@location nvarchar(100)
AS
if exists(select 1 from shelters where shelterid=@id)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update shelters set name=@name, location=@location where shelterid=@id
	print 'The id is found and updated'
END
else 
begin
print 'Invalid id';
end
GO
