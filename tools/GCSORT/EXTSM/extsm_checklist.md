# 📋 LIBGCS / EXTSM Integration & Execution Checklist

This checklist traces the lifecycle of a Sort/Merge operation from the initial COBOL program invocation down to the low-level processing layers of `libgcs`.

## 1. Environment & Runtime Initialization Phase
- [ ] **Preload Configuration:** The operating system loads the unified library via `COB_PRELOAD` to capture file handling routines seamlessly without cross-platform symbol collisions.
- [ ] **Context Detection (`gcs_check_cobol_runtime`):** The engine inspects the calling process context.
  - *If `GCS_CALLER_CBL` (1):* Confirms it was invoked natively inside a pre-existing COBOL runtime environment.
  - *If `GCS_CALLER_C` (2):* Dynamically attaches to `libcob` via system handles, spins up a headless workspace (`cob_init_nomain`), and provisions a mock module definition (`extsm`).
- [ ] **Core Setup (`gcs_sort_init`):** Instantiates the internal job tracker (`struct job_t`), configures baseline memory allocation limits, and registers thread execution stacks.

## 2. EXTSM Interfacing & Metadata Extraction (`FA01` / `FA40`)
- [ ] **Opcode Routing:** The COBOL `CALL "EXTSM"` statement delivers an operation flag alongside the **FCD3** interface block.
- [ ] **Operation Mode Setup:** The bridge translates the control flags to set the core operational target:
  - Sets the primary operation mode (`'S'` for Sort, `'M'` for Merge, `'C'` for Copy) via `gcs_sort_set_oper`.
- [ ] **Key Definition Parsing (`get_key_definition`):** Decodes big-endian native metadata out of the Key Descriptor Block (`KDB`).
  - Extracts key positions, segment lengths, and sorting order (Ascending vs Descending).
  - Loops key fields into `gcs_sort_init_key`, converting alphanumeric, floating point, packed-decimal, or zoned representations into optimized backend types.
- [ ] **File Binding (`load_use_files` & `load_give_files`):** Parses the internal File Descriptor Table (`FDB`).
  - Identifies data layouts (Fixed `F` vs Variable `V`), records minimum/maximum length constraints, and assigns underlying organization definitions.

## 3. Data Accumulation & Memory Management Phase
- [ ] **Record Ingestion Loop (`FAF3 RELEASE`):** Pushes raw data slices from the application runtime space straight into the backend memory array using `gcs_LoadInMemory`.
- [ ] **Memory Boundary Tracking:** Monitored boundaries (`nLim01` / `nLim02`) prevent memory leaks and buffer overflows.
- [ ] **Pivoting to Disk Cache (Segmentation):** 
  - Detects if the operational dataset volume outstrips physical memory parameters.
  - Spits sorted memory chunks onto the local file system as temporary scratchpad tracks (`gcs_save_tempfile`).
  - Resets internal index pointers, flushes temporary workspace structures, and resumes inbound intake.

## 4. Execution & Finalization Phase
- [ ] **Sequence Resolution Trigger (`FA10 EOF`):** Signals that the inbound dataset pipeline has ended, unlocking execution paths.
- [ ] **Physical Processing Engine execution:**
  - *In-Memory Path:* Runs sorting workflows directly inside core memory space.
  - *On-Disk Segmented Path:* Initializes `Job_tmpfile_t` to link up to 16 active concurrent scratch files.
- [ ] **Result Extraction (`FAF5 RETURN`):** 
  - Loops over data elements to present items back to the caller.
  - Uses a multi-way merge processing routine (`gcs_tmpfile_get`) to evaluate file blocks, shifting the ordered records back into the FCD record pointer (`fcd->recPtr`).
- [ ] **Resource Demolition (`FA88 CLEANUP`):**
  - Closes and clears active file stream descriptors.
  - Unlinks and purges all temporary scratchpad cache files (`remove`) from disk space.
  - Frees structural heaps, unbinds context references (`cob_tidy`), and returns control to the master execution environment.
