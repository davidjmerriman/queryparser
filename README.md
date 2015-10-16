queryparser
===========

Prerequisites
-------------
### Windows

* git (https://git-scm.com/download/win)
* mingw (http://sourceforge.net/projects/mingw/files/Installer/)
	* mingw32-developer-toolkit
	* mingw32-base
	* msys-base

Once you've installed git and mingw, you need to make mingw aware of your filesystem and the location of git.

* Open C:/MinGW/msys/1.0/etc/fstab (create if it doesn't exist), and add:
```
C:\MinGW    /mingw
C:\         /c
```
* Open C:/MinGW/msys/1.0/home/&lt;username&gt;/.profile (create if it doesn't exist), and add:
```
PATH="/c/Program Files/Git/cmd:${PATH}"
```

### Linux

Install instructions for Ubuntu; may vary if your distro uses yum, rpm, etc. instead of apt-get

* git 
`sudo apt-get install git`
* gcc
`sudo apt-get install gcc`
* bison
`sudo apt-get install bison`
* flex
`sudo apt-get install flex`

### OS X
TODO

Installation
------------

```shell
# Checkout repo
git clone https://github.com/davidjmerriman/queryparser.git queryparser
cd queryparser

# Build Queryparser binary
./build.sh
```

The built queryparser binary is standalone and works without any PostgreSQL libraries existing or server running.

Usage
-----

```shell
# Parse a query into Postgres' internal format
echo 'SELECT 1' | ./queryparser

# ({SELECT :distinctClause <> :intoClause <> :targetList ({RESTARGET :name <> :indirection <> :val {A_CONST :val 1 :location 7} :location 7}) :fromClause <> :whereClause <> :groupClause <> :havingClause <> :windowClause <> :valuesLists <> :sortClause <> :limitOffset <> :limitCount <> :lockingClause <> :withClause <> :op 0 :all false :larg <> :rarg <>})

# Parse a query into JSON
echo 'SELECT 1' | ./queryparser --json

# [{"SELECT": {"distinctClause": null, "intoClause": null, "targetList": [{"RESTARGET": {"name": null, "indirection": null, "val": {"A_CONST": {"val": 1, "location": 7}}, "location": 7}}], "fromClause": null, "whereClause": null, "groupClause": null, "havingClause": null, "windowClause": null, "valuesLists": null, "sortClause": null, "limitOffset": null, "limitCount": null, "lockingClause": null, "withClause": null, "op": 0, "all": false, "larg": null, "rarg": null}}]
```



Contributors
------------
- [David Merriman](https://github.com/davidjmerriman)
 
This repository was forked from [queryparser](https://github.com/pganalyze/queryparser), which was created by:

- [Michael Renner](https://github.com/terrorobe)
- [Christian Hofstaedtler](https://github.com/zeha)
- [Lukas Fittl](mailto:lukas@fittl.com)
- [Phillip Knauss](https://github.com/phillipknauss)

License
-------

Copyright (c) 2015, David Merriman <merriman.david.j@gmail.com><br>
Copyright (c) 2014, pganalyze Team <team@pganalyze.com><br>
queryparser is licensed under the 3-clause BSD license, see LICENSE file for details.
