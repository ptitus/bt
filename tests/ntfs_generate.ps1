# load functions
. k:\Get-FileTimeStamp.ps1

# define Variables
$diskNo='1'
$partitionStyle='gpt'
$driveLetter='E'
$resultFile='K:\ntfssrc.json'
$fsLabel='ntfspart'

#define functions
function make-filejson(){
	param(
		[string]$fileName,
		[string]$filePath
	)
	
	begin {}
	
	process {
		$myFile = "${filepath}\${fileName}"
		$fsutilResult = fsutil file layout "${myFile}"

		$myJson.files.${fileName}=[ordered]@{}

		$myJson.files.${fileName}.filepath = ((Get-Item $myFile).FullName).substring(2).replace("\","/")

		$myJson.files.$($fileName).inode = ""

		$attr = (Get-Item $myFile).Mode.Substring(0,1)
		$myFileType = "r"
		if ($attr -like "d") {$myFileType = "d"}

		$myJson.files.${fileName}.file_type = $myFileType 

		$myJson.files.${fileName}.mode = (Get-Item $myFile).Mode

		$myJson.files.${fileName}.size = (Get-Item $myfile).Length

		$myJson.files.${fileName}.modified = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).LastWriteTimeUtc) -uformat "%s"))

		$myJson.files.${fileName}.accessed = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).LastAccessTimeUtc) -uformat "%s"))
		
		$fchanged = $fsutilResult | select-string -pattern "Change Time\s+:\s+(.*)" | %{$_.matches.groups[1].Value}
		$Y = ("$fchanged").split(" ")[0].split(".")[2]
		$M = ("$fchanged").split(" ")[0].split(".")[1]
		$D = ("$fchanged").split(" ")[0].split(".")[0]
		$hh = ("$fchanged").split(" ")[1].split(":")[0]
		$mm = ("$fchanged").split(" ")[1].split(":")[1]
		$ss = ("$fchanged").split(" ")[1].split(":")[2]
		$myJson.files.${fileName}.changed = [Math]::Floor([decimal](Get-Date -Year $Y -Month $M -Day $D -Hour $hh -Minute $mm -Second $ss -uformat "%s"))
		
		$myJson.files.${fileName}.created = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).CreationTimeUtc) -uformat "%s"))
		
		$myJson.files.${filename}.sha256 = Get-FileHash $myFile -Algorithm SHA256 | select -ExpandProperty Hash
		}
	end {}
}


# create partition 
Initialize-Disk -Number $diskNo -PartitionStyle $partitionStyle > Out-Null
New-Partition -Disknumber $diskNo -UseMaximumsize -AssignDriveLetter > Out-Null
sleep 2

# create filesystem
Format-Volume -DriveLetter $driveLetter -Filesystem NTFS -NewFileSystemLabel $fsLabel > Out-Null
sleep 5

# create json files
$myJson = [ordered]@{partition=[ordered]@{};fs=[ordered]@{};files=[ordered]@{}}
#  partition information
$myJson.partition.part_type = Get-Disk -Number $diskNo | select -ExpandProperty Partitionstyle
$myJson.partition.unit_size = Get-Disk -Number $diskNo | select -ExpandProperty LogicalSectorSize
$myJson.partition.first_unit = [int](Get-Partition -DiskNumber $diskNo | where DriveLetter -like $driveLetter | select -ExpandProperty Offset)/512

# file system
$fsutilResult = fsutil fsinfo ntfsinfo "${driveletter}:"
$myJson.fs.type = Get-Volume | where DriveLetter -like $driveLetter | select -ExpandProperty FileSystemType
$myJson.fs.name = Get-Volume | where DriveLetter -like $driveLetter | select -ExpandProperty FileSystemLabel
$myJson.fs.id = $fsutilResult | select-String -pattern "NTFS VOLUME Serial Number : \s+0x(.*)" | %{$_.matches.groups[1].Value}
$myJson.fs.version = $fsutilResult | select-String -pattern "NTFS Version\s+:\s+(.*)" | %{$_.matches.groups[1].Value}

# create objects in fs, record infos in json

new-Item "${driveLetter}:\file.0" -ItemType File > Out-Null
make-filejson -fileName "file.0" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\file.binary" -ItemType File > Out-Null
$data = new-object byte[] 10kb 
(new-object Random).NextBytes($data)
[IO.File]::WriteAllBytes("${driveLetter}:\file.binary", $data)
make-filejson -fileName "file.binary" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\file.txt" -ItemType File > Out-Null
# select characters from 0-9, A-Z, and a-z
$chars = [char[]] ([char]'0'..[char]'9' + [char]'A'..[char]'Z' + [char]'a'..[char]'z')
$chars = $chars * 126
# write file using 128 byte lines each with 126 random characters
(1..(10kb/128)).foreach({-join (Get-Random $chars -Count 126) | add-content "${driveLetter}:\file.txt" })
make-filejson -fileName "file.txt" -filePath "${driveLetter}:\"
		
new-Item "${driveLetter}:\delfile" -ItemType File > Out-Null
$data = new-object byte[] 10kb 
(new-object Random).NextBytes($data)
[IO.File]::WriteAllBytes("${driveLetter}:\delfile", $data)
make-filejson -fileName "delfile" -filePath "${driveLetter}:\"
Remove-Item "${driveLetter}:\delfile" -force

new-Item "${driveLetter}:\subdir" -ItemType Directory > Out-Null
make-filejson -fileName "subdir" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\subdir\file2.txt" -ItemType File > Out-Null
# select characters from 0-9, A-Z, and a-z
$chars = [char[]] ([char]'0'..[char]'9' + [char]'A'..[char]'Z' + [char]'a'..[char]'z')
$chars = $chars * 126
# write file using 128 byte lines each with 126 random characters
(1..(10kb/128)).foreach({-join (Get-Random $chars -Count 126) | add-content "${driveLetter}:\subdir\file2.txt" })
make-filejson -fileName "file2.txt" -filePath "${driveLetter}:\subdir"

# write json file
$myJson | ConvertTo-Json | Out-File $resultFile ASCII
