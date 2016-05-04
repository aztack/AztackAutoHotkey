get_path_in_vscode_title()
{
	WinGetTitle, title
	apath := RegExReplace(title, "^(.*) \(.*\) - Visual Studio Code$","$1")
	SplitPath, apath, filename, dir,,
	return dir
}
#IfWinActive ahk_class Chrome_WidgetWin_1
	~^!c::
	dir := get_path_in_vscode_title()
	Run, cmd /k cd /d "%dir%"
	return
	
	#e::
	dir := get_path_in_vscode_title()
	Run,"%dir%"
	return

#IfWinActive

