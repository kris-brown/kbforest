dir = "/Users/kristopherbrown/code/vault/works"
outdir = "/Users/kristopherbrown/code/kbforest/trees/refs"
for fi in readdir(dir)
  # error("DO NOT OVERWRITE WHAT IS IN trees/refs without backing up first")
  pth = joinpath(dir, fi)
  println(pth)
  txt = read(open(pth), String)
  capname = strip(match(r"title:(.+)", txt)[1])
  names = split(capname)
  newfi = joinpath(outdir, join(lowercase.(names),"-") * ".tree")
  _, header, body... = split(txt, "---")
  sep = match(r"\[SEP\]\((.+)\)", txt)
  println("capname $capname")
  author = match(r"author: (.+)", txt)
  author = if isnothing(author)
    match(r"\[\[(.+)\|Author\]\]", body[1])[1]
  else 
    author[1]
  end
  title = something(match(r"title: (.+)", txt))[1]
  write(newfi, """\\title{$title}
  \\taxon{reference}
  \\author{$author}

  \\notes{$(join(body,"---"))}
  """)
end