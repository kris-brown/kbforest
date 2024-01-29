for (_, _, files) in walkdir("output")
  for fi in files 
    if '?' ∈ fi || '#' ∈ fi 
      error("Bad filename $fi")
    end 
  end
end