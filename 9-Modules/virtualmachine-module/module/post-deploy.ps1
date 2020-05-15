#Install Web Server
Install-WindowsFeature -Name Web-Server




#Build Website


$website = '<h1 style="color: #5e9ca0; text-align: center;"><span style="color: #3366ff;">I just built the server webserver with Terraform!!!!</span></h1>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h2 style="text-align: center;"><strong>Time to Party!</strong></h2>
<p><strong><img style="display: block; margin-left: auto; margin-right: auto;" src="https://media.giphy.com/media/HqJmOe2M1Af9C/giphy.gif" width="530" height="353" /></strong></p>'


Set-Content "C:\inetpub\wwwroot\iisstart.htm" $website.Replace('webserver',"${webservername}")