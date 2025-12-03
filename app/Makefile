# ==============================================================================
# Makefile for mORMot 2 Application
# Located in: /app
# Assumes structure: /app/mORMot2, /app/src, /app/Makefile
# ==============================================================================

# --- Project Configuration ---
PROJECT_NAME = webapp
FPC = fpc
MAIN_SRC = src/main.dpr
SRCS = src/webapp.pas

# mORMot2 はホストには存在せず、Docker ビルド時に /app/mORMot2 へ取得されます。
# この Makefile はコンテナ内での実行を前提としています。
MORMOT2_ROOT = mORMot2

# --- Target Environment (FPC variables will be resolved at runtime) ---
TARGET_CPU = x86_64
TARGET_OS = linux

# --- Output Directories ---
BUILD_DIR = build
#UNIT_OUT_DIR = $(BUILD_DIR)/objs/$(TARGET_CPU)-$(TARGET_OS)
EXE_DIR = $(BUILD_DIR)/release

# --- 1. Unit Search Paths (-Fu) ---
CORE_PATHS = \
    -Fu$(MORMOT2_ROOT)/src \
    -Fu$(MORMOT2_ROOT)/src/core \
    -Fu$(MORMOT2_ROOT)/src/crypt \
    -Fu$(MORMOT2_ROOT)/src/db \
    -Fu$(MORMOT2_ROOT)/src/lib \
    -Fu$(MORMOT2_ROOT)/src/net \
    -Fu$(MORMOT2_ROOT)/src/orm \
    -Fu$(MORMOT2_ROOT)/src/rest \
    -Fu$(MORMOT2_ROOT)/src/soa \
    -Fu$(MORMOT2_ROOT)/src/script \
    -Fu$(MORMOT2_ROOT)/src/misc \
    -Fu$(MORMOT2_ROOT)/src/tools/mget

UNIT_PATHS = $(CORE_PATHS)

# --- 2. Compiler Defines (-d) ---
DEFINES = \
    -dFPCMM_SERVER \
    -dNOSYNDBZEOS \
    -dNOSYNDBIBX

# --- 3. Linker Options (-Fl for static libraries) ---
LINK_OPTS = -Fl$(MORMOT2_ROOT)/static/$(TARGET_CPU)-$(TARGET_OS)

# --- 4. Common Compiler Options ---
COMMON_OPTS = \
    -Mobjfpc \
    -O3 \
    $(DEFINES) \
    $(LINK_OPTS) \
    $(UNIT_PATHS)
#    -Fu$(UNIT_OUT_DIR) \

# ==============================================================================
# Targets
# ==============================================================================

all: $(EXE_DIR)/$(PROJECT_NAME)
.PHONY: all

# Executable Target
$(EXE_DIR)/$(PROJECT_NAME): $(MAIN_SRC) $(SRCS)
	@echo "--- Creating Output Directories (for executable) ---"
#	@mkdir -p $(UNIT_OUT_DIR)
	@mkdir -p $(EXE_DIR)
	@echo "--- Compiling $(PROJECT_NAME) ---"
	$(FPC) $(COMMON_OPTS) -FE$(EXE_DIR) -o$(PROJECT_NAME) $<
	@echo "--- Build successful: $(BUILD_DIR)/$(PROJECT_NAME) ---"

# Clean up intermediate (.ppu, .o) and executable files
clean:
	@echo "--- Cleaning up build artifacts ---"
	@rm -rf $(BUILD_DIR)

.PHONY: clean