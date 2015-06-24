require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

me = MeCab::Tagger.new
ave = [28, 25, 23, 27, 27]
pa = Array.new(5)
#0:op 1:co 2:ex 3:ag 4:ne
for n in 0..4
  pa[n] = Classifier::Bayes.new("0","1")
end

Dir::glob("/Users/kei/tweet/sampling/**/*.csv").each do |f|
  pass = f.split("/")
  id = pass[5].to_i
  if id > 5000000 || id == 0
    next
  end
  words = []

  #words collect
  File.open(f) do |file|
    while str = file.gets do
      str.force_encoding("UTF-8")
      str = str.scrub('?')
      twe = str.split(",")
      if twe[1].nil?
        next
      elsif twe[1].index("@") == 0
        next
      end
      node = me.parseToNode(twe[1])
      node = node.next
      while node.next do
        feat = node.feature.split(",")
        if !(feat[0] == ("名詞"||"動詞"||"連体詞"))
          words << feat[6]
        end
        node = node.next
      end
    end
  end

  #training
  train = words.join(" ")
  CSV.foreach("per.csv") do |per|
    if id == per[0].to_i
      for n in 0..4
        if(per[n+1].to_i <= ave[n])
          pa[n].train("0", train)
        else
          pa[n].train("1", train)
        end
      end
      break
    end
  end
end

#bayes save
for n in 0..4
  File.open("bayes_#{n}2", "wb") do |f|
    Marshal.dump(pa[n], f)
  end
end

