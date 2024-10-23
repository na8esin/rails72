require 'rails_helper'

# あるクラスが依存しているクラスのnewを通過する引数を検査したい時のサンプル
#
# 前提知識:
#   pure test doubleとpartial doubleと言うものがある
#   そして、`and_call_original` is only available on a partial double.
#
# 断片的にコードをブログに載せるときは、described_classだとわからないので、あまり使ってない
#
#
RSpec.describe User, type: :model do
  it 'まず初めに、依存してるクラスのnewに引数を入れない場合を考える' do
    # 依存してるクラスのnewをstubして、ダブルを仕込む
    moc = instance_double(ExternalApi)
    allow(ExternalApi).to receive(:new).and_return(moc)

    # 冗長だけど、↓のコードがないと
    # #<InstanceDouble(ExternalApi) (anonymous)> received unexpected message :fetch with (no args)
    # が発生する
    allow(moc).to receive(:fetch).and_return('hello')

    expect(User.new.fetch_external).to eq('hello')
  end

  it '依存しているクラスのnewをスタブ化して、newの引数を検査する' do
    # これだけで、partial doubleになるし、fetchメソッドもそのまま
    allow(ExternalApi).to receive(:new).and_call_original

    User.new.fetch_external_with_initial_value

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end

  context '.greet' do
    it 'class_spyだけだとExternalApi自体を書き換えてくれるわけじゃない' do
      spy_api = class_spy(ExternalApi)

      User.greet

      # received: 0 times with any arguments
      expect(spy_api).to have_received :greet
    end

    it 'class_spyで作成したdoubleはテストコードの中では使える。当たり前か。' do
      spy_api = class_spy(ExternalApi)

      p spy_api.greet # #<ClassDouble(ExternalApi) (anonymous)>

      # ここは成功する。当たり前か
      expect(spy_api).to have_received :greet
    end

    it 'as_stubbed_constを使うとExternalApi自体を書き換えてくれる' do
      spy_api = class_spy(ExternalApi).as_stubbed_const

      sample = User.greet

      # as_stubbed_constを使うと、ExternalApi自体を書き換えてくれる
      expect(spy_api).to have_received :greet
      # でも "good evening" を返してくれない
      expect(sample).to eq("good evening") # got: #<ClassDouble(ExternalApi) (anonymous)>
    end

    it 'as_stubbed_constを使って、greetの戻り値を変更する' do
      spy_api = class_spy(ExternalApi).as_stubbed_const
      expect(spy_api).to receive(:greet).and_return("Good night!")

      sample = User.greet

      # #<ClassDouble(ExternalApi) (anonymous)> expected to have received greet, but that method has been mocked instead of stubbed or spied.
      # expect(spy_api).to have_received :greet
      # この場面だと、have_receivedと一緒に使う必要なないか。
      expect(sample).to eq("Good night!")
    end
  end

  context '.new' do
    it 'say Good morning(ダメな例)' do
      spy_api = class_spy(ExternalApi)

      User.new.fetch_external_with_initial_value

      # the ExternalApi class does not implement the class method: fetch. Perhaps you meant to use `instance_double` instead?
      expect(spy_api).to have_received :fetch
    end

    # https://stackoverflow.com/questions/38445625/rspec-class-spy-on-rails-mailer
    # 参考にした場合
    it 'say Good morning' do
      spy_api = class_spy(ExternalApi).as_stubbed_const

      User.new.fetch_external_with_initial_value

      expect(spy_api).to have_received :fetch
    end
  end

  context 'use class_double' do
    # https://github.com/rspec/rspec-mocks/blob/134b1acf5d357b09df1f4516392d50c82634f109/spec/rspec/mocks/expiration_spec.rb#L79
    it 'sample1' do
      dbl = class_double('ExternalApi', greet: 'Guten Morgen')
      p dbl.greet
      p User.greet
    end
  end
end
