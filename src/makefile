# Makefile for CatFoodServer

TARGET = GoodMorningServer
DB = $(TARGET)/DB
DB_MODELS = $(DB)/Models
DB_QUERIES = $(DB)/Queries
DB_SEEDS = $(DB)/Seeds
HANDLERS = $(TARGET)/Handlers
ROUTINGS = $(TARGET)/Routings
UTILS = $(TARGET)/Utils
OS = $(shell uname)

SWIFT_FILES = $(DB)/ConfigDB.swift\
		$(DB_MODELS)/Contact.swift\
		$(DB_MODELS)/Greeting.swift\
		$(DB_MODELS)/Interaction.swift\
		$(DB_MODELS)/User.swift\
		$(DB_QUERIES)/ContactQuery.swift\
		$(DB_QUERIES)/GreetingQuery.swift\
		$(DB_QUERIES)/InteractionQuery.swift\
		$(DB_QUERIES)/UserQuery.swift\
		$(DB_SEEDS)/GreetingSeed.swift\
		$(DB_SEEDS)/InteractionSeed.swift\
		$(DB_SEEDS)/SeedProtocol.swift\
		$(DB_SEEDS)/UserSeed.swift\
		$(HANDLERS)/ContactHandler.swift\
		$(HANDLERS)/GreetingHandler.swift\
		$(HANDLERS)/InteractionHandler.swift\
		$(HANDLERS)/UserHandler.swift\
		$(ROUTINGS)/ConfigRouting.swift\
		$(ROUTINGS)/ContactRouting.swift\
		$(ROUTINGS)/GreetingRouting.swift\
		$(ROUTINGS)/InteractionRouting.swift\
		$(ROUTINGS)/UserRouting.swift\
		$(UTILS)/ErrorsManager.swift\
		$(UTILS)/Parser.swift\
		$(UTILS)/Types.swift

PERFECT_ROOT = /app/.delta/usr/src/perfect/PerfectLib

DEBUG = -g -Onone -Xcc -DDEBUG=1
SWIFTC = swift
SWIFTC_FLAGS = -frontend -c $(DEBUG) -module-cache-path $(MODULE_CACHE_PATH) -emit-module \
                -I /app/.delta/usr/local/lib \
                -I /app/.delta/usr/include \
                -I /app/.delta/usr/include/x86_64-linux-gnu \
                -I $(PERFECT_ROOT)/linked/LibEvent \
                -I $(PERFECT_ROOT)/linked/OpenSSL_Linux \
                -I $(PERFECT_ROOT)/linked/ICU \
                -I $(PERFECT_ROOT)/linked/SQLite3 \
                -I $(PERFECT_ROOT)/linked/LinuxBridge \
                -I $(PERFECT_ROOT)/linked/cURL_Linux
MODULE_CACHE_PATH = /tmp/modulecache
Linux_SHLIB_PATH = $(shell dirname $(shell dirname $(shell which swiftc)))/lib/swift/linux
SHLIB_PATH = -L$($(OS)_SHLIB_PATH)

Perfect_FLAGS = $(SHLIB_PATH) -luuid -lswiftCore -lswiftGlibc /app/.delta/usr/local/lib/PerfectLib.so \
                -Xlinker -rpath -Xlinker $($(OS)_SHLIB_PATH) -shared
PostgreSQL_FLAGS = $(SHLIB_PATH) -luuid -lswiftCore -lswiftGlibc /app/.delta/usr/local/lib/PostgreSQL.so \
                -Xlinker -rpath -Xlinker $($(OS)_SHLIB_PATH) -shared

all: Postgre

install:
        mv $(TARGET).so ../PerfectLibraries

modulecache:
        @mkdir -p $(MODULE_CACHE_PATH)

$(TARGET): modulecache
        @mkdir -p $(MODULE_CACHE_PATH)

$(TARGET): modulecache
        $(SWIFTC) $(SWIFTC_FLAGS) $(SWIFT_FILES) -o $@.o -module-name $@ -emit-module-path $@.swiftmodule
        clang++ $(Perfect_FLAGS) $@.o -o $@.so

Postgre: $(TARGET)
        cd /app/.delta/usr/src/perfect/Connectors/PostgreSQL && make && cd ../..
        clang++ $(PostgreSQL_FLAGS) $(TARGET).o -o $(TARGET).so

clean:
        @rm *.o