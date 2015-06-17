require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

cp = Classifier::Bayes.new("a", "b", "c")
mecab = MeCab::Tagger.new("-O wakati")

File.open("train.csv") do |f|
  while l = f.gets
    a = l.split(',')
    a[1].chomp!
    cp.train(a[1], mecab.parse(a[0]))
  end
end

s = "もうやめたい"

puts cp.classifications(mecab.parse(s)).inspect
puts cp.classify(mecab.parse(s))
