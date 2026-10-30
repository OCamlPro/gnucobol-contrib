# LIBGCS / GCSORT - Core Engine & Runtime Interface Module

The **LIBGCS** module represents the core framework of **GCSORT**. It implements the low-level processing logic for sorting, merging, and file management, while providing a cross-platform interface capable of operating both inside native COBOL application loops and standalone pure C runtime environments.

---

## 🚀 System Integration & Environment Variables

When running unified binaries (`EXTSM`), the library hooks into the GnuCOBOL runtime via custom file handlers. Configure your environment paths as follows to prevent recursive dynamic-link loops:

### 🐧 Linux / UNIX Environment
```bash
export COB_PRELOAD="/opt/libs/libEXTSM.so"
export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
export COB_LIBRARY_PATH=".:$COB_LIBRARY_PATH"
```

### 🪟 Windows Environment
```cmd
:: Preload the unified library into memory
set COB_PRELOAD=C:\(\path\to\libraries\EXTSM.\)dll

:: 1. Insert the current folder into PATH so explicit CALLs find the same DLL
set PATH=.;%PATH%

:: 2. Start the COBOL program
your_program.exe
```

---

## 🧠 Dynamic Runtime Detection (Pure C vs. COBOL)

A core feature of `libgcs` is its safety-net detection system handled by **`gcs_check_cobol_runtime()`**. It checks if the program was initiated by a COBOL driver or a standalone C application:
1. **COBOL Caller:** Detects existing active standard environments (`libcob`). It safely skips internal setups to rely on the parent thread configuration.
2. **C Caller:** Dynamically loads symbols (`cob_is_initialized`, `cob_init_nomain`) via cross-platform platform hooks. It programmatically instantiates a headless `nomain` runtime environment and registers a mock tracking module structure (`extsm`).

---

## 🛠️ Global API & Life Cycle Functions

### Constants & Configuration Macros
* **`LIBGCS_VERSION` / `EXTSM_VERSION`**: Defined as `"01.00.00"`.
* **Collating Sequence (`enum cb_colseq`)**: Supports `CB_COLSEQ_NATIVE` (0), `CB_COLSEQ_ASCII` (1), and `CB_COLSEQ_EBCDIC` (2).

### Initialization & Lifecycle
* **`gcs_sort_init()`**: Main entry lifecycle initializer. Initializes the execution environment, resets structural pointers, and validates memory.
* **`gcs_init_cob()`**: Initializes the COBOL runtime environment and provisions global module attributes.
* **`gcs_sort_enable_multithread(int nThread)`**: Enables multi-threaded processing with a specified number of worker threads.
* **`gcs_sort_check(struct job_t* job)`**: Validates the consistency and structural integrity of the specified job definition.
* **`gcs_sort_cleanup()`**: Safely destroys active job structures, flushes internal frameworks, and cleans the environment.

### Job Processing Configuration
* **`gcs_sort_set_oper(char c)`**: Configures the primary execution path pipeline (`'S'` for Sort, `'M'` for Merge, `'C'` for Copy).
* **`gcs_sort_init_key(int position, int length, const char* ctype, const char* cdirection)`**: Builds structural constraints for indexed keys (position, length, data type, and direction rules).
* **`gcs_sort_use(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen)`**: Registers configurations for input source resources (`USING`), specifying layout constraints and organization parameters.
* **`gcs_sort_give(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen)`**: Registers configurations for target output resources (`GIVING`).
* **`gcs_sort_add_key(int position, int length, char* keyType, char* keyCollating)`**: Adds supplementary key definitions specifically for Indexed file organizations.

### Collating & Character Set Mapping
* **`gcs_cb_sign(int ns)`**: Configures sign behavior (`0` for ASCII, `1` for EBCDIC).
* **`gcs_colseq(int ns)`**: Sets the active collating sequence mode.
* **`gcs_ebcdic_table(unsigned char* etab)`**: Maps custom translation tables for EBCDIC data streams.

### INREC & OUTREC Record Reformatting Functions
Both `inrec` (input reformatting) and `outrec` (output reformatting) share parallel structural methods:
* **`gcs_inrec_range(int pos, int len)` / `gcs_outrec_range(int pos, int len)`**: Defines a direct positional slice to retain from the record.
* **`gcs_inrec_substnchar(int nPosAbs, unsigned char* sType, unsigned char* strValue)` / `gcs_outrec_substnchar(...)`**: Substitutes characters at an absolute position based on type (`C` for char, `X` for hex, `Z` for binary zero) and value.
* **`gcs_inrec_range_position(int nPosAbs, int nPos, int nLen)` / `gcs_outrec_range_position(...)`**: Re-maps a specific data range into an absolute target position.
* **`gcs_inrec_subst(int nOccur, unsigned char* p1)` / `gcs_outrec_subst(...)`**: Replaces chunks using occurrence fill patterns.
* **`gcs_inrec_padding(int nPosAbs, int nOccur, unsigned char* p1, int nPosAbsRec)` / `gcs_outrec_padding(...)`**: Appends structural padding bytes to align records.

### Engine Operations & Core Execution
* **`gcs_sort_run()`**: Main thread supervisor. Reads inputs, sorts datasets, executes multi-threaded pipelines, and writes outputs.
* **`gcs_sort_LoadFile()`**: Loops across source files and processes iterative chunk data transfers into volatile buffers.
* **`gcs_LoadInMemory(struct job_t* job, char* szBuffRek, char* szBuffKey, int nLenRek, int nSplitBuf, int nIdxFileIn, int64_t nLim01, int64_t nLim02)`**: Fast inline memory injector that transfers data chunks while continuously validating threshold alignment boundaries (`nLim01` / `nLim02`).
* **`gcs_save_out(struct job_t* job)`**: Commits the sorted and processed record streams into the final output targets.

### Runtime Analytics & Statistics
* **`gcs_stats_rec_total()`**: Returns the total number of processed records.
* **`gcs_stats_rec_writesort()`**: Returns the count of records injected into the sort pipeline.
* **`gcs_stats_rec_writeout()`**: Returns the count of successfully written output records.
* **`gcs_stats_rec_omitinclude()`**: Returns the count of records filtered out via OMIT/INCLUDE clauses.
* **`gcs_stats_rec_discardXSUM()`**: Returns the count of duplicate records discarded via XSUM constraints.
* **`gcs_get_returncode()`**: Retrieves the final execution status return code of the processing job.

---

## 🗄️ Multi-File Temporary Management Structure

When dataset processing boundaries overrun volatile memory thresholds, the engine pivots processing tasks into sequential temporary storage pools using the **`Job_tmpfile_t`** structure.

```c
struct Job_tmpfile_t {
    int  bIsEof[MAX_HANDLE_TEMPFILE];               // End-of-file tracking arrays
    int  handleTmpFile[MAX_HANDLE_TEMPFILE];        // Active operating system file descriptors
    int  byteReadTmpFile[MAX_HANDLE_TEMPFILE];      // Remaining buffer data tracking gauges
    struct mmfio_t* ArrayFile[MAX_HANDLE_TEMPFILE]; // Target references to mapped I/O descriptor elements
    unsigned char* ptrBuf[MAX_HANDLE_TEMPFILE];     // Current operational array cursor pointers
    unsigned char* recordBuffer;                    // Global memory buffer for streaming record updates
    unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE]; // Private working memory structures per file handle
    int  nLastRead;                                 // Last accessed array handle position
    int  nSumEof;                                   // Accumulated counter for completed storage lines
};
```

### Temporary I/O Methods
* **`gcs_tmpfile_init(struct job_t* job)`**: Prepares workspace partitions for up to `16` (`MAX_HANDLE_TEMPFILE`) disk scratchpad structures and binds memory-mapped I/O channels.
* **`gcs_tmpfile_get(struct job_t* job, struct Job_tmpfile_t* tmpf, FCD3* fcd)`**: Multi-way merge processing routine that extracts data segments and moves target pieces directly into runtime return structures.
* **`gcs_tmpfile_cleanup(struct job_t* job, struct Job_tmpfile_t* tmpf)`**: Shuts active data channels, frees record storage partitions, and safely unlinks physical disk cache segments.
* **`gcs_save_tempfile(struct job_t* job)` / `gcs_save_tempfinal(struct job_t* job)`**: Low-level stream routers that save active intermediate data states into temporary physical blocks.

---

## 🔧 Internal Mapping & Helper Routines
* **`gcs_job_constructor()` / `gcs_job_destructor()` / `gcs_job_destroy()`**: Internal structure wrappers to allocate and safely deallocate core `job_t` contexts.
* **`gcs_sort_getFileOrgName(int organization)`**: Translates internal integer tracking codes into human-readable File Organization names (e.g., Sequential, Relative, Indexed).
* **`gcs_sort_FileTypeFCD2GCS(int organization)`** / **`gcs_sort_DataTypeFCD2GCS(int nInteralType, int nLen)`**: Maps GnuCOBOL File Control Description (FCD) metadata types and layout formats into native internal `libgcs` structures.
