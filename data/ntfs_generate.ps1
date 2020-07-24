# load functions
. k:\Get-FileTimeStamp.ps1

# define Variables
$diskNo='1'
$partitionStyle='gpt'
$driveLetter='E'
$resultFile='K:\ntfssrc.json'
$fsLabel='ntfs'

function make-filejson(){
	param(
		[string]$fileName,
		[string]$filePath
	)
	
	begin {}
	
	process {
		$myFile = "${filepath}\${fileName}"
		$myJson.files.${fileName}=[ordered]@{}
		$myJson.files.${fileName}.filepath = ((Get-Item $myFile).FullName).substring(2).replace("\","/")
		$id = fsutil file queryFileID $myFile
		$myJson.files.$($fileName).inode = ($id).Split(" ")[3]
		$attr = (Get-Item $myFile).Mode.Substring(0,1)
		$myFileType = "r"
		if ($attr -like "d") {$myFileType = "d"}
		$myJson.files.${fileName}.file_type = $myFileType 
		$myJson.files.${fileName}.mode = (Get-Item $myFile).Mode
		$myJson.files.${fileName}.size = (Get-Item $myfile).Length
		$myJson.files.${fileName}.modified = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).LastWriteTimeUtc) -uformat "%s"))
		$myJson.files.${fileName}.accessed = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).LastAccessTimeUtc) -uformat "%s"))
		$myJson.files.${fileName}.changed = ""
		$myJson.files.${fileName}.created = [Math]::Floor([decimal](Get-Date((Get-Item $myFile).CreationTimeUtc) -uformat "%s"))
		}

	end {}
}

#write-Host $resultFile

# create partition 
Initialize-Disk -Number $diskNo -PartitionStyle $partitionStyle
New-Partition -Disknumber $diskNo -UseMaximumsize -AssignDriveLetter
sleep 2

# create filesystem
Format-Volume -DriveLetter $driveLetter -Filesystem NTFS -NewFileSystemLabel $fsLabel
sleep 5

# create json files
$myJson = [ordered]@{partition=[ordered]@{};fs=[ordered]@{};files=[ordered]@{}}
#  partition information
$myJson.partition.part_type = Get-Disk -Number $diskNo | select -ExpandProperty Partitionstyle
$myJson.partition.unit_size = Get-Disk -Number $diskNo | select -ExpandProperty LogicalSectorSize
$myJson.partition.first_unit = [int](Get-Partition -DiskNumber $diskNo | where DriveLetter -like $driveLetter | select -ExpandProperty Offset)/512

$myJson | ConvertTo-Json 

# file system 
$myJson.fs.type = Get-Volume | where DriveLetter -like $driveLetter | select -ExpandProperty FileSystemType
$myJson.fs.name = Get-Volume | where DriveLetter -like $driveLetter | select -ExpandProperty FileSystemLabel
$myJson.fs.id = Get-Partition -DiskNumber $diskNo | where DriveLetter -like $driveLetter | select -ExpandProperty Guid
$myJson.fs.sourceos = ""


$myJson | ConvertTo-Json 

# create objects in fs, record infos in json

new-Item "${driveLetter}:\file.0" -ItemType File
make-filejson -fileName "file.0" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\file.binary" -ItemType File
$data = new-object byte[] 10kb 
(new-object Random).NextBytes($data)
[IO.File]::WriteAllBytes("${driveLetter}:\file.binary", $data)
make-filejson -fileName "file.binary" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\file.txt" -ItemType File
# select characters from 0-9, A-Z, and a-z
$chars = [char[]] ([char]'0'..[char]'9' + [char]'A'..[char]'Z' + [char]'a'..[char]'z')
$chars = $chars * 126
# write file using 128 byte lines each with 126 random characters
(1..(10kb/128)).foreach({-join (Get-Random $chars -Count 126) | add-content "${driveLetter}:\file.txt" })
make-filejson -fileName "file.txt" -filePath "${driveLetter}:\"
		
new-Item "${driveLetter}:\delfile" -ItemType File
$data = new-object byte[] 10kb 
(new-object Random).NextBytes($data)
[IO.File]::WriteAllBytes("${driveLetter}:\delfile", $data)
make-filejson -fileName "delfile" -filePath "${driveLetter}:\"
Remove-Item "${driveLetter}:\delfile" -force

new-Item "${driveLetter}:\subdir" -ItemType Directory
make-filejson -fileName "subdir" -filePath "${driveLetter}:\"

new-Item "${driveLetter}:\subdir\file2.txt" -ItemType File
# select characters from 0-9, A-Z, and a-z
$chars = [char[]] ([char]'0'..[char]'9' + [char]'A'..[char]'Z' + [char]'a'..[char]'z')
$chars = $chars * 126
# write file using 128 byte lines each with 126 random characters
(1..(10kb/128)).foreach({-join (Get-Random $chars -Count 126) | add-content "${driveLetter}:\file2.txt" })
make-filejson -fileName "file2.txt" -filePath "${driveLetter}:\subdir"

$myJson | ConvertTo-Json 

# write json file
$myJson | ConvertTo-Json > $resultFile
