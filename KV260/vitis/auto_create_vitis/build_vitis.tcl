set tclPath [pwd]
cd $tclPath
cd ..
set projpath [pwd]
puts "Current workspace is $projpath"
setws $projpath
getws
set xsaName kv260_video_wrapper
set appName mipi

#Create a new platform
platform create -name $xsaName -hw $projpath/$xsaName.xsa -proc psu_cortexa53_0 -os standalone -arch 64-bit -out $projpath
importprojects $projpath/$xsaName
platform active $xsaName


domain active
#Create a new application
app create -name $appName -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $appName -path $tclPath/src/$appName

#bsp setting
bsp config zynqmp_fsbl_bsp true
bsp regenerate

#Build platform project
platform generate
app create -name a53_fsbl -platform HW1 -template "Zynq MP FSBL" -domain A53_Standalone -lang c
app build -name a53_fsbl
#Build application project
append appName "_system"
sysproj build -name $appName
