MenuItemNames := []
MenuItemNames.Insert("����������web-front")
MenuItemNames.Insert("����������web-admin")
MenuItemNames.Insert("���ԣ�����web-front")
MenuItemNames.Insert("���ԣ�����web-admin")
MenuItemNames.Insert("��дֱ��ע����")
MenuItemNames.Insert("-----")
MenuItemNames.Insert("ebook")
MenuItemNames.Insert("-----")
MenuItemNames.Insert("BCompare")
MenuItemNames.Insert("�е��Ʊʼ� (&B)")
MenuItemNames.Insert("RegexBuddy")
MenuItemNames.Insert("PicPick")
MenuItemNames.Insert("SQLiteAdmin")
MenuItemNames.Insert("����")
MenuItemNames.Insert("Filezilla")
MenuItemNames.Insert("Firefox")
MenuItemNames.Insert("KMPlayer")
MenuItemPaths := []
MenuItemPaths.Insert("http://wwh.lianmeng.360.cn/index")
MenuItemPaths.Insert("http://wwh.lianmeng.360.cn:8000")
MenuItemPaths.Insert("http://lianmeng.360.cn/index")
MenuItemPaths.Insert("http://lianmeng.360.cn:8000")
MenuItemPaths.Insert("E:\doc\closesource\qh\signuphao360_fillform.au3")
MenuItemPaths.Insert("-----")
MenuItemPaths.Insert("e:\ebook")
MenuItemPaths.Insert("-----")
MenuItemPaths.Insert(BeyondCompare)
MenuItemPaths.Insert("C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe")
MenuItemPaths.Insert("C:\Program Files (x86)\Just Great Software\RegexBuddy3\RegexBuddy.exe")
MenuItemPaths.Insert("C:\Program Files (x86)\PicPick\picpick.exe")
MenuItemPaths.Insert("D:\prog\sqliteadmin\sqliteadmin.exe")
MenuItemPaths.Insert("C:\Program Files\China Mobile\Fetion\Fetion.exe")
MenuItemPaths.Insert("C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe")
MenuItemPaths.Insert("D:\Program Files\Firefox26\App\Firefox\firefox.exe")
MenuItemPaths.Insert("C:\Program Files\The KMPlayer\KMPlayer.exe")

;make a popup menu to open urls/apps
For index, name in MenuItemNames
	if(name = "-----"){
		Menu, m, Add,,,
	} else {
		Menu, m, Add,%name%, MenuHandler2
		path := MenuItemPaths[index]
		pos := InStr(path,"http:")
		try{
			if (InStr(path,"http:") <> 1) {
				Menu, m, Icon,%name%, %path%
			}
		}catch e {

		}
	}