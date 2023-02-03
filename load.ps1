param ($user,$password,$midname,$instance)

mkdir C:\SNMID
cd C:\SNMID
Invoke-WebRequest -Uri "https://install.service-now.com/glide/distribution/builds/package/app-signed/mid/2022/12/05/mid.tokyo-07-08-2022__patch4-11-23-2022_12-05-2022_2132.windows.x86-64.zip" -Outfile "mid.zip"
Expand-Archive -Path "mid.zip" -DestinationPath C:\SNMID
del "mid.zip"
cd mid
cd agent   
(Get-Content -path config.xml).replace('YOUR_MIDSERVER_NAME_GOES_HERE',$midname).replace('YOUR_INSTANCE_USER_NAME_HERE',$user).replace('YOUR_INSTANCE_PASSWORD_HERE',$password).replace('YOUR_INSTANCE',$instance) | Set-Content config.xml
./start.bat