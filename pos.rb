require 'csv'
require 'MeCab'
require 'rubygems'
require 'classifier'
require 'stemmer'

me = MeCab::Tagger.new
meisi = 0
dousi = 0
hukusi = 0
keiyousi = 0
kandousi = 0
zyosi = 0
setuzokusi = 0
zyodousi = 0
rentaisi = 0
fira = 0
sonota = 0
kigou = 0
setousi = 0

Dir::glob("/Users/kei/tweet/sampling/**/*.csv").each do |f|
  pass = f.split("/")
  id = pass[5].to_i

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
        if (feat[0] == ("名詞"))
          meisi += 1
        elsif (feat[0] == ("動詞"))
          dousi += 1
        elsif (feat[0] == ("副詞"))
          hukusi += 1
        elsif (feat[0] == ("形容詞"))
          keiyousi += 1
        elsif (feat[0] == ("感動詞"))
          kandousi += 1
        elsif (feat[0] == ("助詞"))
          zyosi += 1
        elsif (feat[0] == ("接続詞"))
          setuzokusi += 1
        elsif (feat[0] == ("助動詞"))
          zyodousi += 1
        elsif (feat[0] == ("連体詞"))
          rentaisi += 1
        elsif (feat[0] == ("記号"))
          kigou += 1
        elsif (feat[0] == ("接頭詞"))
          setousi += 1
        elsif (feat[0] == ("フィラー"))
          fira += 1
        else
          sonota += 1
        end
        node = node.next
      end
    end
  end
end

puts "名詞:#{meisi}\n動詞:#{dousi}\n副詞:#{hukusi}\n形容詞:#{keiyousi}\n感動詞:#{kandousi}\n助詞:#{zyosi}\n接続詞:#{setuzokusi}\n助動詞:#{zyodousi}\n連体詞:#{rentaisi}\n記号:#{kigou}\n接頭詞:#{setousi}\nフィラー:#{fira}\nその他:#{sonota}"
