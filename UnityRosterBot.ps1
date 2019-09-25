$key = Get-AutomationVariable -Name 'googleAPIKey'
$bot_token = Get-AutomationVariable -Name 'bot_token'
$channelID = Get-AutomationVariable -Name 'channelID'
$webhookID = Get-AutomationVariable -Name 'webhookID'
$webhook_token = Get-AutomationVariable -Name 'webhook_token'
$spreadsheetID = Get-AutomationVariable -Name 'spreadsheetID'

class Class {
    [string]$name
    [string]$range
    [string]$embedNameString
    [string]$embedLevelString
}

class Field {
    [string]$name
    [string]$value
    [bool]$inline
}

class Embed {
    [string]$title
    [int]$color
    [string]$url
    [string]$description
    [string]$timestamp
    [Field[]]$fields
}

$warrior = [Class]::new()
$warrior.name = "Warrior"
$warrior.range = "C4:D50"

$rogue = [Class]::new()
$rogue.name = "Rogue"
$rogue.range = "G4:H50"

$hunter = [Class]::new()
$hunter.name = "Hunter"
$hunter.range = "K4:L50"

$mage = [Class]::new()
$mage.name = "Mage"
$mage.range = "O4:P50"

$warlock = [Class]::new()
$warlock.name = "Warlock"
$warlock.range = "S4:T50"

$paladin = [Class]::new()
$paladin.name = "Paladin"
$paladin.range = "W4:X50"

$priest = [Class]::new()
$priest.name = "Priest"
$priest.range = "AA4:AB50"

$druid = [Class]::new()
$druid.name = "Druid"
$druid.range = "AE4:AF50"

$classArray = @(
    $warrior
    $rogue
    $hunter
    $mage
    $warlock
    $paladin
    $priest
    $druid
)


foreach($class in $classArray){
    $nameString = $null
    $levelString = $null

    try {
        $classMemberList = (Invoke-RestMethod -Method Get -Uri "https://sheets.googleapis.com/v4/spreadsheets/$($spreadsheetID)/values/$($class.range)?key=$($key)").values
    }
    catch {
        # tshoot API calls
        $_
    }

    foreach($member in $classMemberList){
        $classHash = @{
            Name = $member[0]
            Level = $member[1]
        }
        if($classHash.Name){
            $nameString = $nameString + $classHash.Name + '\n'
        }else{break}
        if($classHash.Level){
            $levelString = $levelString + $classHash.Level + '\n'
        }else{break}
    }

    $class.embedNameString = $nameString
    $class.embedLevelString = $levelString

}

$titleEmbed = [Embed]::new()
$titleEmbed.title = '**' + "Current Roster Progression" + '**'
$titleEmbed.color = 2599374
$titleEmbed.timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ")
$titleEmbed.url = "https://docs.google.com/spreadsheets/d/$($spreadsheetID)"
$titleEmbed.description = "List of current active <Unity> members"

$embeds = @(
    $titleEmbed
)

foreach ($class in $classArray){
    $nameField = [Field]::new()
    $nameField.name = '__' + "Name" + '__'
    $nameField.value = $class.embedNameString
    $nameField.inline = $true

    $levelField = [Field]::new()
    $levelField.name = '__' + "Level" + '__'
    $levelField.value = $class.embedLevelString
    $levelField.inline = $true

    $fields = @(
        $nameField
        $levelField
    )

    $embed = [Embed]::new()
    $embed.title = '**' + $class.name + '**'
    $embed.color = 2599374
    $embed.fields = $fields

    $embeds += $embed
}

$headers = @{
    Authorization = "Bot $($bot_token)"
}

$messages = Invoke-RestMethod -Uri "https://discordapp.com/api/channels/$($channelID)/messages" -Method Get -Headers $headers -ContentType 'application/json'

$messageIDs = @()
foreach ($message in $messages){
    $messageIDs += $message.id
}

$payload = @{
    messages = $messageIDs
}

$body = ($payload | ConvertTo-Json -Depth 100)

if($messageIDs.Count -lt 2){
    invoke-restmethod -uri "https://discordapp.com/api/channels/$($channelID)/messages/$($messageIDs)" -Method Delete -Headers $headers -ContentType 'application/json'
}
else{
    invoke-restmethod -uri "https://discordapp.com/api/channels/$($channelID)/messages/bulk-delete" -Method Post -Headers $headers -Body $body -ContentType 'application/json'
}
$payload = @{
    embeds = $embeds
}

$body = ($payload | ConvertTo-Json -Depth 100).Replace('\\n','\n')

try {
    $response = Invoke-RestMethod -Method Post -Uri "https://discordapp.com/api/webhooks/$($webhookID)/$($webhook_token)" -Body $body
}
catch {
    $_.ErrorDetails
}