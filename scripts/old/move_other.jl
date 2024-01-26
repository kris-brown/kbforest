src = "/Users/kristopherbrown/code/vault"
tgt = "/Users/kristopherbrown/code/kbforest/trees"

for (root, dirs, files) in walkdir(src)
  error("DON'T OVERWRITE")
  tgtdir = replace(root, src=>tgt)
  println("Directories in $root -> $tgtdir")
  ispath(tgtdir) || mkdir(tgtdir)

  if split(root,"/")[end] ∉ ["works", "people"] # already been moved by other scripts
    for file in filter(x->length(x)>3 && x[end-2:end] == ".md", files)
      srcfile = joinpath(root, file)
      txt = read(open(srcfile), String)
      !isnothing(match(r"title:(.+)", txt)) || println(srcfile)
      title = strip(match(r"title:(.+)", txt)[1])
      tgtfile = joinpath(tgtdir, join(lowercase.(split(title)),"-") * ".tree")
      _, header, body... = split(txt, "---")
      sep = match(r"\[SEP\]\((.+)\)", txt)
      title = something(match(r"title: (.+)", txt))[1]
      write(tgtfile, """\\title{$title}\n\n\\p{$(join(body,"---"))\n}
      """)
    end
  end
end    


