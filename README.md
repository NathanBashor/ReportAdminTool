# ReportAdminTool
This was a tool that I created to automate deleting reports. 
This tool works with the Rocket bluezone mainframe emulator applicaiton and ViewDirect for mainframe. 
It uses methods available to the emulator. 
This tool, will check to see if a reports can be deleted first. It will check to see if any current version of the report exists. 
If no version exists it will then begin the delete process, first deleting recipients who can view the report and then it will delete the 
report template itself. 
If the report still has versions to view, it will let you know that the report cannot be deleted becuase of those versions. 
