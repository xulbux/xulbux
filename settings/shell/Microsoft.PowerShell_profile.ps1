# ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1

# NOTE: This config is for PowerShell from https://aka.ms/powershell, not Windows PowerShell.


######################################## STARSHIP ########################################

# INITIALIZE STARSHIP
Invoke-Expression (&starship init powershell)
Enable-TransientPrompt

# DISPLAY SIMPLIFIED PROMPT FUNCTION
function Invoke-Starship-TransientFunction {
    # CLEAR DETAILED PROMPT
    [Console]::SetCursorPosition(0, [Math]::Max(0, $host.UI.RawUI.CursorPosition.Y))
    [Console]::Write("`e[J")
    # RETURN SIMPLIFIED PROMPT
    $output = &starship module character
    $stripped = $output -replace "`e\[[0-9;]*m", ""
    "`e[1;35m$stripped`e[0m"
}


###################################### INTELLISENSE ######################################
# Install-Module -Name PSReadLine -Force

# ENABLE PREDICTION BASED ON COMMAND HISTORY
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# KEYBINDINGS FOR TAB COMPLETION
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ACCEPT NEXT WORD OF INLINE SUGGESTION
Set-PSReadLineKeyHandler -Key Shift+RightArrow -Function AcceptNextSuggestionWord

# PASTE AS SINGLE UNDO UNIT
Set-PSReadLineKeyHandler -Key Ctrl+V -Function Paste


######################################## HISTORY #########################################

# KEYBINDINGS FOR HISTORY SEARCH
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# MOVE CURSOR TO END OF LINE WHEN RECALLING HISTORY ON EMPTY LINE
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Key DownArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}

# COMMAND HISTORY BROWSER
Set-PSReadLineKeyHandler -Chord "Ctrl+h" -ScriptBlock {
    $commands = Get-Content (Get-PSReadLineOption).HistorySavePath | Select-Object -Unique
    [array]::Reverse($commands)

    $selectedCommand = $commands | Out-GridView -Title "Command History" -PassThru

    if ($selectedCommand) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selectedCommand)
    }
}
