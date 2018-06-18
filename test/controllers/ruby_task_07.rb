require 'prime'

def prime_number
  generator = Prime::EratosthenesGenerator.new
  #インスタンスメソッドにnext succ rewindを持っている。
  #素数の生成にエラトステネスのふるいを使用する。
  #内部的な列挙位置を進める。→インスタンスの中に素数をおそらく変数として保持してくれているらしい。
  array = []
  Proc.new do
    #ここにgenerator~を置くと毎回別のgeneratorができちゃって列挙できないぞ。
    array << generator.next
    #内部的な列挙位置を進める。同じインスタンス(generator)なら列挙していってくれる。
    #Procオブジェクトはクロージャ（生成された時の変数情報などを保持しているメソッドのこと）として振る舞う。
  end
end


prime_number_proc1 = prime_number
p prime_number_proc1 # 別々のProcができているぞ！
p prime_number_proc1.call
p prime_number_proc1.call
p prime_number_proc1.call
p prime_number_proc1.call
p prime_number_proc1.call
p prime_number_proc1.call

prime_number_proc2 = prime_number #新しく作り直しているから上のgeneratorと別物だ！
p prime_number_proc2
p prime_number_proc2.call
p prime_number_proc2.call
p prime_number_proc2.call
p prime_number_proc2.call
p prime_number_proc2.call
p prime_number_proc2.call

generator2 = Prime::EratosthenesGenerator.new
p generator2.next
p generator2.next
p generator2.next

generator3 = Prime::EratosthenesGenerator.new
p generator3.next
p generator3.next
p generator3.next
