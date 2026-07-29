LLVM_DIR=/usr/lib/llvm-20

TARGET=generate

SOURCE_FILES=main.cpp core.cpp parse.cpp database.cpp
OBJ_FILES=$(addsuffix .o,$(SOURCE_FILES))
DEP_FILES=$(addsuffix .d,$(SOURCE_FILES))

BUILD_DIR=.build
INCLUDE_DIRS=$(LLVM_DIR)/include .
LIBS=clang
LIB_DIRS=$(LLVM_DIR)/lib

CXX=g++
CXX_FLAGS=-g -O0 -Wextra

all: $(TARGET)

$(TARGET): $(addprefix $(BUILD_DIR)/,$(OBJ_FILES))
	$(CXX) $(CXX_FLAGS) $(addprefix -L,$(LIB_DIRS)) $^ $(addprefix -l,$(LIBS)) -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	@ mkdir -p $(@D)
	$(CXX) $(CXX_FLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -MMD -MP -MF$(BUILD_DIR)/$*.cpp.d -c $< -o $@

$(addprefix $(BUILD_DIR)/,$(DEP_FILES)):

include $(addprefix $(BUILD_DIR)/,$(DEP_FILES))

clean:
	rm -rf $(BUILD_DIR)

fclean: clean
	rm -f $(TARGET)

re: fclean all

.PHONY: all clean fclean re


