# Description
Añadir una nueva interfaz de tipo Solo Anfitrion, llamada vboxnet0 tanto para el nodo master como para el worker1 desde VirtualBox

## Execute these commands
- Desde Herramientas -> Red Crear una nueva red Solo Anfitrion pulsando +, esta sera creada con el nombre por defecto vboxnet0
- Ahora editamos las interfaces de red de cada nodo: master y worker1 y añadimos como segunda interfaz una de tipo Solo Anfitrion escogiendo la que hemos creado anteriormente y poniendo
el modo promiscuo de la misma a Full.
