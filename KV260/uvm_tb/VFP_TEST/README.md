# VFP_TEST Environment
<h1 align="center">
  <br/>
  <img src="https://github.com/zakinder/VFP_TEST/blob/master/doc/environment.PNG" alt="Environment" width="525px"/>
  <br/>
  <br/>
</h1>

```
Figure shows the relationship between the different parts.
```

# TEST

Test class initiate and execute sequence on the specified sequencer in the run phase. First, simulator command line specifies the name of the test +UVM_TESTNAME=test to run. Then UVM factory creates a component of the test and starts its phase methods through run_test task which is called from the static part of test bench which is in initial block of the top-level test bench module. When run_test task is called, it constructs the root component of the uvm environment in the user test which than trigger and initiate the uvm phasing component. Basically, calling run_test task causes the selected test to be constructed which first build uvm environment from top to downward and responsible for getting a reference to the uvm_root class instance from UVM core services. UVM infrastructure build phase start from selected test and continue to flow for next phasing until all uvm phases are completed which include connect and run sub phases. UVM calls $finish once all the phases are completed and return the control to top test bench module initial block.  If no test and environment is created than fatal message will issued. However, test can be run in a uvm environment by specifying the test name as argument to run_test or call test name in command line argument. Once build, connect and end_of_elaboration phases are completed start_of_simulation phase gets initiated before time consuming run phase. This phase display banners and test bench topology and configuration information.

After start_of_simulation phase run phase gets initiated which is used for the stimulus generation and checking activities of the test bench and execution of all uvm_component run tasks in parallel. Each uvm_component run phase task run in parallel where main phase gets initiated, and stimulus of specified test case is generated and applied to the dut.

Most commonly in the user test, the uvm_phase object is used to raise and drop objection to void moving on the next phase, raise_objection() and drop_objection() are the methods to that. Both methods are used in the user test in the run phase and in between raise and drop objection sequence get started. When drop objection condition is met, action taken is to move to next phase of non-time-consuming cleanup phase and finally test ends.

