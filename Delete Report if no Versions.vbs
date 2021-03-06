Dim BZobject          'COM OBJECT FOR BLUEZONE

Dim BZC               'Connection to Bluezone

Dim ViewDirectValue

Dim Validate_ReportValue

Dim treportID

Dim tValidReport

Dim Continue

Dim LoopValue

Dim ConfirmationValue

Dim Writer



Set WFobject = CreateObject( "Shell.Application" )

Set BZO = CreateObject( "BZWhll.whllObj" )



BZC = BZO.Connect( "A" ) ' connection to BlueZone



If (BZC = 0) Then   ' main execution statement 0 is for successful connection

	BZO.Focus

	OpenVDRM01()  ' this will be the main execution statements

	

	Do 

	Writer = InputBox("Enter Report ID:","Mobius Cleanup")

	ViewDirectValue = ViewDirect(Writer) ' This function(method) return a 1 or 2 depending on whether there are report verions or not

	If (ViewDirectValue = 1) Then ' if there are report version then execute expiration date, this returns the expiration date to write down. 

		ExpirationDate()

	Else                          ' if no report version then its time to delete stuff(copy request and then the report)

		Validate_ReportValue = Validate_Report() ' this will return a 1 or 2 depending on if the writer you type in is found

		If (Validate_ReportValue = 1) Then ' if there is a report/writer to delete then it will ask you to continue

			Continue = BZO.MsgBox ("Report " & tValidReport & " can be deleted, do you wish to continue?", 1) 'this is asking to delete

			If (Continue = 1) Then ' one is from hitting ok on the popup box

				Delete_CopyRequest()

				Delete_CopyDistribution()

				goto_Selective_Distribution()

				Delete_Selective_Distribution()

				Delete_Report()

				ConfirmationValue = Confirmation() ' this will return 1 for a successful deletion or 2 for non successful

			ElseIf (Continue = 2) Then ' two is from hitting cancel on the popup box

				StopScript

			Else

				StopScript

			End If

		Else 

			BZO.MsgBox "Report " & treportID & " doesn't exist, Scan into Mobius"

			BZO.SendKey "<PF3>"

			BZO.WaitReady 10, 1

			BZO.SendKey "<PF3>"

			BZO.WaitReady 10, 1

		End If

		

	End If

	LoopValue = BZO.MsgBox (ConfirmationValue & vbCrLf & "Do you want to run the scrip again?", 1) ' this is asking to repete the script

	If (LoopValue = 2) Then

		StopScript

	End If

	Loop Until LoopValue <> 1



Else

	BZO.MsgBox "Did not make a connection with BlueZone"

	StopScript

End If			' ending to the If statement



Public Sub OpenVDRM01() ' this will open VDRM01 from TXP. It will first interupt then open. 

Dim VDRMHostScreen 

Dim Column_Counter

Dim Row_Counter

Column_Counter = 6

Row_Counter = 6

	BZO.SendKey "<PA2>"

	BZO.WaitReady 10, 1

	BZO.WriteScreen "m", 23, 15

	BZO.WaitForText "m", 23, 15, 2

	BZO.SendKey "<PF7>"

	Do Until (VDRMHostScreen = "VDRM01")

		BZO.ReadScreen VDRMHostScreen, 6, Row_Counter, Column_Counter	

		Row_Counter = Row_Counter + 1

		If(Row_Counter = 23) Then

			BZO.SendKey "<PF8>"

			BZO.WaitReady 10, 1

			Row_Counter = 6

		End If

	Loop

	BZO.WriteScreen "i", Row_Counter - 1, Column_Counter - 2

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 2

	BZO.WriteScreen "s",Row_Counter - 1, Column_Counter - 2

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 1

End Sub



Public Sub ExpirationDate() ' This sub looks for an expiration date and returns that expiration if found. 

	BZO.ReadScreen Expiration, 8, 9, 71

	BZO.MsgBox "The expiration date for " & treportID & " is " & Expiration

	BZO.SendKey "<PF3>"

	BZO.WaitReady 10, 1

	BZO.SendKey "<PF3>"

	BZO.WaitReady 10, 1

	BZO.SendKey "<PF3>"

	BZO.WaitReady 10, 1

End Sub



Function Validate_Report() ' this function checks for a report. 

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "2 "

BZO.WaitForText "2", 3, 21, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.SendKey "v"

BZO.WaitForText "v", 7, 10, 2

BZO.WriteScreen treportID, 9, 21

BZO.WaitForText treportID, 9, 21

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.ReadScreen ValidReport, 8, 9, 21

tValidReport = Trim(ValidReport)

If (tValidReport = treportID) Then ' if the report we are looking for is found in the report screen then it will return 1

	Validate_Report = 1

Else 

	Validate_Report = 2 ' there is currenlty no report setup

End If

End Function



Public Sub Delete_CopyRequest() ' this subroutine will list all of the complete copy request 

Dim CopyRequest_Row

CopyRequest_Row = 8

Dim tCopyRequest

Dim tFinalCheck

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "5"

BZO.WaitForText "5", 3, 21, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.SendKey "3"

BZO.WaitForText "3", 3, 21, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.SendKey "L"

BZO.WaitForText "L", 7, 10, 2

BZO.WriteScreen tValidReport, 9, 20

BZO.WaitForText tValidReport, 9, 20, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

End Sub



Public Sub Delete_CopyDistribution() ' this subroutine will delete of all complete copy request. 

Dim CopyRequest_Row

CopyRequest_Row = 8



Do

	BZO.ReadScreen CopyRequest, 10, CopyRequest_Row, 4

	tCopyRequest = Trim(CopyRequest)

	If (tCopyRequest = tValidReport) Then

		BZO.WriteScreen "d", CopyRequest_Row, 2

		BZO.WaitForText "d", CopyRequest_Row, 2, 2

		BZO.SendKey "<Enter>"

		BZO.WaitReady 10, 1

		BZO.ReadScreen Transaction, 13, CopyRequest_Row, 64

		If (Transaction = "** Deleted **") Then

			CopyRequest_Row = CopyRequest_Row + 1 

				If (CopyRequest_Row = 24) Then

					BZO.SendKey "<PF8>"

					BZO.WaitReady 10, 1

					CopyRequest_Row = 8

				End If

		Else

			StopScript

		End If



	ElseIf(tCopyRequest <> tValidReport) Then Exit Do



	Else

		StopScript

	End If

Loop Until (tCopyRequest <> tValidReport)

End Sub



'need a couple of new subroutines to get to the selective distirbution and then to delete all copy requests. 



Public Sub goto_Selective_Distribution() ' this subroutine will list all of the Selective Distirbution copy request. 

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "4"

BZO.WaitForText "4", 3, 21, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.SendKey "L"

BZO.WaitForText "L", 7, 10, 2

BZO.WriteScreen tValidReport, 9, 20

BZO.WaitForText tValidReport, 9, 20, 2

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

End Sub



Public Sub Delete_Selective_Distribution() ' this subroutine will delete all Selective distribution request. 

Dim SelectiveDistribution_Row

SelectiveDistribution_Row = 8



Do

	BZO.ReadScreen SelectiveRequest, 10, SelectiveDistribution_Row, 4

	tSelectiveRequest = Trim(SelectiveRequest)

	If (tSelectiveRequest = tValidReport) Then

		BZO.WriteScreen "d", SelectiveDistribution_Row, 2

		BZO.WaitForText "d", SelectiveDistribution_Row, 2, 2

		BZO.SendKey "<Enter>"

		BZO.WaitReady 10, 1

		BZO.ReadScreen STransaction, 13, SelectiveDistribution_Row, 64

		If (STransaction = "** Deleted **") Then

			SelectiveDistribution_Row = SelectiveDistribution_Row + 1

				If (SelectiveDistribution_Row = 24) Then

					BZO.SendKey "<PF8>"

					BZO.WaitReady 10, 1

					SelectiveDistribution_Row = 8

				End If

		Else

			StopScript

		End If



	ElseIf(tSelectiveRequest <> tValidReport) Then Exit Do



	Else

		StopScript

	End If

Loop Until (tSelectiveRequest <> tValidReport)

End Sub





Public Sub Delete_Report() ' subroutine that deletes the report 

Dim confirmReport

Dim tconfirmReport

BZO.WaitReady 10, 1

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "<PF3>"

BZO.WaitReady 10, 1

BZO.SendKey "2"

BZO.WaitForText "2", 3, 21, 2

BZO.SendKey "<Enter>" 

BZO.WaitReady 10, 1

BZO.SendKey "v"

BZO.WaitForText "v", 7, 10, 2

BZO.WriteScreen tValidReport, 9, 21

BZO.WaitForText tValidReport, 9, 21

BZO.SendKey "<Enter>"

BZO.WaitReady 10, 1

BZO.ReadScreen confirmReport, 8, 9, 21

tconfirmReport = Trim(confirmReport)

If (tValidReport = tconfirmReport) Then 

	BZO.WriteScreen "d", 7, 10

	BZO.WaitForText "d", 7, 10

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 1

	

Else 

	BZO.Msgbox "Report no longer exist or more copy request"

End If

End Sub



Function Confirmation() ' function that confirms whether a report was deleted or not.  

Dim transaction

BZO.ReadScreen transaction, 20, 1, 8

If (transaction = "TRANSACTION ACCEPTED") Then

	Confirmation = "The report (" & tValidReport & ") was deleted successfully"

	BZO.SendKey "<PF3>"

	BZO.WaitReady 10, 1

	BZO.SendKey "<PF3>"

	BZO.WaitReady 10, 1

Else

	BZO.MsgBox "The report was NOT deleted"

	StopScript

End If

End Function



Function ViewDirect(reportID) ' check to see if there are report versions

Dim tmatching_Report

	treportID = Trim(reportID)

	If (treportID = "") Then

		MsgBox "Input box is empty"

		StopScript

	End If

	BZO.SendKey "2"

	BZO.WaitForText "2", 3, 21, 2

	BZO.SendKey "<Enter>" 

	BZO.WaitReady 10, 1

	BZO.SendKey "12"

	BZO.WaitForText "12", 3, 21, 2

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 1

	BZO.SendKey "v"

	BZO.WaitForText "v", 7, 10, 2

	BZO.WriteScreen treportID, 09, 026

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 1

	BZO.SendKey "<Enter>"

	BZO.WaitReady 10, 1

	BZO.ReadScreen matching_Report, 10, 5, 10

	tmatching_Report = Trim(matching_Report)

	If (tmatching_Report = treportID) Then 'if there are version then = 1

		'BZO.MsgBox "Match"

		ViewDirect = 1

	Else						   'if there are NO version then = 2

		'BZO.MsgBox "no match"

		ViewDirect = 2

	End If

End Function
