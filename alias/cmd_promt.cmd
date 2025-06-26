
doskey up=cd ..
doskey ls=dir $*
doskey cat=type $*

doskey head=powershell -command "if ('$2' -eq '') { Get-Content '$1' -Head 10 } else { Get-Content '$1' -Head $2 }"
doskey tail=powershell -command "if ('$2' -eq '') { Get-Content '$1' -Tail 10 } else { Get-Content '$1' -Tail $2 }"
doskey pwd=echo %CD% ^| clip
doskey extract="C:\Program Files\Git\usr\bin\unzip.exe" $*
doskey home=$HOME
doskey clear=cls
doskey rm=del $*
doskey mv=move $*
doskey cp=copy $*
doskey upby=for /l %%i in (1,1,$1) do cd ..
