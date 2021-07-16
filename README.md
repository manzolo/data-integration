Docker Pentaho Data Integration v9.0.0.0-423
============================================

# Introduction

DockerFile for [Pentaho Data Integration](https://sourceforge.net/projects/pentaho/) (a.k.a kettel / PDI)

# Quick start

## Build image
```
$ make setup

```

## Configuration
- Clone repository
- cd data-integration
- Put your own connector lib (jar) files into libs folder (host)
- Put your own kettle.properties file in jobs/.kettle/kettle.properties (host)
- Put your own shared.xml file in jobs/.kettle/shared.xml (host)
- Put your own jobs/transformation files in jobs folder (host)

### JDBC connector download links:
- [Mysql](https://downloads.mysql.com/archives/c-j/)
- [Posgres](https://jdbc.postgresql.org/download.html)
- [Oracle](https://www.oracle.com/database/technologies/jdbc-drivers-12c-downloads.html)

## Basic Syntax

```
$ docker container run --rm data-integration

Usage:	/entrypoint.sh COMMAND

Pentaho Data Integration (PDI)

Options:
  runj filename		Run job file
  runt filename		Run transformation file
  spoon			Run spoon (GUI)
  help		         	Print this help

#Example:
docker container run --rm --name data-integration -v $(pwd)/jobs:/jobs -v $(pwd)/libs:/libs manzolo/data-integration runj dummy.kjb -param:PARAMETER_NAME=PARAMETER_VALUE
```

## Heat Check
```
$ make test

```

## Spoon (gui)
```
$ make run

```

