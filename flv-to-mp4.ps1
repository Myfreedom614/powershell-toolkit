$viddir = ls -filter *.flv
foreach ($video in $viddir)
{
  $newname = ([io.path]::GetFileNameWithoutExtension($video))
  IF (-Not (Test-Path "$newname.mp4") -Or (Get-Item "$newname.mp4").length -eq 0kb){
      ffmpeg.exe -i $video -c copy "$newname.mp4"
      IF (Test-Path "$newname.mp4") {
        If ((Get-Item "$newname.mp4").length -gt 0kb) {
          Remove-Item $video
        }
      }
  }
}