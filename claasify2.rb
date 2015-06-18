require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

begin
  op = nil
  File.open("bayes_data", "r") do |f|
    op = Marshal.load(f)
  end
rescue
  op = Classifier::Bayes.new("0","1")
end

me = MeCab::Tagger.new

correct = 0
fault = 0

Dir::glob("/Users/kei/tweet/sampling/**/*.csv").each do |f|
  pass = f.split("/")
  id = pass[5].to_i
  if id < 4000000
    next
  end
  words = []

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

  doc = words.join(" ")
  result = op.classify(doc).to_i
  CSV.foreach("per.csv") do |per|
    if id == per[0].to_i
      if(per[1].to_i < 30 && result == 0)
        correct += 1
      elsif(per[1].to_i >= 30 && result == 1)
        correct += 1
      else
        fault += 1
      end
      break
    end
  end
end

puts correct
puts fault
pro = (correct / (correct + fault)) * 100.to_f
puts "#{pro}%"
