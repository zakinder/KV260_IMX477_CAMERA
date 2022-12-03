$ie = new-object -comobject InternetExplorer.Application
$ie.visible = $true

$ie.addressbar=$false

$ie.menubar=$false
$ie.toolbar=$false
$ie.top = 200; $ie.Left = 100
$ie.navigate("file:///K:/ZEDBOARD/uvm_tb/VFP_TEST/workspace/coverage_reports/1_questa_html_coverage_reports/img_cgain_test/index.html")


