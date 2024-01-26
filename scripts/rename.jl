for (i, fi) in enumerate(readdir(ARGS[1]))
  si = string(i)
  num = ARGS[2]*"-"*join(fill("0", 4-length(si)))*si*".tree"
  mv(joinpath(ARGS[1], fi), joinpath(ARGS[1], num))  
end