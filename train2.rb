require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

me = MeCab::Tagger.new
ave = [28, 25, 23, 27, 27]
pa = Array.new(5)
fw = Array.new(5){Array.new()}
#0:op 1:co 2:ex 3:ag 4:ne
for n in 0..4
  pa[n] = Classifier::Bayes.new("0","1")
end

i = 0
CSV.foreach("gain.csv") do |gw|
  j = 0
  for wd in gw
    fw[i] << wd
    j += 1
    if j == 5000
      break
    end
  end
  i += 1
end

Dir::glob("/Users/kei/tweet/sampling/**/*.csv").each do |f|
  pass = f.split("/")
  id = pass[5].to_i
  if id < 6300000
    next
  end
  words = []
  count = 0

  #words collect
  File.open(f) do |file|
    while str = file.gets do
      if count > 40000
        break
      end
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
        if !(feat[0] == ("名詞"||"動詞"))
          words << feat[6]
          count += 1
        end
        node = node.next
      end
    end
  end

  tra = Array.new(5){Array.new()}
  train = Array.new(5)
  for n in 0..4
    for wd in words
      if fw[n].include?(wd)
        tra[n] << wd
      end
    end
    train[n] = tra[n].join(" ")
  end

  #training
  CSV.foreach("per.csv") do |per|
    if id == per[0].to_i
      for n in 0..4
        if(per[n+1].to_i <= ave[n])
          pa[n].train("0", train[n])
        else
          pa[n].train("1", train[n])
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

