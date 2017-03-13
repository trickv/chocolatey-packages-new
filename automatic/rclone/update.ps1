import-module au

$releases32 = 'http://downloads.rclone.org/rclone-current-windows-386.zip'
$releases64 = 'http://downloads.rclone.org/rclone-current-windows-amd64.zip'
$github_releases = 'https://github.com/ncw/rclone/releases'

function global:au_SearchReplace {
   @{
        ".\rclone.nuspec" = @{
            '("rclone\.install"\sversion=)(".*")'  = "`$1'$($Latest.version)'"
        }
    }
}
function global:au_BeforeUpdate {
    
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $github_releases -UseBasicParsing
    
    $re = '\.zip$'
    $url   = $download_page.links | ? href -match $re | select -First 1 -expand href

    $version  = ($url -split '/' | select -Last 1 -Skip 1) -split 'v' | select -Last 1

    @{
        Version      = $version
        URL32        = $releases32
        URL64        = $releases64
        ReleaseNotes = ''
    }
}

try {
    update -ChecksumFor none
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}