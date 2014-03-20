# encoding:gb2312
require 'json'
require 'erubis'

output = `es -p *system32*etc*hosts`
if output['not']
	$stdout.puts output
	$stdout.puts "Run Everything if you already installed, otherwise download from http://www.voidtools.com/download.htm"
	exit
end
	
def search(pattern)
	`es -p "#{pattern}"`.split("\n")
end

executables = {
	'SublimeText'=>'*sublime*sublime_text.exe',
	'EditPlus' => '*edit*editplus.exe',
	'PicPick' => '*picpic*picpick.exe',
	'KMPlayer' => '*kmp*kmplayer.exe',
	'CHS' => '*ClipboardHelpAndSpell*ClipboardHelpAndSpell.exe',
	'QQ' => '*Tencent*QQ.exe',
	'Firefox' => '*firefox*firefox.exe',
	'BeyondCompare' => '*compare*Bcompare*.exe',
	'FileZilla' => '*filezilla*filezilla.exe',
	'YoudaoNote' => '*YoudaoNote*RunYNote.exe',
	'XShell' => '*Xshell*Xshell*.exe',
	'Thunder' => '*Thunder*program*Thunder.exe',
	'Lingoes' => '*lingoes*lingoes.exe',
	'Outlook' => '*office*outlook.exe',
	'ToDoList' => '*todolist*todolist.exe',
	'Everything' => '*everything*everything.exe',
	'Chrome' => '*google*\chrome.exe'
}
installed = {}

#
# generate paths.ahk
#
File.open("paths.ahk",'w') do |file|
	file.puts ";Auto-Generated Executable Paths"
	executables.each do |name, pattern|
		path = search(pattern).first
		installed[name] = if path.size == 0
			false	
		else
			s = %Q|#{name} := "#{path}"|
			$stdout.puts s
			file.puts s
			true
		end
	end
end unless File.exists?('paths.ahk')

#
# genereate menus
#
menus = []
Dir['*.json'].each do |jsonf|
	File.open(jsonf) do |file|
		config = JSON.parse file.read
		menus << config
	end
end

#
# finally generate main script
#
File.open("aztack.ahk",'w:gb2312') do |f|
	eruby = Erubis::Eruby.new File.read('aztack.erb')
    ctx = Erubis::Context.new
    ctx['menus'] = menus
    ctx['installed'] = installed
    code = eruby.evaluate ctx
	f.puts code.encode('gb2312')
end