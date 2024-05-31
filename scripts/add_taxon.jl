PTH, TAXON = ARGS
for fi in joinpath.(PTH, readdir(PTH))
  s = read(fi, String)
  m = match(r"\\taxon{(.+?)}", s)
  if isnothing(m)
    lines = split(s,"\n")
    insert!(lines, 2, "\\taxon{$(TAXON)}")
    write(fi, join(lines, "\n"))
  else
    only(m) == TAXON || error("Bad taxon at $fi: $m")
  end
end