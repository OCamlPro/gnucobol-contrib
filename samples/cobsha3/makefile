all:	SHAKE128.dll SHAKE256.dll SHA3-224.dll \
        SHA3-256.dll SHA3-384.dll SHA3-512.dll KECCAK.o \
        TESTSHA3.exe SHA3-512.o   SESSION-ID.o TEST-SESSION-ID.exe

# SESSION-ID        
TEST-SESSION-ID.exe:	TEST-SESSION-ID.cob
	cobc -x -free TEST-SESSION-ID.cob

SESSION-ID.o:	SESSION-ID.cob SHA3-512.o KECCAK.o
	cobc -m -free SESSION-ID.cob SHA3-512.o KECCAK.o
    
SHA3-512.o:	SHA3-512.cob
	cobc -c -free SHA3-512.cob

# SHA3    
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
	rm SHA3-256.o
	rm SESSION-ID.dll
	rm TEST-SESSION-ID.exe
