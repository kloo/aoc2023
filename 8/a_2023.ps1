<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Test-Func {
    Param (
        [System.Collections.Specialized.OrderedDictionary] $playerOneDeck,
        [System.Collections.Specialized.OrderedDictionary] $playerTwoDeck
    )
    
}

$path = $strarray[0]
$routes = @{}

for ($i = 2;$i -lt $strarray.Length;$i++) {
   $line = $strarray[$i]
   $line = $line.Split(" ")
   
   $currKey = $line[0]
   $leftPath = $line[2].Substring(1,3)
   $rightPath = $line[3].Substring(0,3)

   $routes.Add($currKey, @($leftPath,$rightPath))
}

$currPoint = "AAA"
$i = 0
$pathLength = $path.Length

while ($currPoint -ne "ZZZ") {
    $direction = $path[($i % $pathLength)]

    if ($direction -eq "L") {
        $currPoint = $routes[$currPoint][0]
    } else {
        $currPoint = $routes[$currPoint][1]
    }

    $i++
}

Write-Host $i