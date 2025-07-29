
DeclareModule MemDll 
Declare.i    LoadLibrary (*image)
Declare.i    GetProcAddress (hdll, func$)
Declare    FreeLibrary (hdll)
EndDeclareModule

IncludeFile "MemDll.pbi"

Enumeration
  #OSME_SUCCESS=0
  #OSME_FILE_ERROR=-1001
  #OSME_FILE_READ_ERROR=-1002
  #OSME_FILE_MEMORY_ERROR=-1003
  #OSME_FILE_NOT_FOUND_ERROR=-1004
  #OSME_UNKNOWN_REPLAYER=-2001
  #OSME_INITIALIZATION_ERROR=-3001
  #OSME_SOUNDSYSTEM_ERROR=-3002
  #OSME_DISK_VALIDATION_FAILED=-3003
  #OSME_USER_ERROR=-4000
  #OSME_QUALITY_FILTER_OFF=0
  #OSME_QUALITY_FILTER_ON=1
EndEnumeration


Structure osme_music_info_t
  title.s {80}
  author.s {60}
  composer.s {60}
  replay.s {40}
  hwname.s {20}
  time_ms.l
  rate.l
  addr.l
  channels.l
  max_vu.l
EndStructure

Structure OSME
  OsmeMusic_Info.osme_music_info_t
  FadeOutTimeMS.l
  ChannelVU.l
  MusicFile.s
  TrackID.l
  Lenght.l
  Volume.l
  QualityFilter.l
 
  ;Pointers
  DllDataPtr.l
  OSMEPlay.l
  OSMEPlayFile.l
  OSMEStop.l
  OSMEPause.l
  OSMEResume.l
  MusicInfo.l
  OSMEGetChannelVU.l
  SetQualityFilter.l
  OSMESetVolume.l
  ProcResult.l
  FadeOutVolume.l
EndStructure

Global OSME.OSME

Procedure OSME_Init()
  With OSME
    \DllDataPtr=MemDLL::LoadLibrary(?dll)
    \OSMEPlay=MemDLL::GetProcAddress(\DllDataPtr,"playOSMEMusicMem")
    \OSMEPlayFile=MemDLL::GetProcAddress(\DllDataPtr,"playOSMEMusicFile")
    \OSMEStop=MemDLL::GetProcAddress(\DllDataPtr,"stopOSMEMusic")
    \OSMEPause=MemDLL::GetProcAddress(\DllDataPtr,"pauseOSMEMusic")
    \OSMEResume=MemDLL::GetProcAddress(\DllDataPtr,"resumeOSMEMusic")
    \MusicInfo=MemDLL::GetProcAddress(\DllDataPtr,"getOSMEMusicInfo")
    \OSMEGetChannelVU=MemDLL::GetProcAddress(\DllDataPtr,"getOSMEChannelVU")
    \SetQualityFilter=MemDLL::GetProcAddress(\DllDataPtr,"setQualityFilter")
    \OSMESetVolume=MemDLL::GetProcAddress(\DllDataPtr,"setOSMEVolume")
    \ProcResult=MemDLL::GetProcAddress(\DllDataPtr,"getProcResult")
    \FadeOutVolume=MemDLL::GetProcAddress(\DllDataPtr,"fadeOutOSMEVolume")
  EndWith
EndProcedure

Procedure OSMEPlay(*Song,SongLength.l,SubSong.l)
  OSME_Init()
  CallCFunctionFast(OSME\OSMEPlay,*Song,SongLength,SubSong)
EndProcedure


Procedure OSMEStop()
  CallCFunctionFast(OSME\OSMEStop)
  MemDLL::FreeLibrary(?dll)
EndProcedure

Procedure OSMEPause()
  CallCFunctionFast(OSME\OSMEPause)
EndProcedure

Procedure OSMEResume()
  CallCFunctionFast(OSME\OSMEresume)
EndProcedure


Procedure OSME_MusicInfo(*Info.osme_music_info_t)
  CallCFunctionFast(OSME\MusicInfo,*Info)
EndProcedure

Procedure OSME_GetChannelVU(Channel.l)
  ProcedureReturn CallCFunctionFast(OSME\OSMEGetChannelVU,Channel)
EndProcedure


Procedure OSMESetQualityFilter(quality.l=#OSME_QUALITY_FILTER_ON)
   CallCFunctionFast(OSME\SetQualityFilter,quality)
EndProcedure

Procedure OSMESetVolume(Volume.l=100)
  CallCFunctionFast(OSME\OSMESetVolume,Volume)
EndProcedure

Procedure OSMEFadeOutVolume(FadeOutTimeMS.l)
  CallCFunctionFast(OSME\FadeOutVolume,FadeOutTimeMS)
EndProcedure

Procedure OSMEGetProcResult()
  ProcedureReturn CallCFunctionFast(OSME\ProcResult)
EndProcedure

DataSection
  DLL:
  IncludeBinary "osmengine.dll"
EndDataSection	
; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 116
; FirstLine = 66
; Folding = 9K-
; EnableXP
; DisableDebugger