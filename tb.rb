require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

DIC = {
  ipadic: '/usr/local/Cellar/mecab/0.996/lib/mecab/dic/ipadic',
  jumandic: '/usr/local/Cellar/mecab/0.996/lib/mecab/dic/jumandic',
  unidic: '/usr/local/Cellar/mecab/0.996/lib/mecab/dic/unidic',
}
me = MeCab::Tagger.new
words = []

File.open("hiroki4342.csv") do |f|
  while str = f.gets do
  #for n in 0..3 do
    #str = f.readline
    str.force_encoding("UTF-8")
    str = str.scrub('?')
    id = str.split(",")
    puts id[1]
    if id[1].nil?
      next
    elsif id[1].index("RT") == 0 || id[1].index("@") == 0
      next
    end
    node = me.parseToNode(id[1])
    node = node.next
    while node.next do
      feat = node.feature.split(",")
      #if (feat[0] == "名詞")
      if !(feat[0] == ("助詞"||"助動詞"||"フィラー")) && feat[6].length > 1
        words << feat[6]
      end
      node = node.next
    end
  end
end

count = {}
for wd in words do
  if count.include?(wd)
    count[wd] += 1
  else
    count[wd] = 1
  end
end

count = count.sort_by{|key,val| -val}

File.open("count.csv", 'w') do |f|
  count.each do |wd,ct|
    if ct == 1
      break
    end
    f.write "#{wd},#{ct}\n"
  end
end

