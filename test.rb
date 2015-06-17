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
  op = Classifier::Bayes.new("a", "b", "c")
end

mecab = MeCab::Tagger.new("-O wakati")

s = "もうやめたい"

puts op.classifications(mecab.parse(s)).inspect
puts op.classify(mecab.parse(s))
