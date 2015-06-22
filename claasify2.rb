require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

begin
  op = nil
  co = nil
  ex = nil
  ag = nil
  ne = nil
  File.open("bayes_op2", "r") do |f|
    op = Marshal.load(f)
  end
  File.open("bayes_co2", "r") do |f|
    co = Marshal.load(f)
  end
  File.open("bayes_ex2", "r") do |f|
    ex = Marshal.load(f)
  end
  File.open("bayes_ag2", "r") do |f|
    ag = Marshal.load(f)
  end
  File.open("bayes_ne2", "r") do |f|
    ne = Marshal.load(f)
  end
rescue
  op = Classifier::Bayes.new("0","1")
  co = Classifier::Bayes.new("0","1")
  ex = Classifier::Bayes.new("0","1")
  ag = Classifier::Bayes.new("0","1")
  ne = Classifier::Bayes.new("0","1")
end

me = MeCab::Tagger.new

optr = opfa = cotr = cofa = extr = exfa = agtr = agfa = netr = nefa =  0

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
  opre = op.classify(doc).to_i
  core = co.classify(doc).to_i
  exre = ex.classify(doc).to_i
  agre = ag.classify(doc).to_i
  nere = ne.classify(doc).to_i
  CSV.foreach("per.csv") do |per|
    if id == per[0].to_i
      if(per[1].to_i < 30 && opre == 0)
        optr += 1
      elsif(per[1].to_i >= 30 && opre == 1)
        optr += 1
      else
        opfa += 1
      end
      if(per[2].to_i < 30 && core == 0)
        cotr += 1
      elsif(per[1].to_i >= 30 && core == 1)
        cotr += 1
      else
        cofa += 1
      end
      if(per[3].to_i < 30 && exre == 0)
        extr += 1
      elsif(per[1].to_i >= 30 && exre == 1)
        extr += 1
      else
        exfa += 1
      end
      if(per[4].to_i < 30 && agre == 0)
        agtr += 1
      elsif(per[1].to_i >= 30 && agre == 1)
        agtr += 1
      else
        agfa += 1
      end
      if(per[5].to_i < 30 && nere == 0)
        netr += 1
      elsif(per[1].to_i >= 30 && nere == 1)
        netr += 1
      else
        nefa += 1
      end
      break
    end
  end
end

oppr = (optr / (optr + opfa)) * 100.to_f
copr = (cotr / (cotr + cofa)) * 100.to_f
expr = (extr / (extr + exfa)) * 100.to_f
agpr = (agtr / (agtr + agfa)) * 100.to_f
nepr = (netr / (netr + nefa)) * 100.to_f
puts "#{oppr}%, #{copr}%, #{expr}%, #{agpr}%, #{nepr}%"
