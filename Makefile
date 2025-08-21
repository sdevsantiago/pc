# ******************************* Output files ******************************* #

# Executable file name
NAME = pc

# ************************** Compilation variables *************************** #

# Compiler
CC = cc

# Compilation flags
CFLAGS = -Wall -Wextra -Werror -Wunreachable-code
# Additional headers
HEADERS = -I $(INCLUDE_PATH)

# Debug flags, execute with DEBUG=1 -> make DEBUG=1
DFLAGS = -g3
ifeq ($(DEBUG), 1)
	CFLAGS += $(DFLAGS)
endif

# Make command with no-print-directory flag
MAKE += --no-print-directory

# ****************************** Source files ******************************** #

# Source files path
SRC_PATH = src

# Source files
SRC = \
	$(SRC_PATH)/pc.c

# Include path
INCLUDE_PATH = ./include

# ****************************** Object files ******************************** #

# Object files path
OBJS_PATH = build

# Source files and destination paths
OBJS = $(SRC:$(SRC_PATH)/%.c=$(OBJS_PATH)/%.o)

# Compile as object files
$(OBJS_PATH)/%.o: $(SRC_PATH)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@ $(HEADERS)

# ********************************* Rules ************************************ #

# Compile all
all: $(NAME)
.PHONY: all

# Compile project
$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LIBS) -o $(NAME)

# Clean object files
clean:
	rm -rf $(OBJS_PATH)
.PHONY: clean

# Clean object files, binaries and packages
fclean: clean
	rm -f $(NAME)
	rm -rf $(NAME)-$(VERSION)*
.PHONY: fclean

# Recompile
re: fclean all
.PHONY: re

# ********************************* Libraries ******************************** #

LIBS = -lcurses

# ********************************** Package ********************************* #

VERSION = $(shell cat package/DEBIAN/control | grep Version | cut -d ' ' -f 2)

# Create and install package
install: package
	sudo dpkg -i $(NAME)-$(VERSION).deb
.PHONY: install

# Uninstall package
uninstall:
	sudo dpkg --purge $(NAME)
.PHONY: uninstall

# Create package
package: re
	mkdir -p $(NAME)-$(VERSION)/usr/local/bin
	cp $(NAME) $(NAME)-$(VERSION)/usr/local/bin
	cp -r package/DEBIAN $(NAME)-$(VERSION)
	chmod -R 755 $(NAME)-$(VERSION)
	dpkg-deb --build $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)
.PHONY: package
