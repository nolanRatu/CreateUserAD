$objOU = [ADSI]"LDAP://CN=Users,DC=groupE,DC=sqrawler,DC=com"
$dataSource = import-csv "C:\Users\nratu\Desktop\user.csv"

foreach($dataRecord in $dataSource)
{
	$cn = $dataRecord.FirstName + " " + $dataRecord.LastName
	$sAMAccountName = $dataRecord.LoginAccount
	$givenName = $dataRecord.FirstName
	$sn = $dataRecord.LastName
	$userPassword = $dataRecord.Password
	$sAMAccountName = $sAMAccountName.ToLower()
	$displayName = $sn + ", " + $givenName
	
	$objUser = $objOU.Create("user", "CN=" + $cn)
	$objUser.Put("sAMAccountName", $sAMAccountName)
	$objUser.Put("displayName", $displayName)
	$objUser.Put("givenName", $givenName)
	$objUser.Put("sn", $sn)
	$objUser.Put("userPassword", $userPassword)

	$objUser.setInfo()
	$objUser.psbase.InvokeSet("AccountDisabled", $false)
	$objUser.setInfo()

}