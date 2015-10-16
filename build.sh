#!/bin/bash -e

# TODO: This is looking more and more like a makefile....make it one!

# If not present, get postgres source with json outfunc, configure, and make
if [ ! -d postgresql ]; then
    echo "PostgreSQL source not found, cloning from github..."
    git clone --depth 1 https://github.com/pganalyze/postgres.git postgresql
fi

cd postgresql
if [ ! -f src/backend/parser/parser.o ]; then
    echo "PostgreSQL binaries not found, making..."
    git checkout -- .
    if [ `uname -s` = "Darwin" ]; then
        echo "Configuring for Mac..."
        ./configure
    elif [ `uname -s` = "Linux" ]; then
        echo "Configuring for Linux..."
        ./configure
    else
        # Hopefully we're running MinGW; Cygwin will produce binaries dependent on cygwin1.dll
        echo "Configuring for Windows/MinGW32..."
        ./configure --without-zlib --disable-integer-datetimes --host=i686-w32-mingw32
    fi
    make
fi

cd src

# Set up to build the query parser
CPPFLAGS="-s -O2 -Wall -Wmissing-prototypes -Wpointer-arith -Wdeclaration-after-statement -Wendif-labels -Wmissing-format-attribute -Wformat-security -fno-strict-aliasing -fwrapv -Wl,--allow-multiple-definition "

LIBFLAGS="-lm"
INCLUDE="-Iinclude"
EXENAME="../../queryparser"

if [ `uname -s` = "Darwin" ]; then
    EXENAME+="mac"
elif [ `uname -s` = "Linux" ]; then
    EXENAME+="linux"
else
    EXENAME+="win"
    LIBFLAGS+=" -lws2_32 -lsecur32"
    INCLUDE+=" -Iinclude/port/win32"
fi

OBJFILES=`find backend -name '*.o' | egrep -v '(main/main\.o|snowball|libpqwalreceiver|conversion_procs)' | xargs echo`
OBJFILES+=" timezone/localtime.o timezone/strftime.o timezone/pgtz.o"
OBJFILES+=" common/libpgcommon_srv.a port/libpgport_srv.a"

# Build the query parser
echo "Building queryparser..."
gcc $CPPFLAGS -Lport -Lcommon $INCLUDE ../../queryparser.c $OBJFILES $LIBFLAGS -o $EXENAME
