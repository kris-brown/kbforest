dir = "/Users/kristopherbrown/code/vault/people"
outdir = "/Users/kristopherbrown/code/forest/trees/people"
for fi in readdir(dir)
  error("DO NOT OVERWRITE WHAT IS IN trees/people without backing up first")
  pth = joinpath(dir, fi)
  println(pth)
  txt = read(open(pth), String)
  capname = strip(match(r"title:(.+)", txt)[1])
  names = split(capname)
  newfi = joinpath(outdir, join(lowercase.(names),"-") * ".tree")
  body = split(txt, "---")[end]
  sep = match(r"\[SEP\]\((.+)\)", txt)
  ext = isnothing(sep) ? "" : "\\meta{external}{$(only(sep))}"
  write(newfi, """\\title{$capname}
  \\taxon{person}
  \\tag{philosopher}
  $ext

  \\p{$body}
  """)
end