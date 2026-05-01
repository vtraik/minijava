GEN_DIR := generated
BIN := bin
GRAMMAR := grammar

all: compile

compile: $(GEN_DIR) $(BIN)
	java -jar jtb132di.jar -te $(GRAMMAR)/minijava.jj
	mv $(GRAMMAR)/minijava-jtb.jj $(GEN_DIR)/
	java -jar javacc5.jar -OUTPUT_DIRECTORY=$(GEN_DIR) $(GEN_DIR)/minijava-jtb.jj
	javac -d $(BIN) \
		src/*.java \
		$(GEN_DIR)/*.java \
		visitor/*.java \
		syntaxtree/*.java

$(GEN_DIR):
	mkdir -p $(GEN_DIR)

$(BIN):
	mkdir -p $(BIN)

clean:
	rm -rf $(BIN) $(GEN_DIR) visitor syntaxtree
