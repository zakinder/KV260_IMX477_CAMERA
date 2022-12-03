vlog -f ../../includes/dut_vlg.f
vopt top -o top_optimized  +acc +cover=sbfec+top(rtl).

# package require for grep
quietly package require fileutil 
# Make a directory to store regressions
quietly set Date [clock format [clock seconds] -format %a-%b-%d]
quietly set RegressionOutputDir [format "Regression_Run_%s" $Date]
file mkdir $RegressionOutputDir

quietly set FPU_Testcases [list img_cgain_sharp_test img_cgain_sharp_test]
quietly set Tests  2


foreach {Testcase} $FPU_Testcases {
  # run tests N times
  echo  "running $Testcase"
  for {set N 0} {$N<$Tests} {incr N} {
  
  
    # Build unique names for each simulation
    # Start the simulation
    vsim  top_optimized -sv_seed $N -onfinish stop -wlfnocollapse -assertdebug -msgmode both -coverage -displaymsgmode both -quiet +UVM_TESTNAME=$Testcase +UVM_VERBOSITY=UVM_MEDIUM



    # The variable Sv_Seed always hold the value of the seed defined / selected
    set Base                 [format "run_%s__%d__%d"  $Testcase $N $Sv_Seed]
    set LOG_File             [format "%s.log"  $Base]
	set WLF_File             [format "%s.wlf"  $Base]
	set DEBUGDB_File         [format "%s.db"   $Base]
	set UCDB_File            [format "%s.ucdb" $Base]
    
    
    # Ensure that we generate the needed files in the right place
 	 set LOG_Filename         [file join $RegressionOutputDir $LOG_File]
	 set WLF_Filename         [file join $RegressionOutputDir $WLF_File]
	 set DEBUGDB_Filename     [file join $RegressionOutputDir $DEBUGDB_File]
	 set UCDB_Filename        [file join $RegressionOutputDir $UCDB_File] 
	 transcript file $LOG_Filename
	 transcript quietly
     
     
    # Simulation specific setup
  	set StdArithNoWarnings   1
  	set NumericStdNoWarnings 1
    run 1
	 if {[batch_mode]} {
		 source wave_batch.do
	 } else {
		 source wave.do
	 }
    # Run the simulation
 	 run -all
    # Store the needed user defined name / value pair into the UCDB structure
    coverage attr -name TESTNAME     -value $Base
    coverage attr -name Dir          -value $RegressionOutputDir
 	 coverage attr -name WLFFile      -value $WLF_File
	 coverage attr -name LOGFile      -value $LOG_File
	 coverage attr -name DebugDB      -value $DEBUGDB_File
    # Find and store the needed user defined name / value pair into the UCDB structure
    coverage attr -name Warnings     -value [llength [fileutil::grep Warning   $LOG_Filename]]
    coverage attr -name Errors       -value [llength [fileutil::grep Error     $LOG_Filename]]
    # Save WLF
    dataset save sim $WLF_Filename
    # save the UCDB structure, includes coverage data, and user data 
 	 coverage save $UCDB_Filename
    # Clean up, and prepare for next run...
	 quit -sim
  }
}