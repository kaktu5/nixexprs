#!/usr/bin/env nu

let sources_path = ($env.FILE_PWD | path join "sources.json")
mut sources = open $sources_path

let releases = http get "https://api.github.com/repos/ppy/osu/releases"
let lazer_release = $releases | where prerelease == false | first
let tachyon_release = $releases | where prerelease == true | first

if $lazer_release.tag_name != $sources.lazer.version {
  let lazer_url = $"https://github.com/ppy/osu/releases/download/($lazer_release.tag_name)/osu.AppImage"
  let lazer_hash = (^nix store prefetch-file --json $lazer_url | from json).hash

  $sources.lazer = {
    version: $lazer_release.tag_name,
    url: $lazer_url,
    hash: $lazer_hash,
  }

  print $"osu-lazer-bin: updated osu!lazer to ($lazer_release.tag_name)"
}

if $tachyon_release.tag_name != $sources.tachyon.version {
  let tachyon_url = $"https://github.com/ppy/osu/releases/download/($tachyon_release.tag_name)/osu.AppImage"
  let tachyon_hash = (^nix store prefetch-file --json $tachyon_url | from json).hash

  $sources.tachyon = {
    version: $tachyon_release.tag_name,
    url: $tachyon_url,
    hash: $tachyon_hash,
  }

  print $"osu-lazer-bin: updated osu!lazer \(tachyon\) to ($tachyon_release.tag_name)"
}

$sources | to json | save -f $sources_path
