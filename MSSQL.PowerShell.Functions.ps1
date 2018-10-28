function Get-SqlConnectionString
{
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$SqlServer,
		[Parameter(Mandatory = $true)]
		[string]$SqlDatabase,
		[string]$SqlUserName,
		[string]$SqlUserPassword
	)
	
	if ([string]::IsNullOrEmpty($SqlUserName) -or [string]::IsNullOrEmpty($SqlUserPassword))
	{
		return "Data Source=$SqlServer; Initial Catalog=$SqlDatabase; Integrated Security=True"
		
	}
	else
	{
		return "Data Source=$SqlServer; Initial Catalog=$SqlDatabase; User ID=$SqlUserName; Password=$SqlUserPassword"
	}
}

function Test-SQLConnectionString
{
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $true)]
		$SqlConnectionString
	)
	
	if ([string]::IsNullOrEmpty($SqlConnectionString))
	{
		return $false;
	}
	
	$cn = New-Object System.Data.SqlClient.SqlConnection($SqlConnectionString);
	$da = New-Object System.Data.SqlClient.SqlDataAdapter;
	$dt = New-Object System.Data.DataTable;
	$cmd = New-Object System.Data.SqlClient.SqlCommand("SELECT CAST(1 AS BIT) AS ConnectionSuccess", $cn);
	$cmd.CommandTimeout = 60
	$cmd.CommandType = [System.Data.CommandType]::Text
	$cn.Open();
	$da.SelectCommand = $cmd;
	[void]$da.Fill($dt);
	$cn.Close();
	
	if ($dt -eq $null)
	{
		return $false;
	}
	elseif ($dt.Rows.Count -eq 0)
	{
		return $false;
	}
	else
	{
		return $dt.Rows[0]["ConnectionSuccess"];
	}
}

function Get-SqlQueryDataTable
{
	[OutputType([System.Data.DataTable])]
	param
	(
		[Parameter(Mandatory = $true)]
		$SqlQueryText,
		[Parameter(Mandatory = $true)]
		$SqlConnectionString
	)
	
	$cn = New-Object System.Data.SqlClient.SqlConnection($SqlConnectionString);
	$da = New-Object System.Data.SqlClient.SqlDataAdapter;
	$dt = New-Object System.Data.DataTable;
	$cmd = New-Object System.Data.SqlClient.SqlCommand($SqlQueryText, $cn);
	$cmd.CommandTimeout = 60
	$cmd.CommandType = [System.Data.CommandType]::Text
	$cn.Open();
	$da.SelectCommand = $cmd;
	[void]$da.Fill($dt);
	$cn.Close();
	
	return $dt;
}