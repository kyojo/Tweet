Dir::glob("/Users/kei/tweet/sampling/**/*.csv.gz").each do |f|
  result = system("gzip -d #{f}")
  puts result
end
