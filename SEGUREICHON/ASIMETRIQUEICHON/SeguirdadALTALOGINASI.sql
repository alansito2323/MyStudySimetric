drop procedure sp_LoginUsuario2
CREATE PROCEDURE sp_LoginUsuario2
    @Email NVARCHAR(255),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    -- Declarar una variable para almacenar la contraseña encriptada
    DECLARE @ContraseñaEncriptada VARBINARY(MAX);

    -- Encriptar la contraseña proporcionada asimétricamente
    SET @ContraseñaEncriptada = ENCRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), @Contraseña);

    -- Declarar una variable para almacenar la contraseña desencriptada
    DECLARE @ContraseñaDesencriptada NVARCHAR(255);

    -- Desencriptar la contraseña almacenada en la base de datos
    SELECT @ContraseñaDesencriptada = CONVERT(NVARCHAR(255), DECRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), Contraseña))
    FROM Usuarios
    WHERE Email = @Email;

    -- Verificar si el correo electrónico y la contraseña coinciden
    IF @ContraseñaDesencriptada IS NOT NULL AND @ContraseñaDesencriptada = @Contraseña
    BEGIN
        SELECT 'Si' AS Resultado; -- Si las credenciales son correctas
    END
    ELSE
    BEGIN
        SELECT 'No' AS Resultado; -- Si las credenciales son incorrectas
    END;
END;
EXEC sp_LoginUsuario2 @Email = '9', @Contraseña = '11';

select * from Usuarios

delete from Usuarios
