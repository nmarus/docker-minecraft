docker-minecraft
================

Simple minecraft server.

Run from Docker Hub:
--------------------
Replace "</local/path>" with where you wish to store your minecraft configuration, or remove "-v </local/path>:/minecraft" completely, to store this in the container.

        docker run -d -it -v </local/path>:/minecraft -p 25565:25565 --name minecraft nmarus/docker-minecraft

Admin Console:
--------------

(use this to op yourself, change game mode, etc.)

        docker attach minecraft

*ctrl-p, ctrl-q to exit, or "stop" to shutdown minecraft server and docker container*

To Stop:
-----------

        docker stop minecraft

To Start:
-----------

        docker start minecraft

When container starts, it will automatically grab latest server version, download, and run.
