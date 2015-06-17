File.open("revised_data.csv") do |f|
  while str = f.gets do
    str.force_encoding("UTF-8")
    str = str.scrub('?')
    id = str.split(",")
    puts id[0]
    #puts id[27]
  end
end
