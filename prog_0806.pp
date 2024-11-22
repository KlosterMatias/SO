
Program prog_0806;

Uses 
Unix, BaseUnix;
Procedure MostrarAyuda;
Begin
  Writeln('Uso: ./prog_0806 <PID> <Número de Señal>');
End;

Var 
  pid: Longint;
  signalNum: Longint;
Begin
  // Verificar que se proporcionen dos argumentos
  If ParamCount <> 2 Then
    Begin
      MostrarAyuda;
      Halt(1);
    End;
  // Obtener PID y número de señal de los argumentos
  Val(ParamStr(1), pid);
  Val(ParamStr(2), signalNum);
  // Verificar que el PID sea un número
  If pid <= 0 Then
    Begin
      Writeln('El PID debe ser un número entero positivo.');
      Halt(1);
    End;
  // Verificar que el número de señal sea un número
  If signalNum <= 0 Then
    Begin
      Writeln('El número de señal debe ser un número entero positivo.');
      Halt(1);
    End;
  // Enviar la señal al proceso
  If FpKill(pid, signalNum) = 0 Then
    Writeln('Señal enviada correctamente.')
  Else
    Writeln('Error al enviar la señal.');
End.
