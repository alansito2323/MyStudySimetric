drop procedure sp_LoginUsuario2
CREATE PROCEDURE sp_LoginUsuario2
    @Email NVARCHAR(255),
    @Contrase�a NVARCHAR(255)
AS
BEGIN
    -- Declarar una variable para almacenar la contrase�a encriptada
    DECLARE @Contrase�aEncriptada VARBINARY(MAX);

    -- Encriptar la contrase�a proporcionada asim�tricamente
    SET @Contrase�aEncriptada = ENCRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), @Contrase�a);

    -- Declarar una variable para almacenar la contrase�a desencriptada
    DECLARE @Contrase�aDesencriptada NVARCHAR(255);

    -- Desencriptar la contrase�a almacenada en la base de datos
    SELECT @Contrase�aDesencriptada = CONVERT(NVARCHAR(255), DECRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), Contrase�a))
    FROM Usuarios
    WHERE Email = @Email;

    -- Verificar si el correo electr�nico y la contrase�a coinciden
    IF @Contrase�aDesencriptada IS NOT NULL AND @Contrase�aDesencriptada = @Contrase�a
    BEGIN
        SELECT 'Si' AS Resultado; -- Si las credenciales son correctas
    END
    ELSE
    BEGIN
        SELECT 'No' AS Resultado; -- Si las credenciales son incorrectas
    END;
END;
EXEC sp_LoginUsuario2 @Email = '9', @Contrase�a = '11';

select * from Usuarios

delete from Usuarios
