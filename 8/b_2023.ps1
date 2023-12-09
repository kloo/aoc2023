<#

#>

$strarray = Get-Content ina.txt
#$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Find-GCD {
    Param (
        [int64] $numA,
        [int64] $numB
    )

    if ($numB -eq 0) {
        return $numA
    } else {

        return Find-GCD $numB ($numA % $numB)
    }
    
}

Function Find-LCM {
    Param (
        [int64[]] $inputlist
    )

    $output = $inputlist[0]

    for ($i = 1; $i -lt $inputlist.Length;$i++) {
        $output = ($inputlist[$i] * $output) / (Find-GCD $inputlist[$i] $output)
    }

    return $output
    
}

$path = $strarray[0]
$routes = @{}

$currPointList = @()

for ($i = 2;$i -lt $strarray.Length;$i++) {
   $line = $strarray[$i]
   $line = $line.Split(" ")
   
   $currKey = $line[0]
   $leftPath = $line[2].Substring(1,3)
   $rightPath = $line[3].Substring(0,3)

   $routes.Add($currKey, @($leftPath,$rightPath))

   if ($currKey[2] -eq "A") {
        $currPointList += $currKey
   }
}

$i = 0
$pathLength = $path.Length


$currPointLengths = @()

foreach ($point in $currPointList) {
    $i = 0
    $currPoint = $point

    while ($currPoint[2] -ne "Z") {
        $direction = $path[($i % $pathLength)]

        if ($direction -eq "L") {
            $currPoint = $routes[$currPoint][0]
        } else {
            $currPoint = $routes[$currPoint][1]
        }

        $i++
    }

    $currPointLengths += $i
}

$pointCount = $currPointList.Length

$currPointLengths = $currPointLengths | Sort -Descending

Find-LCM $currPointLengths

#Write-Host $currAnswer