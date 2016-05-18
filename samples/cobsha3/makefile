all:	SHAKE128.dll SHAKE256.dll SHA3-224.dll \
        SHA3-256.dll SHA3-384.dll SHA3-512.dll KECCAK.o \
        TESTSHA3.exe

TESTSHA3.exe:	TESTSHA3.cob
	cobc -x -free TESTSHA3.cob
        
SHAKE128.dll:	SHAKE128.cob KECCAK.o
	cobc -m -free SHAKE128.cob KECCAK.o
    
SHAKE256.dll:	SHAKE256.cob KECCAK.o
	cobc -m -free SHAKE256.cob KECCAK.o
    
SHA3-224.dll:	SHA3-224.cob KECCAK.o
	cobc -m -free SHA3-224.cob KECCAK.o

SHA3-256.dll:	SHA3-256.cob KECCAK.o
	cobc -m -free SHA3-256.cob KECCAK.o
    
SHA3-384.dll:	SHA3-384.cob KECCAK.o
	cobc -m -free SHA3-384.cob KECCAK.o
    
SHA3-512.dll:	SHA3-512.cob KECCAK.o
	cobc -m -free SHA3-512.cob KECCAK.o
    
KECCAK.o:	KECCAK.cob
	cobc -c -free KECCAK.cob
    
clean:
	rm KECCAK.o
	rm KECCAK.dll
	rm SHAKE128.dll
	rm SHAKE256.dll
	rm SHA3-224.dll
	rm SHA3-256.dll
	rm SHA3-384.dll
	rm SHA3-512.dll
	rm TESTSHA3.exe
