#Get path to place new users
$objOU = [ADSI]"LDAP://CN=Users,DC=groupE,DC=sqrawler,DC=com"

#Get file with new user details
$dataSource = import-csv "C:\Users\nratu\Documents\GitHub\CreateUserAD\CSV\user.csv"

#Loop through the csv file and add data to objOU
foreach($dataRecord in $dataSource)
{
    #Assign variables with data from user.csv
	$cn = $dataRecord.FirstName + " " + $dataRecord.LastName
	$sAMAccountName = $dataRecord.FirstName + "." + $dataRecord.LastName
	$givenName = $dataRecord.FirstName
	$sn = $dataRecord.LastName
	$sAMAccountName = $sAMAccountName.ToLower()
	$displayName = $sn + "," + $givenName
    $userPrinc = $sAMAccountName + "@groupE.sqrawler.com"
	
    #Create the user and its attributes
	$objUser = $objOU.Create("user", "CN=" + $cn)
	$objUser.Put("sAMAccountName", $sAMAccountName)
    $objUser.Put("userPrincipalName", $userPrinc)
	$objUser.Put("displayName", $displayName)
	$objUser.Put("givenName", $givenName)
	$objUser.Put("sn", $sn)


	$objUser.SetInfo()
    $objUser.SetPassword($dataRecord.Password)
	$objUser.psbase.InvokeSet("AccountDisabled", $false)
	$objUser.SetInfo()

}