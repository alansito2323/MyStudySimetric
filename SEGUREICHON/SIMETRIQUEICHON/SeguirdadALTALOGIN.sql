drop procedure sp_LoginUsuario
CREATE PROCEDURE sp_LoginUsuario
    @Email NVARCHAR(255),
    @Contrase�a NVARCHAR(255)
AS
BEGIN
    -- Declarar una variable para almacenar la contrase�a encriptada
    DECLARE @Contrase�aEncriptada VARBINARY(MAX);

    -- Abrir la clave sim�trica para desencriptaci�n
    OPEN SYMMETRIC KEY MySymmetricKeyReal
    DECRYPTION BY ASYMMETRIC KEY MyAsymmetricPrivateKeyReal;

    -- Encriptar la contrase�a proporcionada con la clave sim�trica
    SET @Contrase�aEncriptada = ENCRYPTBYKEY(KEY_GUID('MySymmetricKeyReal'), @Contrase�a);

    -- Declarar una variable para almacenar la contrase�a desencriptada
    DECLARE @Contrase�aDesencriptada NVARCHAR(255);

    -- Desencriptar la contrase�a almacenada en la base de datos
    SELECT @Contrase�aDesencriptada = CONVERT(NVARCHAR(255), DECRYPTBYKEY(Contrase�a))
    FROM Usuarios
    WHERE Email = @Email;

    -- Cerrar la clave sim�trica
    CLOSE SYMMETRIC KEY MySymmetricKeyReal;

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


DECLARE @Resultado NVARCHAR(3);
EXEC sp_LoginUsuario @Email = '4', @Contrase�a = '5';

select * from Usuarios

delete from Usuarios

