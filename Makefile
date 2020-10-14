all: generator

%: %.c

.PHONY: clean
clean:
	find . -maxdepth 1 -type f -name "*.csv" -delete 
	rm -rf generator courses

