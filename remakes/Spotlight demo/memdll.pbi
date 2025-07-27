; *****************************************************************************
; MemDll.pb
; by Luis
; http://luis.no-ip.net
; *****************************************************************************

;{ Some annotations about the PE structure 

; +- [IMAGE_DOS_HEADER] --------------------------------------------------------+
; +     e_magic.w ($5A4D) 'MZ'
; +     e_cblp.w
; +     e_cp.w
; +     e_crlc.w
; +     e_cparhdr.w
; +     e_minalloc.w
; +     e_maxalloc.w
; +     e_ss.w
; +     e_sp.w
; +     e_csum.w
; +     e_ip.w
; +     e_cs.w
; +     e_lfarlc.w
; +     e_ovno.w
; +     e_res.w[4]
; +     e_oemid.w
; +     e_oeminfo.w
; +     e_res2.w[10]
; +     e_lfanew.l -> points to IMAGE_NT_HEADERS signature
; +-----------------------------------------------------------------------------+

; +                                DOS STUB
; +-----------------------------------------------------------------------------+
; + DOS executable printing "This program cannot be run in DOS mode"             
; +-----------------------------------------------------------------------------+

;                       PE HEADER = IMAGE_NT_HEADERS =
;           Signature + IMAGE_FILE_HEADER + IMAGE_OPTIONAL_HEADER

; +- [IMAGE_NT_HEADERS] --------------------------------------------------------+
; +     Signature.l ; $00004550 'PE00'
; +- [IMAGE_FILE_HEADER] -------------------------------------------------------+
; +     Machine.w
; +     NumberOfSections.w ; This indicates the size of the section table, which immediately follows the headers.
; +     TimeDateStamp.l
; +     PointerToSymbolTable.l
; +     NumberOfSymbols.l
; +     SizeOfOptionalHeader.w
; +     Characteristics.w ; Flags that indicate attributes of the object or image file.
; +- [IMAGE_OPTIONAL_HEADER] ---------------------------------------------------+
; + (COFF FIELDS) 
; +     Magic.w
; +     MajorLinkerVersion.b
; +     MinorLinkerVersion.b
; +     SizeOfCode.l
; +     SizeOfInitializedData.l ; Size of the initialized data section, or the sum of all such sections if there are multiple data sections.
; +     SizeOfUninitializedData.l ; Size of the uninitialized data section, or the sum of all such sections if there are multiple sections.
; +     AddressOfEntryPoint.l ; VRA of the entry point (optional for DLLs)
; +     BaseOfCode.l
; +     BaseOfData.l
; + (WINDOWS FIELDS)
; +     ImageBase.i ; The preferred address of the first byte of image when loaded into memory (in other words, of a module)
; +     SectionAlignment.l ; The alignment of sections when they are loaded in memory. It must be greater than or equal to FileAlignment. The default is the page size.
; +     FileAlignment.l ; The alignment used for sections in the image file. If the SectionAlignment is less than page size, then FileAlignment must match SectionAlignment.
; +     MajorOperatingSystemVersion.w
; +     MinorOperatingSystemVersion.w
; +     MajorImageVersion.w
; +     MinorImageVersion.w
; +     MajorSubsystemVersion.w
; +     MinorSubsystemVersion.w
; +     Win32VersionValue.l
; +     SizeOfImage.l  ; The amount of space to reserve in the virtual address space for the loaded executable image. It should be a multiple of SectionAlignment.
; +     SizeOfHeaders.l ; How much space in the file is used for all the file headers, including the MS-DOS header, PE file header, PE optional header, and the sections headers.
; +     CheckSum.l
; +     Subsystem.w
; +     DllCharacteristics.w
; +     SizeOfStackReserve.i
; +     SizeOfStackCommit.i
; +     SizeOfHeapReserve.i
; +     SizeOfHeapCommit.i
; +     LoaderFlags.l
; +     NumberOfRvaAndSizes.l ; The number of the following data directory entries (should always be 16, but could change in the future).
; +- [IMAGE_DATA_DIRECTORY] ----------------------------------------------------+ repeated x [IMAGE_OPTIONAL_HEADER].NumberOfRvaAndSizes
; +     VirtualAddress.l -> RVA of the first structure associated with this specific directory entry (IMAGE_EXPORT_DIRECTORY, IMAGE_IMPORT_DESCRIPTOR, etc.)
; +     Size.l
; +-----------------------------------------------------------------------------+

;                              SECTION HEADERS 
; +- [IMAGE_SECTION_HEADER] ----------------------------------------------------+ repeated x [IMAGE_FILE_HEADER].NumberOfSections 
; +     SecName.b[8]
; +     StructureUnion
; +      PhysicalAddr.l
; +      VirtualSize.l ; The total size of the section when loaded into memory. If this value is greater than SizeOfRawData, the section is zero-padded. 
; +     EndStructureUnion
; +     VirtualAddress.l ; For executable images, the RVA of the first byte of the section.
; +     SizeOfRawData.l ; The size of the initialized data on disk. When a section contains only uninitialized data, this field should be zero.
; +     PointerToRawData.l ; The file pointer to the first page of the section. For executable images, this must be a multiple of FileAlignment from the optional header.
; +     PointerToRelocations.l
; +     PointerToLinenumbers.l
; +     NumberOfRelocations.w
; +     NumberOfLinenumbers.w
; +     Characteristics.l
; +-----------------------------------------------------------------------------+

;                                  SECTIONS 
; +-----------------------------------------------------------------------------+ repeated x [IMAGE_FILE_HEADER].NumberOfSections 
; + Various sections follow here, the contents of the raw data is depending on 
; + the section's type.
; + Some of the most notable are listed below ...
; +-----------------------------------------------------------------------------+

;                                IMPORT SECTION 
;                         (MS usually call it .idata)
; +- [IMAGE_IMPORT_DESCRIPTOR] -------------------------------------------------+ repeated x n times (zero terminated)
; +  OriginalFirstThunk.l -> points to an array of IMAGE_THUNK_DATA
; +  EndStructureUnion
; +  TimeDateStamp.l
; +  ForwarderChain.l
; +  Name.l
; +  FirstThunk.l
; +
; + The array is terminated by a IMAGE_IMPORT_DESCRIPTOR containing all zeroes.
; +-----------------------------------------------------------------------------+

;                                EXPORT SECTION 
;                          (MS usually call it .edata)
; +-----------------------------------------------------------------------------+
;                                     ...
; +-----------------------------------------------------------------------------+

;                              RELOCATION SECTION 
;                          (MS usually call it .reloc)
; +-----------------------------------------------------------------------------+
;                                     ...
; +-----------------------------------------------------------------------------+

;}


Module MemDll

EnableExplicit

#DEBUG_VERBOSE = 0 ; only for testing 
#DEBUG_FORCE_RELOCATION = 0 ; only for testing

Structure IMAGE_IMPORT_DESCRIPTOR ; from winnt.h
 OriginalFirstThunk.l    
 TimeDateStamp.l
 ForwarderChain.l
 Name.l
 FirstThunk.l
EndStructure

Structure IMAGE_THUNK_DATA ; from winnt.h
 StructureUnion
  ForwarderString.i
  Function.i
  Ordinal.i
  AddressOfData.i
 EndStructureUnion        
EndStructure

Structure IMAGE_IMPORT_BY_NAME ; from winnt.h
 Hint.w ; some linkers may set this value to 0
 Name.a[0]
EndStructure

Structure IMAGE_BASE_RELOCATION ; from winnt.h
 VirtualAddress.l
 SizeOfBlock.l
EndStructure

#IMAGE_DOS_SIGNATURE = $5A4D        ; MZ (Mark Zbikowski's DOS format)
#IMAGE_NT_SIGNATURE =  $00004550    ; PE00 (PE format)

#IMAGE_NT_OPTIONAL_HDR32_MAGIC = $010B ; 32 bit PE
#IMAGE_NT_OPTIONAL_HDR64_MAGIC = $020B ; 64 bit PE

#IMAGE_REL_BASED_ABSOLUTE = 0
#IMAGE_REL_BASED_HIGH = 1
#IMAGE_REL_BASED_LOW = 2
#IMAGE_REL_BASED_HIGHLOW = 3
#IMAGE_REL_BASED_HIGHADJ = 4
#IMAGE_REL_BASED_MIPS_JMPADDR = 5
#IMAGE_REL_BASED_DIR64 = 10

; file header characteristics 
#IMAGE_FILE_RELOCS_STRIPPED   = 1
#IMAGE_FILE_EXECUTABLE_IMAGE = 2
#IMAGE_FILE_LINE_NUMS_STRIPPED = 4
#IMAGE_FILE_LOCAL_SYMS_STRIPPED   = 8
#IMAGE_FILE_AGGRESIVE_WS_TRIM = 16
#IMAGE_FILE_LARGE_ADDRESS_AWARE   = 32
#IMAGE_FILE_BYTES_REVERSED_LO = 128
#IMAGE_FILE_32BIT_MACHINE = 256
#IMAGE_FILE_DEBUG_STRIPPED = 512
#IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP = 1024
#IMAGE_FILE_NET_RUN_FROM_SWAP = 2048
#IMAGE_FILE_SYSTEM = 4096
#IMAGE_FILE_DLL = 8192
#IMAGE_FILE_UP_SYSTEM_ONLY = 16384
#IMAGE_FILE_BYTES_REVERSED_HI = 32768

; data directories
#IMAGE_DIRECTORY_ENTRY_EXPORT = 0
#IMAGE_DIRECTORY_ENTRY_IMPORT = 1
#IMAGE_DIRECTORY_ENTRY_RESOURCE   = 2
#IMAGE_DIRECTORY_ENTRY_EXCEPTION = 3
#IMAGE_DIRECTORY_ENTRY_SECURITY   = 4
#IMAGE_DIRECTORY_ENTRY_BASERELOC = 5
#IMAGE_DIRECTORY_ENTRY_DEBUG = 6
#IMAGE_DIRECTORY_ENTRY_COPYRIGHT = 7 ; both are 7
#IMAGE_DIRECTORY_ENTRY_ARCHITECTURE   = 7 ; both are 7
#IMAGE_DIRECTORY_ENTRY_GLOBALPTR = 8
#IMAGE_DIRECTORY_ENTRY_TLS = 9
#IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG = 10
#IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT   = 11
#IMAGE_DIRECTORY_ENTRY_IAT = 12
#IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT   = 13
#IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR = 14

#IMAGE_SCN_CNT_CODE = 32
#IMAGE_SCN_CNT_INITIALIZED_DATA = 64
#IMAGE_SCN_CNT_UNINITIALIZED_DATA = 128
#IMAGE_SCN_MEM_DISCARDABLE = $2000000
#IMAGE_SCN_MEM_NOT_CACHED = $4000000
#IMAGE_SCN_MEM_NOT_PAGED = $8000000
#IMAGE_SCN_MEM_SHARED = $10000000                       
#IMAGE_SCN_MEM_EXECUTE = $20000000
#IMAGE_SCN_MEM_READ = $40000000
#IMAGE_SCN_MEM_WRITE = $80000000

CompilerIf (#PB_Compiler_Processor = #PB_Processor_x86)
#IMAGE_ORDINAL_FLAG = $80000000
CompilerElse   
#IMAGE_ORDINAL_FLAG = $8000000000000000
CompilerEndIf

Macro AlignAddressTo (a, b) 
(((a + (b - 1)) / b) * b)
EndMacro

Structure IMPORTED_LIBRARY
 ImportedDllName$
 ImportedDllHandle.i
EndStructure

Prototype.i DllMain (hDll, fdwReason, lpvReserved)

Structure DLL_MODULE
 *EntryPoint ; entry point for the specific module 
 List ImportedList.IMPORTED_LIBRARY() ; list of the DLL imported for the specific module
EndStructure 

Structure GLO
 Map ModulesMap.DLL_MODULE() ; map of all the modules loaded with MemDll::LoadLibrary() 
EndStructure : Global Glo.GLO


CompilerIf #DEBUG_VERBOSE = 1

Procedure ListAllExportedByName (*module)
 Protected *DOS_Header.IMAGE_DOS_HEADER
 Protected *PE_Header.IMAGE_NT_HEADERS  
 Protected *IDD_Export.IMAGE_DATA_DIRECTORY
 Protected *ExportDirectory.IMAGE_EXPORT_DIRECTORY
 Protected *FuncTable, *OrdinalTable, *FuncAddr, *NameTableThunk
 Protected i
 
 *DOS_Header = *module  
 *PE_Header = *module + *DOS_Header\e_lfanew
  
 *IDD_Export = @*PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_EXPORT]  
 *ExportDirectory = *module + *IDD_Export\VirtualAddress  

 *FuncTable = *DOS_Header + *ExportDirectory\AddressOfFunctions
 *OrdinalTable = *DOS_Header + *ExportDirectory\AddressOfNameOrdinals
 *NameTableThunk = *DOS_Header + *ExportDirectory\AddressOfNames
  
 For i = 0 To *ExportDirectory\NumberOfNames - 1        
    *FuncAddr = *module + PeekL(*FuncTable + PeekW(*OrdinalTable + i * SizeOf(Word)) * SizeOf(Long))
    Debug PeekS(*module + PeekL(*NameTableThunk + i * SizeOf(Long)), -1, #PB_Ascii) + " = $"  + Hex(*FuncAddr)
 Next 
EndProcedure
CompilerEndIf

Procedure.i LookForSectionRawData (*module)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew  
 Protected *SectionHeader.IMAGE_SECTION_HEADER = *PE_Header + SizeOf(IMAGE_NT_HEADERS)
 Protected *IDD_BaseReloc.IMAGE_DATA_DIRECTORY = *PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_BASERELOC] 
 Protected i, *raw, *rva = *IDD_BaseReloc\VirtualAddress
 
 ; Looks through all the available sections to see where the passed RVA is pointing. 
 ; Once the related section is found returns an offset from the start of the base address of the file
 ; to the start of the raw data for that section.
 
 For i = 1 To *PE_Header\FileHeader\NumberOfSections 
    If (*rva >= *SectionHeader\VirtualAddress) And (*rva < *SectionHeader\VirtualAddress + *SectionHeader\VirtualSize)
        *raw = *SectionHeader\PointerToRawData + (*rva - *SectionHeader\VirtualAddress)
        Break
    EndIf
    *SectionHeader + SizeOf(IMAGE_SECTION_HEADER)
 Next
  
 ProcedureReturn *raw
EndProcedure

Procedure.i CopySections (*module, *image)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew  
 Protected *DestSection, PaddingLenght, i
 Protected *FirstSectionHeader.IMAGE_SECTION_HEADER = *PE_Header + SizeOf(IMAGE_NT_HEADERS) 
 Protected *SectionHeader.IMAGE_SECTION_HEADER = *FirstSectionHeader  
 Protected NumberOfSections 
 Protected SectionAlignment 

 SectionAlignment = *PE_Header\OptionalHeader\SectionAlignment  
 NumberOfSections = *PE_Header\FileHeader\NumberOfSections 

CompilerIf #DEBUG_VERBOSE = 1  
 Debug "DataDirectory array size = " + *PE_Header\OptionalHeader\NumberOfRvaAndSizes
 Debug "Number of sections = " + NumberOfSections
 Debug ""
 Debug "The copying of the sections to the allocated module in memory starts here ..."
 Debug ""
CompilerEndIf

 For i = 1 To NumberOfSections
 
   CompilerIf #DEBUG_VERBOSE = 1 
    Protected output$ : output$ = ""
    
     Debug "Section n." + i + " = " + PeekS(@*SectionHeader\SecName, SizeOf(*SectionHeader\SecName), #PB_Ascii)
     If *SectionHeader\Characteristics & #IMAGE_SCN_CNT_CODE
        output$ + "CODE "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_CNT_INITIALIZED_DATA
        output$ + "INITIALIZED_DATA "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_CNT_UNINITIALIZED_DATA
        output$ + "UNITIALIZED_DATA "
     EndIf    
     If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_SHARED
        output$ + "SHAREABLE "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_DISCARDABLE
        output$ + "DISCARDABLE "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_EXECUTE
        output$ + "EXECUTABLE "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_READ
        output$ + "READABLE "
     EndIf
     If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_WRITE
        output$ + "WRITEABLE "
     EndIf
     If output$
        Debug Left(output$, Len(output$)-1)
     EndIf
        
     Debug "VirtualSize = " + *SectionHeader\VirtualSize
     Debug "SizeOfRawData = " + *SectionHeader\SizeOfRawData
     Debug "SectionAlignment = " + SectionAlignment
     Debug "RVA = $" +  Hex(*SectionHeader\VirtualAddress)
     Debug "RAW = $" + Hex(*module + *SectionHeader\VirtualAddress)
   CompilerEndIf
    
    *DestSection = *module + *SectionHeader\VirtualAddress ; This field holds the RVA to where the loader should map the section. 

    If *SectionHeader\SizeOfRawData = 0 ; if zero it's a section of uninitialized data
        ; copy the section data to the appropriate offset in the module
        If *PE_Header\OptionalHeader\SectionAlignment > 0 
            ; minimum size if unitialized is then SectionAlignment           
            FillMemory(*DestSection, *PE_Header\OptionalHeader\SectionAlignment, 0)
        EndIf        
    EndIf
    
    If *SectionHeader\SizeOfRawData > 0           
        CopyMemory(*image + *SectionHeader\PointerToRawData, *DestSection, *SectionHeader\SizeOfRawData) ; 1.01 changed VirtualSize to SizeOfRawData                
                
        ; if VirtualSize > SizeOfRawData the remaining bytes after SizeOfRawData should be preferably set to zero
        If *SectionHeader\VirtualSize > *SectionHeader\SizeOfRawData 
            PaddingLenght = AlignAddressTo (*SectionHeader\VirtualSize, SectionAlignment) - *SectionHeader\SizeOfRawData                 
            FillMemory(*DestSection + *SectionHeader\SizeOfRawData, PaddingLenght, 0)
            
           CompilerIf #DEBUG_VERBOSE = 1 
            Debug "Padding = " + PaddingLenght
           CompilerEndIf
        EndIf    
    EndIf    
        
    *SectionHeader + SizeOf(IMAGE_SECTION_HEADER)   

   CompilerIf #DEBUG_VERBOSE = 1 
    Debug ""
   CompilerEndIf    

 Next
EndProcedure

Procedure.i AddToImportedLibraries (*module, DllName$, hdll)
 If FindMapElement(Glo\ModulesMap(), Str(*module)) = 0 ; module not found in the map
    If AddMapElement(Glo\ModulesMap(), Str(*module)) = 0 ; but trying to add it fails
        Goto fail
    EndIf
 EndIf
       
 If AddElement(Glo\ModulesMap()\ImportedList()) = 0 ; add element to the list of dlls for the specific module
    Goto fail
 EndIf
 
 Glo\ModulesMap()\ImportedList()\ImportedDllName$ = DllName$
 Glo\ModulesMap()\ImportedList()\ImportedDllHandle = hdll  

 ProcedureReturn 1
 
fail:
CompilerIf #DEBUG_VERBOSE = 1
 Debug "AddToImportedLibraries() failed !"   
CompilerEndIf
 ProcedureReturn 0 
EndProcedure

Procedure FreeImportedLibraries (*module)
 If FindMapElement(Glo\ModulesMap(), Str(*module))
    ForEach Glo\ModulesMap()\ImportedList() ; cycle through the list of dlls for the specific module    
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "Unloading " + Glo\ModulesMap()\ImportedList()\ImportedDllName$ + " from $" + Hex(Glo\ModulesMap()\ImportedList()\ImportedDllHandle)
       CompilerEndIf       
        If FreeLibrary_(Glo\ModulesMap()\ImportedList()\ImportedDllHandle) = 0         
            CallDebugger ; this should never happen
        EndIf
    Next
    ClearList(Glo\ModulesMap()\ImportedList()) ; empty the list
    DeleteMapElement(Glo\ModulesMap()) ; remove module
 EndIf
EndProcedure

Procedure.i GetProcAddressHelp (*module, func$, ordinal)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew 
 Protected *IDD_Export.IMAGE_DATA_DIRECTORY = *PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_EXPORT]  
 Protected *ExportDirectory.IMAGE_EXPORT_DIRECTORY = *module + *IDD_Export\VirtualAddress  
 Protected *FuncTable, *OrdinalTable, *FuncAddr, *NameTableThunk
 Protected OrdinalBaseValue, i, dot
 Protected DllFwdFull$, DllFwdLib$, DllFwdFunc$, DllFwdHandle
        
 *FuncTable = *DOS_Header + *ExportDirectory\AddressOfFunctions
 *OrdinalTable = *DOS_Header + *ExportDirectory\AddressOfNameOrdinals
 *NameTableThunk = *DOS_Header + *ExportDirectory\AddressOfNames
  
 *FuncAddr = 0

 If ordinal 
    OrdinalBaseValue = *ExportDirectory\Base
    If ordinal < OrdinalBaseValue Or ordinal > OrdinalBaseValue + *ExportDirectory\NumberOfFunctions
        ProcedureReturn 0
    EndIf    
    *FuncAddr = *module + PeekL(*FuncTable + ((ordinal - OrdinalBaseValue) * SizeOf(Long)))
 Else
    
    For i = 0 To *ExportDirectory\NumberOfNames - 1        
        If func$ = PeekS(*module + PeekL(*NameTableThunk + i * SizeOf(Long)), -1, #PB_Ascii)
            *FuncAddr = *module + PeekL(*FuncTable + PeekW(*OrdinalTable + i * SizeOf(Word)) * SizeOf(Long))
            Break
        EndIf
    Next    
 EndIf
 
 ; if the function address is inside the export directory range it can't be a real function pointer
 ; and that means we have found a forwarded function
 
 If (*FuncAddr >= *ExportDirectory) And (*FuncAddr < *ExportDirectory + *IDD_Export\Size)
    DllFwdFull$ = PeekS(*FuncAddr,-1,#PB_Ascii)
   
   CompilerIf #DEBUG_VERBOSE = 1
    Debug " >> " + func$ + " is being forwarded to " + DllFwdFull$
   CompilerEndIf
   
    dot = FindString(DllFwdFull$, ".")
    If dot
        DllFwdLib$ = Left(DllFwdFull$, dot-1)
        DllFwdFunc$ = Mid(DllFwdFull$, dot+1)
    EndIf
   
    DllFwdHandle = GetModuleHandle_(DllFwdLib$) ; check if already there
    If DllFwdHandle 
        *FuncAddr = GetProcAddressHelp(DllFwdHandle, DllFwdFunc$, 0)        
        Goto exit
    EndIf

    DllFwdHandle = LoadLibrary_(DllFwdLib$) ; if not already there, load it 
    If DllFwdHandle 
        *FuncAddr = GetProcAddressHelp(DllFwdHandle, DllFwdFunc$, 0) 
        If AddToImportedLibraries(*module, DllFwdLib$, DllFwdHandle) = 0 
            *FuncAddr = 0 ; signal failure
        EndIf
        Goto exit
    EndIf
    
    *FuncAddr = 0    
 EndIf

exit:

CompilerIf #DEBUG_VERBOSE = 1
 If *FuncAddr = 0 
    If ordinal = 0   
        Debug "Address not found for " + func$
    Else
        Debug "Address not found for ordinal " + ordinal
    EndIf    
 EndIf 
CompilerEndIf
    
 ProcedureReturn *FuncAddr
EndProcedure

Procedure.i LoadFromImportTable (*module)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew  
 Protected *IDD_Import.IMAGE_DATA_DIRECTORY = *PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_IMPORT]  
 Protected *FirstImportDesc.IMAGE_IMPORT_DESCRIPTOR = *module + *IDD_Import\VirtualAddress
 Protected *ImportDesc.IMAGE_IMPORT_DESCRIPTOR = *FirstImportDesc
 Protected *NameTableThunk.IMAGE_THUNK_DATA, *AddressTableThunk.IMAGE_THUNK_DATA, *Thunk.IMAGE_THUNK_DATA
 Protected *ImportByName.IMAGE_IMPORT_BY_NAME
 Protected DllName$, func$, hdll, ordinal

CompilerIf #DEBUG_VERBOSE = 1         
 Debug "The loading of the imported DLLs and the patching of function addresses starts here ..."
CompilerEndIf
   
 While IsBadReadPtr_(*ImportDesc, SizeOf(IMAGE_IMPORT_DESCRIPTOR)) = 0 And *ImportDesc\Name        
    DllName$ = PeekS(*module + *ImportDesc\Name, -1, #PB_Ascii)
        
    hdll = LoadLibrary_(DllName$)
                    
    If hdll = 0
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "Unable to load library " + DllName$ + ". Abort."
       CompilerEndIf            
        Goto fail            
    EndIf
    
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug ""
    Debug "Loaded " + DllName$ + " = $" + Hex(hdll)
   CompilerEndIf
    
    If AddToImportedLibraries(*module, DllName$, hdll) = 0
        Goto fail
    EndIf
    
    *NameTableThunk  = *module + *ImportDesc\OriginalFirstThunk
    *AddressTableThunk  = *module + *ImportDesc\FirstThunk
    
    If *ImportDesc\OriginalFirstThunk
        *Thunk = *NameTableThunk
    ElseIf *AddressTableThunk
        *Thunk = *AddressTableThunk
    EndIf               
    
    If *Thunk = 0
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "Both the name table and the addres table looks empty for " + DllName$ + ". Abort."       
       CompilerEndIf
        Goto fail
    EndIf
    
    While *Thunk\AddressOfData
        ordinal = 0
        
        If *Thunk\Ordinal & #IMAGE_ORDINAL_FLAG ; this is an ordinal entry (unlikely)
            ordinal = *Thunk\Ordinal & $ffff 
            func$ = Hex(ordinal)
        Else
            *ImportByName = *module + *Thunk\AddressOfData ; this is an import by name entry
            func$ = PeekS(@*ImportByName\Name[0], -1, #PB_Ascii)               
        EndIf
                        
        *AddressTableThunk\Function = GetProcAddressHelp(hdll, func$, ordinal)
                
       CompilerIf #DEBUG_VERBOSE = 1 
        If ordinal
            Debug " (" + ordinal + ") -> $" + Hex(*AddressTableThunk\Function)
        Else
            Debug " " + func$ + " -> $" + Hex(*AddressTableThunk\Function)
        EndIf
       CompilerEndIf
 
        *Thunk + SizeOf(IMAGE_THUNK_DATA)
        *AddressTableThunk + SizeOf(IMAGE_THUNK_DATA)
    Wend
 
    *ImportDesc + SizeOf(IMAGE_IMPORT_DESCRIPTOR)        
 Wend
 
 ProcedureReturn 1
 
fail: 
 FreeImportedLibraries(*module)
 ProcedureReturn 0
EndProcedure
 
Procedure PatchRelocationTable (*module, *BaseReloc.IMAGE_BASE_RELOCATION, *PreferredBase)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew  
 Protected *IDD_BaseReloc.IMAGE_DATA_DIRECTORY = *PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_BASERELOC] 
 Protected *CurReloc.IMAGE_BASE_RELOCATION = *BaseReloc  
 Protected *RelocEnd.IMAGE_BASE_RELOCATION = *BaseReloc + *IDD_BaseReloc\Size
 Protected *CurWordEntry.Word, *TargetRelocItem.Integer, *SectionBase
 Protected Delta = *module - *PreferredBase
 Protected RelocationsCount, RelocTypeWord, i

CompilerIf #DEBUG_VERBOSE = 1 
 Protected output$
 Protected total_expected, total_valid, partial_valid
 Debug "Actual module base = $" + Hex(*module)
 Debug "Preferred image base = $" + Hex(*PreferredBase) 
 Debug "Delta = " + Delta
CompilerEndIf

 While (*CurReloc < *RelocEnd) And *CurReloc\VirtualAddress
    RelocationsCount = (*CurReloc\SizeOfBlock - SizeOf(IMAGE_BASE_RELOCATION)) / SizeOf(Word) ; relocations count
    
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "" 
    Debug "Start of a new relocation block." 
    Debug "Size of block = " + *CurReloc\SizeOfBlock
    Debug "Expected relocation entries = " + RelocationsCount     
   CompilerEndIf
   
    *CurWordEntry = *CurReloc + SizeOf(IMAGE_BASE_RELOCATION)
    *SectionBase = *module + *CurReloc\VirtualAddress
        
   CompilerIf #DEBUG_VERBOSE = 1
    total_expected + RelocationsCount
    partial_valid = 0
   CompilerEndIf
        
    For i = 1 To RelocationsCount
        RelocTypeWord = (*CurWordEntry\w >> 12) & $000F ; binary shifted word instead of the arithmetic one (mask out the high 12 bits after the shift)
            
       CompilerIf #DEBUG_VERBOSE = 1 
        output$ = Str(i) +" RVA ($" + Hex(*CurReloc\VirtualAddress + *CurWordEntry\w & $0fff) + "), "
        If (RelocTypeWord) = #IMAGE_REL_BASED_HIGHLOW
            output$ + "IMAGE_REL_BASED_HIGHLOW"
        ElseIf (RelocTypeWord) = #IMAGE_REL_BASED_DIR64
            output$ + "IMAGE_REL_BASED_DIR64"
        Else
            output$ + Str(RelocTypeWord)
        EndIf
       CompilerEndIf
       
        If (RelocTypeWord = #IMAGE_REL_BASED_HIGHLOW) Or (RelocTypeWord = #IMAGE_REL_BASED_DIR64) 
           CompilerIf #DEBUG_VERBOSE = 1        
            total_valid + 1
            partial_valid + 1
           CompilerEndIf
            
            *TargetRelocItem = *SectionBase + (*CurWordEntry\w & $0fff) ; only the low 12 bits of the word            
            *TargetRelocItem\i + Delta
            
           CompilerIf #DEBUG_VERBOSE = 1 
            output$ + ", $" + Hex(*TargetRelocItem\i + Delta)
           CompilerEndIf
        EndIf
                
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug output$
       CompilerEndIf
        
        *CurWordEntry + SizeOf(Word)
    Next
    
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "Valid relocation entries processed = " + partial_valid
   CompilerEndIf
    
    *CurReloc = *CurReloc + *CurReloc\SizeOfBlock    
 Wend

CompilerIf #DEBUG_VERBOSE = 1 
 Debug ""
 Debug "Total expected relocation entries = " + total_expected
 Debug "Total valid relocation entries processed = " + total_valid 
 Debug ""
CompilerEndIf

EndProcedure

Procedure.i SectorToVirtualMemProtectionFlags (secp)
 Protected vmp
 Protected executable, readable, writable
 Protected Dim vmflags(1,1,1)
 
 vmflags(0,0,0) = #PAGE_NOACCESS
 vmflags(0,0,1) = #PAGE_WRITECOPY
 vmflags(0,1,0) = #PAGE_READONLY
 vmflags(0,1,1) = #PAGE_READWRITE

 vmflags(1,0,0) = #PAGE_EXECUTE
 vmflags(1,0,1) = #PAGE_EXECUTE_WRITECOPY
 vmflags(1,1,0) = #PAGE_EXECUTE_READ
 vmflags(1,1,1) = #PAGE_EXECUTE_READWRITE

 If (secp & #IMAGE_SCN_MEM_EXECUTE) 
    executable = #True
 EndIf
 
 If (secp & #IMAGE_SCN_MEM_READ) 
    readable = #True 
 EndIf
 
 If (secp & #IMAGE_SCN_MEM_WRITE) 
    writable = #True
 EndIf 
 
 vmp = vmflags(executable, readable, writable)
 
 If (secp & #IMAGE_SCN_MEM_NOT_CACHED)
    vmp = vmp | #PAGE_NOCACHE
 EndIf
 
 ProcedureReturn vmp
EndProcedure
 
Procedure.i SetProtectionFlagsForSections (*module)
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module  
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew
 Protected *SectionHeader.IMAGE_SECTION_HEADER
 Protected *Section, OldProtect, NewProtect, i, SectionSize
 
 ; set PE header to readonly
 VirtualProtect_(*module, *PE_Header\OptionalHeader\SizeOfHeaders, #PAGE_READONLY, @OldProtect)
 
 *SectionHeader = *PE_Header + SizeOf(IMAGE_NT_HEADERS)
 
 For i = 1 To *PE_Header\FileHeader\NumberOfSections 
 
    *Section = *module + *SectionHeader\VirtualAddress    
    
    SectionSize = *SectionHeader\VirtualSize ; I think this should be VirtualSize and not SizeOfRawData (cfr. Joachim Bauch)
    
    If *SectionHeader\Characteristics & #IMAGE_SCN_MEM_DISCARDABLE ; let's throw away any temporary section
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "Discarding section " + PeekS(@*SectionHeader\SecName, SizeOf(*SectionHeader\SecName), #PB_Ascii) + " (size = " + SectionSize + ")"
       CompilerEndIf

        VirtualFree_(*Section, SectionSize, #MEM_DECOMMIT) 
        *SectionHeader + SizeOf(IMAGE_SECTION_HEADER) ; do not forget this !
        Continue        
    EndIf
    
    ; translate section protection to VAS protections
    NewProtect = SectorToVirtualMemProtectionFlags (*SectionHeader\Characteristics) 

    If VirtualProtect_(*Section, SectionSize, NewProtect, @OldProtect)    
       CompilerIf #DEBUG_VERBOSE = 1
        Protected output$
        output$ = "Protecting section " + PeekS(@*SectionHeader\SecName, SizeOf(*SectionHeader\SecName), #PB_Ascii) + " (" 
        Select NewProtect
            Case #PAGE_NOACCESS
                output$ + "PAGE_NOACCESS"
            Case #PAGE_WRITECOPY
                output$ + "PAGE_WRITECOPY"
            Case #PAGE_READONLY
                output$ + "PAGE_READONLY"    
            Case #PAGE_READWRITE
                output$ + "PAGE_READWRITE"
            Case #PAGE_EXECUTE
                output$ + "PAGE_EXECUTE"    
            Case #PAGE_EXECUTE_WRITECOPY
                output$ + "PAGE_EXECUTE_WRITECOPY"           
            Case #PAGE_EXECUTE_READ
                output$ + "PAGE_EXECUTE_READ"    
            Case #PAGE_EXECUTE_READWRITE
                output$ + "PAGE_EXECUTE_READWRITE"
            Default
                output$ + "???"    
        EndSelect    
        Debug output$ + ")"
       CompilerEndIf
    Else    
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "Error in VirtualProtect_() for section n. " + i
       CompilerEndIf
        Goto fail
    EndIf
    
    *SectionHeader + SizeOf(IMAGE_SECTION_HEADER)
 Next
 
 ProcedureReturn 1
 
fail: 
 ProcedureReturn 0
EndProcedure
  
;- [ PUBLIC ] 

Procedure.i LoadLibrary (*image)
 Protected *DOS_Header.IMAGE_DOS_HEADER
 Protected *PE_Header.IMAGE_NT_HEADERS        
 Protected *BaseReloc.IMAGE_BASE_RELOCATION
 Protected *PreferredBase, *module 
 Protected RetCode, SizeOfImage, SizeOfHeaders, OffsetToRawDataOfRelocationTable, flgRelocationRequired
 Protected DllMain.DllMain
 
 ;****************************************************************************************************
 ; check if all it is as it should be ...
 ;****************************************************************************************************
 
 If *image = #Null
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "The passed memory address is null. Abort."
   CompilerEndIf    
    Goto fail
 EndIf
 
 *DOS_Header = *image ; the image of the DLL starts with the old DOS header
 
 If *DOS_Header\e_magic <> #IMAGE_DOS_SIGNATURE
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "DOS header signature is missing. Abort."
   CompilerEndIf
    Goto fail
 EndIf
 
 *PE_Header = *image + *DOS_Header\e_lfanew ; follows the link to the PE header

 ; check for a valid PE 
 If *PE_Header\Signature <> #IMAGE_NT_SIGNATURE
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "PE header signature is missing. Abort."  
   CompilerEndIf
    Goto fail
 EndIf
 
 If *PE_Header\FileHeader\Characteristics & #IMAGE_FILE_DLL = 0 ; check if this is a valid DLL
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "This is not a DLL. Abort."
   CompilerEndIf     
    Goto fail
 EndIf
  
CompilerIf (#PB_Compiler_Processor = #PB_Processor_x86)
 If *PE_Header\OptionalHeader\Magic <> #IMAGE_NT_OPTIONAL_HDR32_MAGIC ; we expect a 32 bit DLL
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "This is not a 32 bit DLL. Abort."
   CompilerEndIf    
    Goto fail
 EndIf
CompilerElse   
 If *PE_Header\OptionalHeader\Magic <> #IMAGE_NT_OPTIONAL_HDR64_MAGIC ; we expect a 64 bit DLL
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "This is not a 64 bit DLL. Abort."
   CompilerEndIf    
    Goto fail
 EndIf
CompilerEndIf
 
 *PreferredBase = *PE_Header\OptionalHeader\ImageBase           
 SizeOfImage = *PE_Header\OptionalHeader\SizeOfImage 
 SizeOfHeaders = *PE_Header\OptionalHeader\SizeOfHeaders 
 
CompilerIf #DEBUG_VERBOSE = 1 
 Debug "DLL preferred base address = $" + Hex(*PreferredBase)
CompilerEndIf
  
 ;****************************************************************************************************
 ; allocate the module in virtual address space (VAS)
 ;****************************************************************************************************
 
CompilerIf #DEBUG_FORCE_RELOCATION = 1 
 Protected *PreferredBaseForcedToReserved = VirtualAlloc_(*PreferredBase, SizeOfImage, #MEM_RESERVE, #PAGE_READWRITE) 
CompilerEndIf 
 
 ; we first try to allocate it to the preferred base address
 *module = VirtualAlloc_(*PreferredBase, SizeOfImage, #MEM_RESERVE, #PAGE_READWRITE)
 
 If *module = #Null ; that space must be already reserved for something... no luck
    flgRelocationRequired = 1 ; take note of it
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "The preferred base address is already in use, relocation is required."
   CompilerEndIf
    ; do we have the relocation table ?
    If (*PE_Header\OptionalHeader\DataDirectory[#IMAGE_DIRECTORY_ENTRY_BASERELOC]\Size = 0) Or (*PE_Header\FileHeader\Characteristics & #IMAGE_FILE_RELOCS_STRIPPED)                
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "... and the module is not relocatable. Abort."
       CompilerEndIf
        Goto fail
    EndIf        
 EndIf
 
 If flgRelocationRequired 
    ; we try to allocate it somewhere else
    *module = VirtualAlloc_(#Null, SizeOfImage, #MEM_RESERVE, #PAGE_READWRITE)    
    If *module = #Null
       CompilerIf #DEBUG_VERBOSE = 1 
        Debug "An error happened trying to allocate the module at a new address. Abort."
       CompilerEndIf
       Goto fail
     EndIf    
 EndIf
 
 ; now we have a good address range all for ourself, let's commit the memory
 *module = VirtualAlloc_(*module, SizeOfImage, #MEM_COMMIT, #PAGE_READWRITE) 
 
CompilerIf #DEBUG_VERBOSE = 1 
 Debug "Module loaded at $" + Hex(*module)
 Debug "End of module at $" + Hex(*module + SizeOfImage)
 Debug "Size of the Module = $" + Hex(SizeOfImage) 
 If (SizeOfImage % *PE_Header\OptionalHeader\SectionAlignment) <> 0
    Debug "WARNING: module's size is not a multiple of SectionAlignment."
 EndIf
CompilerEndIf
 
 ;****************************************************************************************************
 ; copy DOS header, PE header and the section table arrays in one shot to the allocated module
 ;****************************************************************************************************
 
 CopyMemory(*image, *module, SizeOfHeaders) ; a simple CopyMemory() is enough
  
 ;****************************************************************************************************
 ; copy the sections each one at its appropriate starting address
 ;****************************************************************************************************
 
 CopySections(*module, *image) 

CompilerIf #DEBUG_VERBOSE = 1 
 Debug ""
 Debug "List of all functions exported by name ..."
 Debug ""
 ListAllExportedByName(*module) ; just a convenience, could be useful to have
 Debug ""
CompilerEndIf

 ;****************************************************************************************************
 ; load imports (the other DLLs required by this one) and patch the function addresses
 ;****************************************************************************************************
 
 If LoadFromImportTable(*module) = 0 
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "An error happened while processing the import table. Abort."
   CompilerEndIf
    Goto fail 
 EndIf
 
 ;****************************************************************************************************
 ; update the relocation table with new addresses if it is required
 ;****************************************************************************************************
 
 If flgRelocationRequired
    OffsetToRawDataOfRelocationTable = LookForSectionRawData (*module)  ; This is the RVA to the first entry of type IMAGE_BASE_RELOCATION in the relocation table.   
    *BaseReloc = *image + OffsetToRawDataOfRelocationTable
    
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug ""
    Debug "The relocation of entries in the relocation table starts here ..."
    Debug ""
    Debug "Offset to relocation table data = $" +  Hex(OffsetToRawDataOfRelocationTable)   
    Debug "Absolute start of the relocation table data = $" + Hex(*BaseReloc)
   CompilerEndIf
        
    PatchRelocationTable(*module, *BaseReloc, *PreferredBase)
 EndIf
    
CompilerIf #DEBUG_VERBOSE = 1    
 If flgRelocationRequired = 0
    Debug ""
    Debug "Relocation is not required, DLL was loaded at the preferred address."
    Debug ""
 EndIf    
CompilerEndIf   
 
 ;****************************************************************************************************
 ; cycle through all sections and apply the appropriate protection settings
 ;****************************************************************************************************
 
 If SetProtectionFlagsForSections(*module) = 0
   CompilerIf #DEBUG_VERBOSE = 1 
    Debug "An error happened while setting section protections. Abort."
   CompilerEndIf
    Goto fail 
 EndIf

 ;****************************************************************************************************
 ; If there is a valid entry point, send a #DLL_PROCESS_ATTACH notification
 ;****************************************************************************************************

 If *PE_Header\OptionalHeader\AddressOfEntryPoint
    DllMain = *module + *PE_Header\OptionalHeader\AddressOfEntryPoint
    Glo\ModulesMap(Str(*module))\EntryPoint = DllMain
    
    RetCode = DllMain(*module, #DLL_PROCESS_ATTACH, 0)
    
   CompilerIf #DEBUG_VERBOSE = 1     
    Debug ""
    Debug "DllMain -> #DLL_PROCESS_ATTACH = " + RetCode
   CompilerEndIf

    If RetCode = 0        
        Goto fail
    EndIf
 EndIf

CompilerIf #DEBUG_VERBOSE = 1 
 Debug ""
CompilerEndIf        

CompilerIf #DEBUG_FORCE_RELOCATION = 1 
 If *PreferredBaseForcedToReserved
    VirtualFree_(*PreferredBaseForcedToReserved, 0, #MEM_RELEASE)
 EndIf   
CompilerEndIf 

 ProcedureReturn *module ; all done
 
fail:  
 If *module
    VirtualFree_(*module, 0, #MEM_RELEASE)
    FreeImportedLibraries(*module)        
 EndIf
 
CompilerIf #DEBUG_VERBOSE = 1 
 Debug ""
CompilerEndIf        

CompilerIf #DEBUG_FORCE_RELOCATION = 1 
 If *PreferredBaseForcedToReserved
    VirtualFree_(*PreferredBaseForcedToReserved, 0, #MEM_RELEASE)
 EndIf   
CompilerEndIf 
 
 ProcedureReturn 0 ; something went wrong 
EndProcedure
 
Procedure.i GetProcAddress (*module, func$)
  ProcedureReturn GetProcAddressHelp (*module, func$, 0)
EndProcedure

Procedure FreeLibrary (*module) 
 Protected *DOS_Header.IMAGE_DOS_HEADER = *module
 Protected *PE_Header.IMAGE_NT_HEADERS = *module + *DOS_Header\e_lfanew
 Protected DllMain.DllMain = Glo\ModulesMap(Str(*module))\EntryPoint
 
 If DllMain
    CompilerIf #DEBUG_VERBOSE = 1 
     Debug ""   
     Debug "DllMain -> #DLL_PROCESS_DETACH"
    CompilerEndIf                
 
    DllMain(*module, #DLL_PROCESS_DETACH, 0)
 EndIf
    
 If VirtualFree_(*module, 0, #MEM_RELEASE) = 0    
;    CallDebugger ; this should never happen
 EndIf
 
 FreeImportedLibraries(*module)
EndProcedure

EndModule
; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 1059
; FirstLine = 1013
; Folding = ------------
; EnableXP