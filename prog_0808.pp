
Program prog_0808;

Uses BaseUnix;

Var 
  ChildPID: TPid;
  // Manejador de señales para el proceso hijo
Procedure ChildSignalHandler(sig: Longint);
cdecl;
Begin
  writeln('Proceso hijo recibió la señal: ', sig);
End;
Begin
  // Establecer el manejador de señales para el proceso hijo
  fpSignal(SIGUSR1, @ChildSignalHandler);
  // Crear un nuevo proceso hijo
  ChildPID := fpFork;
  If ChildPID = -1 Then
    Begin
      // Error al crear el proceso hijo
      writeln('Error al crear el proceso hijo.');
    End
  Else If ChildPID = 0 Then
         Begin
           // Código ejecutado por el proceso hijo
           // Realizar alguna tarea en el proceso hijo
           writeln('Proceso hijo ejecutando...');
           // Enviar la señal SIGUSR1 al proceso padre
           fpKill(fpgetppid, SIGUSR1);
           // Salir del proceso hijo
           Halt;
         End
  Else
    Begin
      // Código ejecutado por el proceso padre
      writeln('Proceso padre esperando la señal...');
      // Esperar a que el proceso hijo envíe la señal
      fpPause;
      // Mensaje cuando se recibe la señal
      writeln('Proceso padre recibió la señal.');
      // Terminar ambos procesos
      fpKill(ChildPID, SIGTERM);
    End;
End.
