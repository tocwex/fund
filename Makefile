BASE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BASE_NAME := $(shell basename $(BASE_DIR))

IN_SHIP ?= zod
# NOTE: Urbit-compliant name of project root directory
IN_DESK ?= $(shell echo $(BASE_NAME) | sed -e "s/[^a-z0-9]/-/g" -e "s/^[^a-z]/x/g")
IN_RVER ?= 0.0.0

OUT_DIR = $(BASE_DIR)/out
SRC_DIR = $(BASE_DIR)/src
DESK_DIR = $(OUT_DIR)/desk
EXEC_DIR = $(OUT_DIR)/exec

DESK_FILES := $(shell find $(SRC_DIR) -type f)
PERU_FILE := $(BASE_DIR)/.peru/lastimports
LISC_FILE := $(BASE_DIR)/LICENSE.txt
SLUP := $(EXEC_DIR)/slup

define HELP_MESSAGE
usage: make {help|desk|ship-desk|release}
generate build artifacts for an urbit ship (run 'durploy ship zod' first)

  make help : show this help message

  make desk : build the desk from dependencies
  make ship-desk IN_SHIP=zod : build desk and deploy to ship 'zod'

  make release IN_SHIP=zod IN_RVER=1.2.3 :
    ship desk to 'zod' and perform a release at verion '1.2.3'
    (see '$(SLUP) -h' for details)
endef
export HELP_MESSAGE


.PHONY : all help release ship-desk ship-glob desk glob tidy clean phony

all : desk glob

help :
	@echo "$$HELP_MESSAGE"


release : $(DESK_DIR) $(SLUP)
	$(SLUP) $(IN_RVER)
	cp -r $(SRC_DIR)/* $(DESK_DIR)
	touch $(DESK_DIR)
	durploy desk $(IN_SHIP) $(IN_DESK) $(DESK_DIR)/

ship-desk : $(DESK_DIR)
	durploy desk $(IN_SHIP) $(IN_DESK) $(DESK_DIR)/
desk : $(DESK_DIR)
$(DESK_DIR) : $(DESK_FILES) $(LISC_FILE) $(PERU_FILE) $(OUT_DIR)
	cp -r $(SRC_DIR)/* $(DESK_DIR)
	cp $(LISC_FILE) $(DESK_DIR)/license.txt
	touch $(DESK_DIR)

$(OUT_DIR) $(EXEC_DIR) :
	mkdir -p $@

$(SLUP) : $(PERU_FILE)
$(PERU_FILE) : phony
	peru sync -v


phony :

tidy : clean
clean :
	rm -rf $(OUT_DIR)
