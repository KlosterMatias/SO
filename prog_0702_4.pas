
Program prog_0702_4;

Uses BaseUnix;

Var fd : Longint;
  datos: String;
Begin
  If fpAccess(ParamStr(1), X_OK Or F_OK) = 0 Then
    Begin
      fd := fpOpen(ParamStr(1), O_RdOnly);
      If fd > 0 Then
        Begin
          If fpRead(fd, datos, 10) < 0 Then
            Begin
              Writeln ('Error leyendo archivo!!!');
              Halt(2);
            End;
          Writeln(datos);
        End;
      fpClose(fd);
    End
  Else writeln('No existe el archivo o el usuario no tiene permiso para realizar operaciones en el archivo');
End.
