# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# ------------------------------------------
# -- $Date:  2021/07/07  | $Author: Hartfiel, John
# -- -  moved plx from external to own tcl
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------

namespace eval ::TE {
  namespace eval PLX {

    # -----------------------------------------------------------------------------------------------------------------------------------------
    # petalinux functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--plx_config: 
    proc plx_config {{refresh false}} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			# create project if missing
			if {![file exists ${TE::PETALINUX_PATH}] } {
				set ospath [file normalize ${TE::PETALINUX_PATH}/..]
				file mkdir ${ospath}
				cd ${ospath}
        
        set t_PYTHONHOME $::env(PYTHONHOME)
        set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        set t_PYTHONPATH $::env(PYTHONPATH)
        set t_PYTHON $::env(PYTHON)
        unset ::env(PYTHONHOME) 
        unset ::env(LD_LIBRARY_PATH) 
        unset ::env(PYTHONPATH)
        unset ::env(PYTHON) 
        
				set command exec
				lappend command petalinux-create 
				lappend command --type project
				
				
				lappend command --name $prjname
				if {$TE::IS_ZUSYS} {
					lappend command --template zynqMP
				} elseif {$TE::IS_ZSYS} {
					lappend command --template zynq
				} elseif {$TE::IS_MSYS} {
					lappend command --template microblaze
				} else {
          set ::env(PYTHONHOME) $t_PYTHONHOME
          set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
          set ::env(PYTHONPATH) $t_PYTHONPATH
          set ::env(PYTHON) $t_PYTHON
					return -code error "unkown system"
				}
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 
        set ::env(PYTHONHOME) $t_PYTHONHOME
        set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
        set ::env(PYTHONPATH) $t_PYTHONPATH
        set ::env(PYTHON) $t_PYTHON
			}
			cd ${TE::PETALINUX_PATH}
			
			set xsafile  [list]
			if { [catch {set xsafile [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}] || $refresh} {
				#copy xsa
				TE::UTILS::generate_workspace_petalinux 
        
        set t_PYTHONHOME $::env(PYTHONHOME)
        set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        set t_PYTHONPATH $::env(PYTHONPATH)
        set t_PYTHON $::env(PYTHON)
        unset ::env(PYTHONHOME) 
        unset ::env(LD_LIBRARY_PATH) 
        unset ::env(PYTHONPATH)
        unset ::env(PYTHON) 
        
				# load xsa and start config
				set command exec
        # lappend command gnome-terminal
				lappend command xterm
				lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config --get-hw-description "
				# lappend command petalinux-config
				# lappend command --get-hw-description
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 
        set ::env(PYTHONHOME) $t_PYTHONHOME
        set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
        set ::env(PYTHONPATH) $t_PYTHONPATH
        set ::env(PYTHON) $t_PYTHON
			} else {
        set t_PYTHONHOME $::env(PYTHONHOME)
        set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        set t_PYTHONPATH $::env(PYTHONPATH)
        set t_PYTHON $::env(PYTHON)
        unset ::env(PYTHONHOME) 
        unset ::env(LD_LIBRARY_PATH) 
        unset ::env(PYTHONPATH)
        unset ::env(PYTHON) 
				# start config
				set command exec
				# lappend command gnome-terminal
				# lappend command -- unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config
				lappend command xterm
				lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config "
				# lappend command petalinux-config
        set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 
        set ::env(PYTHONHOME) $t_PYTHONHOME
        set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
        set ::env(PYTHONPATH) $t_PYTHONPATH
        set ::env(PYTHON) $t_PYTHON
			}
			cd $cur_path 
		}
    #--------------------------------
    #--plx_uboot: 
    proc plx_uboot {{cleanup true}} {
		
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
			# start uboot config
			set command exec
			lappend command xterm
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c u-boot"
			# lappend command gnome-terminal
      # lappend command -e "petalinux-config -c u-boot"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 
			#export to meta-user
			set command exec
			lappend command xterm
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-devtool finish u-boot-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			# lappend command gnome-terminal
      # lappend command -e "petalinux-devtool finish u-boot-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 				
			#clean up project
			if { $cleanup} {
				set command exec
				lappend command xterm
				lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
				# lappend command gnome-terminal
        # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 		
			}				
      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
			cd $cur_path 
		}
    #--------------------------------
    #--plx_kernel: 
    proc plx_kernel {{cleanup true}} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
			# start kernel config
			set command exec
			lappend command xterm
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c kernel"
			# lappend command gnome-terminal
      # lappend command -e "petalinux-config -c kernel"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 
			#export to meta-user
			set command exec
			lappend command xterm
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-devtool finish linux-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			# lappend command gnome-terminal
      # lappend command -e "petalinux-devtool finish linux-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 			
			#clean up project
			if { $cleanup} {
				set command exec
				lappend command xterm
				lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
				# lappend command gnome-terminal
        # lappend command -e "petalinux-build -x mrproper -f"
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 		
			}		
      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
			cd $cur_path 
		}
    #--------------------------------
    #--plx_rootfs: 
    proc plx_rootfs {} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
			# # start rootfs config 
			set command exec
			lappend command gnome-terminal
			# lappend command xterm
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c rootfs"
      # lappend command petalinux-config
      # lappend command -c rootfs
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 
      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
			cd $cur_path 
		}
    #--------------------------------
    #--plx_device_tree: 
    proc plx_device_tree {} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
			#start device tree editor
			set command exec
			# lappend command xterm
			# lappend command -e "gvim ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi"
			lappend command gnome-terminal
			lappend command -e "gvim ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 
      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
			cd $cur_path 
		}
    #--------------------------------
    #--plx_app: 
    proc plx_app { appname } {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
			#create empty app
			set command exec
			lappend command xterm
			# lappend command gnome-terminal
			lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-create -t apps -n ${appname} --enable"
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					$result \n \
				------" 
      #maybe coppy app from template svn?
      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
			cd $cur_path 
		}
    #--------------------------------
    #--plx_bootsrc: 
    proc plx_bootsrc { {type def} {imageub_addr 0x10000000} {imageub_flash_addr 0x200000} {imageub_flash_size 0xD90000}} {
			#type= default --> create files without changes
			#type= ign --> do not create bootscr files on prebuilt folder
			#type= all others --> create bootscr files with parameters
 
      set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
      set posfolder ${TE::PREBUILT_OS_PATH}/petalinux/${TE::DDR_SIZE}/
			file mkdir ${posfolder}
			cd ${posfolder}
      
      if {[file exists ${TE::SCRIPT_PATH}/boot.script_template] && ![string match -nocase "ign" $type]} { 
        set fp_r [open ${TE::SCRIPT_PATH}/boot.script_template "r"]
        set file_data [read $fp_r]
        close $fp_r
        
        set tmp_date "[ clock format [clock seconds] -format "%Y_%m_%d %H_%M_%S"]"
        if {[string match -nocase $type "def"] } {
          TE::UTILS::te_msg TE_PLX-??? INFO "Use default Boot Source file ( ${posfolder}/boot.script ) without modification \n \
          ------" 
        } 
        set e1str "echo \[TE_BOOT-00\] Boot Source Script File creation date:  $tmp_date;"
        set e2str "echo \[TE_BOOT-00\] Automatically generated Trenz Electronic Boot Source file with setup $type;"
        set data [split $file_data "\n"]
        set data [linsert $data[set data {}] 0 "################"]
        set data [linsert $data[set data {}] 0 "$e1str"]
        set data [linsert $data[set data {}] 0 "$e2str"]
        set data [linsert $data[set data {}] 0 "################"]
        set data [linsert $data[set data {}] 0 ""]
        set line_index -1
        set mod_count 0
        foreach line $data {
          incr line_index
          #comment lines on tcl file, modified lines are ignored
          if {[string match "imageub_addr=*" $line] && ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_addr=$imageub_addr"]
            incr mod_count
          }
          if {[string match "imageub_flash_addr=*" $line]&& ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_flash_addr=$imageub_flash_addr"]
            incr mod_count
          }
          if {[string match "imageub_flash_size=*" $line]&& ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_flash_size=$imageub_flash_size"]
            incr mod_count
          }
        }
          
        
        
        if {[file exists ${posfolder}/boot.script]} { 
          TE::UTILS::te_msg TE_PLX-??? INFO "Existing Boot script file ( ${posfolder}/boot.script ) will be overwrite with new one \n \
          ------" 
        }
        set fp_w [open ${posfolder}/boot.script "w"]
        foreach line $data {
          puts $fp_w $line
        }
        close $fp_w
        set t_PYTHONHOME $::env(PYTHONHOME)
        set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        set t_PYTHONPATH $::env(PYTHONPATH)
        set t_PYTHON $::env(PYTHON)
        unset ::env(PYTHONHOME) 
        unset ::env(LD_LIBRARY_PATH) 
        unset ::env(PYTHONPATH)
        unset ::env(PYTHON) 
        #start 
        set command exec
        # lappend command xterm
        # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;mkimage -c none -A arm -T script -d boot.script boot.scr"
        # lappend command gnome-terminal
        lappend command mkimage
        lappend command -c none
        lappend command -A arm
        lappend command -T script
        lappend command -d boot.script
        lappend command boot.scr
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-??? INFO "Command results from mkimage \"$command\": \n \
            $result \n \
          ------" 
        set ::env(PYTHONHOME) $t_PYTHONHOME
        set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
        set ::env(PYTHONPATH) $t_PYTHONPATH
        set ::env(PYTHON) $t_PYTHON
        # delete timestamp on script file to see if customer has reused it        
        set fp_r [open ${posfolder}/boot.script "r"]
        set file_data [read $fp_r]
        close $fp_r 
        set data [split $file_data "\n"]
        set fp_w [open ${posfolder}/boot.script "w"]
        foreach line $data {
          if {[string match "*Boot Source Script File creation date:*" $line]} {
            puts $fp_w "echo \[TE_BOOT-00\] Boot Source Script File creation date: customer template version"
          } else {
            puts $fp_w $line
          }
        }
         close $fp_w
          
      } else {
        TE::UTILS::te_msg TE_PLX-??? WARNING "Boot source file generation skipped, customer must create correct file \n \
				------" 
      }
			cd $cur_path 
		}
    #--------------------------------
    #--plx_run: 
    proc plx_run {{refresh false}} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			# create project if missing
			if {![file exists ${TE::PETALINUX_PATH}] } {
				set ospath [file normalize ${TE::PETALINUX_PATH}/..]
				file mkdir ${ospath}
				cd ${ospath}
				set command exec
				lappend command petalinux-create 
				lappend command --type project
				
				
				lappend command --name $prjname
				if {$TE::IS_ZUSYS} {
					lappend command --template zynqMP
				} elseif {$TE::IS_ZSYS} {
					lappend command --template zynq
				} elseif {$TE::IS_MSYS} {
					lappend command --template microblaze
				} else {
					return -code error "unkown system"
				}
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 
			}
			cd ${TE::PETALINUX_PATH}
			
			set xsafile  [list]
			if { [catch {set xsafile [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}] || $refresh} {
				#copy xsa
				TE::UTILS::generate_workspace_petalinux 
				# load xsa
				set command exec
				lappend command petalinux-config 
				lappend command --get-hw-description 
				lappend command --silentconfig
				set result [eval $command]
				TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
						$result \n \
					------" 
			} 
			# build project
			set command exec
			lappend command petalinux-build 
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
          $result \n \
        ------" 
			
			#todo copy files to prebuilt(todo selection)
			set posfolder ${TE::PREBUILT_OS_PATH}/petalinux/${TE::DDR_SIZE}/
			file mkdir ${posfolder}
			
			# [catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/boot.scr ${posfolder}}]
			#todo boot.scr
			[catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/image.ub ${posfolder}}]
			[catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/u-boot.elf ${posfolder}}]
			[catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/bl31.elf ${posfolder}}]
			
			cd $cur_path
      #create Trenz boot.src file:
      puts "todo template script version testen --> parameter mit in die settings aufnehmen und parameter aus dem sw csv uebergeben und das hier bei run ausfuehren"      
      TE::PLX::plx_bootsrc
    }  
    #--------------------------------
    #--plx_clear: 
    proc plx_clear {} {
			set cur_path [pwd]
			cd ${TE::PETALINUX_PATH}
			
			set command exec
			lappend command petalinux-build 
			lappend command -x mrproper
			lappend command -f
			set result [eval $command]
			TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
          $result \n \
        ------" 
				
			# -----
			set delfiles  ${TE::PETALINUX_PATH}/components/yocto/
			if {[file exists $delfiles]} {
				puts "Delete: $delfiles"
				file delete -force -- $delfiles
			}				
			# -----
			set delfiles  ${TE::PETALINUX_PATH}/.xil/
      #todo hidden files will be not detect on linux  os
			if {[file exists $delfiles]} {
				puts "Delete: $delfiles"
				file delete -force -- $delfiles
			}
			# -----
			set delfiles  [list]
			[catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/.petalinux/ *]}]
			set idx [lsearch $delfiles "*metadata"]
			set delfiles [lreplace $delfiles $idx $idx]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			[catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/project-spec/hw-description/ *]}]
			set idx [lsearch $delfiles "*metadata"]
			set delfiles [lreplace $delfiles $idx $idx]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			[catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			[catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.bit]}]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			[catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.mmi]}]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
      
      # ----
      # bugfix for petalinux to reload memory. todo check from time to time if it's still needed
      
      set file_name "${TE::PETALINUX_PATH}/project-spec/configs/config"
      if {[file exists ${file_name}]} {
        set fp_r [open ${file_name} "r"]
        set file_data [read $fp_r]
        close $fp_r
        set data [split $file_data "\n"]
        # modify
        set line_index -1
        set mod_count 0
        
        # remove memory setting to reload memory with xsa import
        set line_check "CONFIG_SUBSYSTEM_MEMORY_*"
        foreach line $data {
          incr line_index
          if {[string match $line_check $line]} {
            set data [lreplace $data[set data {}] $line_index $line_index "# $line"]
            incr mod_count
          }
        }
        TE::UTILS::te_msg TE_PLX-??? INFO "$mod_count lines was modified in \"$file_name\": \n \
        ------" 
        #save 
        set fp_w [open ${file_name} "w"]
        foreach line $data {
          puts $fp_w $line
        }
        close $fp_w
      } else {
        TE::UTILS::te_msg TE_PLX-??? WARNING "File  is missing: \"$file_name\": \n \
          ------" 
      }
      
			cd $cur_path 
    }   
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished plx functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # git patch functions
    # -----------------------------------------------------------------------------------------------------------------------------------------

    #--------------------------------
    #--plx_config: 
    # proc git_config {{gittype "NA"}} {
      # set ::TE::PLX::GPATH "TBD"
      # set ::TE::PLX::PATH_ORIGIN  "NA"
      # set ::TE::PLX::PATH_UPSTREAM "NA"
      # set ::TE::PLX::PATH_LOCAL "NA"
      # if {[catch {set ::TE::PLX::GPATH  ${::env(TE_GITCONFIG_PATH)}}]} {
        # set ::TE::PLX::GPATH "../../../../../xilinx/XilinxGitPatch"
      # }

      # if {[file exists ${::TE::PLX::GPATH}/git_cfg.tcl]} {
        # TE::UTILS::te_msg TE_PLX-??? INFO "Use GIT config from ${::TE::PLX::GPATH}/git_cfg.tcl"
        # source ${::TE::PLX::GPATH}/git_cfg.tcl
      # } else {
        # TE::UTILS::te_msg TE_PLX-??? ERROR " GIT config is missing ${::TE::PLX::GPATH}/git_cfg.tcl"
      # }
      
      # if {[string match -nocase "$gittype" "l" ]} {
        # set ::TE::PLX::PATH_ORIGIN    ${::TE::GIT_EXT::PATH_XILINX_LINUX_ORIGIN}
        # set ::TE::PLX::PATH_UPSTREAM  ${::TE::GIT_EXT::PATH_XILINX_LINUX_UPSTREAM}
        # set ::TE::PLX::PATH_LOCAL     ${::TE::GIT_EXT::PATH_XILINX_LINUX_LOCAL}
      # } elseif {[string match -nocase "$gittype" "u" ]} {
        # set ::TE::PLX::PATH_ORIGIN    ${::TE::GIT_EXT::PATH_XILINX_UBOOT_ORIGIN}
        # set ::TE::PLX::PATH_UPSTREAM  ${::TE::GIT_EXT::PATH_XILINX_UBOOT_UPSTREAM}
        # set ::TE::PLX::PATH_LOCAL     ${::TE::GIT_EXT::PATH_XILINX_UBOOT_LOCAL}
      # } elseif {[string match -nocase "$gittype" "e" ]} {
        # set ::TE::PLX::PATH_ORIGIN    ${::TE::GIT_EXT::PATH_XILINX_EMBEDDED_ORIGIN}
        # set ::TE::PLX::PATH_UPSTREAM  ${::TE::GIT_EXT::PATH_XILINX_EMBEDDED_UPSTREAM}
        # set ::TE::PLX::PATH_LOCAL     ${::TE::GIT_EXT::PATH_XILINX_EMBEDDED_LOCAL}
      # } else {
        # TE::UTILS::te_msg TE_PLX-??? ERROR " Unkown GIT setup"
      # }
      # puts ${::TE::PLX::PATH_ORIGIN}
      # puts ${::TE::PLX::PATH_UPSTREAM}
      # puts ${::TE::PLX::PATH_LOCAL}
    # }
    #--------------------------------
    #--plx_config:
    proc git_patch {} {
      set cur_path [pwd]
      if {[file exists ${TE::TMP_PATH}] } {
        puts "Delete:  ${TE::TMP_PATH}"
        file delete -force --  ${TE::TMP_PATH}
      } 
      if {[catch {set ::TE::PLX::GPATH  ${::env(TE_GITCONFIG_PATH)}}]} {
        set ::TE::PLX::GPATH "../../../../../xilinx/XilinxGitPatch"
      }
      if {[file exists ${::TE::PLX::GPATH}/git_cfg.tcl]} {
        TE::UTILS::te_msg TE_PLX-??? INFO "Use GIT config from ${::TE::PLX::GPATH}/git_cfg.tcl"
        source ${::TE::PLX::GPATH}/git_cfg.tcl
        
        puts "Test TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN: $::env(TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN)"
        puts "Test TE_GIT_PATH_XILINX_LINUX_ORIGIN: $::env(TE_GIT_PATH_XILINX_LINUX_ORIGIN)"
        puts "Test TE_GIT_PATH_XILINX_UBOOT_ORIGIN: $::env(TE_GIT_PATH_XILINX_UBOOT_ORIGIN)"
      } else {
        TE::UTILS::te_msg TE_PLX-??? ERROR " GIT config is missing ${::TE::PLX::GPATH}/git_cfg.tcl"
      }
      file mkdir ${TE::TMP_PATH}
      cd ${TE::TMP_PATH}
      
      set t_PYTHONHOME $::env(PYTHONHOME)
      set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
      set t_PYTHONPATH $::env(PYTHONPATH)
      set t_PYTHON $::env(PYTHON)
      unset ::env(PYTHONHOME) 
      unset ::env(LD_LIBRARY_PATH) 
      unset ::env(PYTHONPATH)
      unset ::env(PYTHON) 
      
      set command exec
      # lappend command xterm
      # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;sudo git clone ${::TE::PLX::PATH_ORIGIN}"
      lappend command gnome-terminal
      lappend command -- "${::TE::SCRIPT_PATH}/run_XilinxGit.sh"
      lappend command &
      #gnome-terminal will not wait, so use pid for waiting
      set result [eval $command]
      set cnt 0
      while {[file exists /proc/$result]} {
        set running [file exists /proc/$result]
        if {[expr $cnt % 1000000] == 0} {
          puts "waiting for closing GUI with PID $running"
        }
         set cnt [expr $cnt + 1]
      }
      
      TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\":($running) \n \
          $result \n \
        ------" 
        


      set ::env(PYTHONHOME) $t_PYTHONHOME
      set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
      set ::env(PYTHONPATH) $t_PYTHONPATH
      set ::env(PYTHON) $t_PYTHON
      cd $cur_path 

      # cd ${::TE::PLX::PATH_LOCAL}
      puts "Test TE_GIT_PARAMETER: $::env(TE_GIT_PARAMETER)"
      puts "Test TE_GIT_PATCH: $::env(TE_GIT_PATCH)"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished git patch  functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "INFO:(TE) Load Vivado script finished"
}
