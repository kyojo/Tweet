require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

me = MeCab::Tagger.new
op = Classifier::Bayes.new("0","1")

Dir::glob("/Users/kei/tweet/sampling/**/*.csv").each do |f|
  pass = f.split("/")
  id = pass[5].to_i
  if id > 4000000
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
        if !(feat[0] == ("助詞"||"助動詞"||"フィラー")) && feat[6].length > 1
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
      if(per[1].to_i < 30)
        op.train("0", train)
      else
        op.train("1", train)
      end
      break
    end
  end
end

#bayes save
p op
File.open("bayes_data", "wb") do |f|
  Marshal.dump(op, f)
end
